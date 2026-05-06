#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 2 ]]; then
  cat >&2 <<'USAGE'
Usage: generate_pptx.sh slides.tsv output.pptx

slides.tsv columns:
  type<TAB>title<TAB>body<TAB>notes

Supported types: title, section, content, comparison, summary
Use literal \n inside body or notes for line breaks.
USAGE
  exit 64
fi

SLIDES_TSV="$1"
OUTPUT_PPTX="$2"

[[ -f "$SLIDES_TSV" ]] || { echo "slides.tsv not found: $SLIDES_TSV" >&2; exit 66; }
command -v zip >/dev/null 2>&1 || { echo "zip is required to package PPTX" >&2; exit 69; }

WORKDIR="$(mktemp -d)"
trap 'rm -rf "$WORKDIR"' EXIT

mkdir -p "$WORKDIR/_rels" "$WORKDIR/docProps" "$WORKDIR/ppt/_rels" \
  "$WORKDIR/ppt/slides/_rels" "$WORKDIR/ppt/slides" \
  "$WORKDIR/ppt/slideMasters/_rels" "$WORKDIR/ppt/slideMasters" \
  "$WORKDIR/ppt/slideLayouts/_rels" "$WORKDIR/ppt/slideLayouts" \
  "$WORKDIR/ppt/theme"

xml_escape() {
  local s="$1"
  s="${s//&/&amp;}"; s="${s//</&lt;}"; s="${s//>/&gt;}"
  s="${s//\"/&quot;}"; s="${s//\'/&apos;}"
  printf '%s' "$s"
}

paras() {
  local text="${1//\\n/$'\n'}" size="${2:-1700}" color="${3:-586174}" line
  while IFS= read -r line || [[ -n "$line" ]]; do
    [[ -z "$line" ]] && line=" "
    printf '<a:p><a:r><a:rPr lang="en-US" sz="%s"><a:solidFill><a:srgbClr val="%s"/></a:solidFill></a:rPr><a:t>%s</a:t></a:r></a:p>' \
      "$size" "$color" "$(xml_escape "$line")"
  done <<< "$text"
}

text_box() {
  local id="$1" name="$2" x="$3" y="$4" cx="$5" cy="$6" text="$7" size="$8" color="$9" bold="${10:-0}" b=""
  [[ "$bold" == "1" ]] && b=' b="1"'
  cat <<XML
<p:sp><p:nvSpPr><p:cNvPr id="$id" name="$name"/><p:cNvSpPr txBox="1"/><p:nvPr/></p:nvSpPr><p:spPr><a:xfrm><a:off x="$x" y="$y"/><a:ext cx="$cx" cy="$cy"/></a:xfrm><a:prstGeom prst="rect"><a:avLst/></a:prstGeom><a:noFill/><a:ln><a:noFill/></a:ln></p:spPr><p:txBody><a:bodyPr wrap="square" anchor="top"/><a:lstStyle/><a:p><a:r><a:rPr lang="en-US" sz="$size"$b><a:solidFill><a:srgbClr val="$color"/></a:solidFill></a:rPr><a:t>$(xml_escape "$text")</a:t></a:r></a:p></p:txBody></p:sp>
XML
}

body_box() {
  local id="$1" name="$2" x="$3" y="$4" cx="$5" cy="$6" text="$7" size="$8" color="$9"
  cat <<XML
<p:sp><p:nvSpPr><p:cNvPr id="$id" name="$name"/><p:cNvSpPr txBox="1"/><p:nvPr/></p:nvSpPr><p:spPr><a:xfrm><a:off x="$x" y="$y"/><a:ext cx="$cx" cy="$cy"/></a:xfrm><a:prstGeom prst="rect"><a:avLst/></a:prstGeom><a:noFill/><a:ln><a:noFill/></a:ln></p:spPr><p:txBody><a:bodyPr wrap="square" anchor="top"/><a:lstStyle/>$(paras "$text" "$size" "$color")</p:txBody></p:sp>
XML
}

rect() {
  local id="$1" name="$2" x="$3" y="$4" cx="$5" cy="$6" fill="$7" alpha="${8:-100000}"
  cat <<XML
<p:sp><p:nvSpPr><p:cNvPr id="$id" name="$name"/><p:cNvSpPr/><p:nvPr/></p:nvSpPr><p:spPr><a:xfrm><a:off x="$x" y="$y"/><a:ext cx="$cx" cy="$cy"/></a:xfrm><a:prstGeom prst="roundRect"><a:avLst/></a:prstGeom><a:solidFill><a:srgbClr val="$fill"><a:alpha val="$alpha"/></a:srgbClr></a:solidFill><a:ln><a:noFill/></a:ln></p:spPr></p:sp>
XML
}

slide_xml() {
  local idx="$1" type="$2" title="$3" body="$4"
  local bg="F7F4EE" primary="172033" accent="2F7D7E" muted="586174" card="FFFFFF"
  [[ "$type" == "section" ]] && { bg="E8F1EF"; accent="B95C3B"; }

  if [[ "$type" == "title" ]]; then
    cat <<XML
<?xml version="1.0" encoding="UTF-8" standalone="yes"?><p:sld xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main"><p:cSld><p:bg><p:bgPr><a:solidFill><a:srgbClr val="$primary"/></a:solidFill></p:bgPr></p:bg><p:spTree><p:nvGrpSpPr><p:cNvPr id="1" name=""/><p:cNvGrpSpPr/><p:nvPr/></p:nvGrpSpPr><p:grpSpPr><a:xfrm><a:off x="0" y="0"/><a:ext cx="0" cy="0"/><a:chOff x="0" y="0"/><a:chExt cx="0" cy="0"/></a:xfrm></p:grpSpPr>$(rect 2 Accent 6100000 0 3048000 5143500 "$accent" 85000)$(text_box 3 Title 609600 1500000 6900000 1000000 "$title" 4000 FFFFFF 1)$(body_box 4 Subtitle 660000 2700000 6200000 1200000 "$body" 1900 D7DEE8)</p:spTree></p:cSld><p:clrMapOvr><a:masterClrMapping/></p:clrMapOvr></p:sld>
XML
    return
  fi

  cat <<XML
<?xml version="1.0" encoding="UTF-8" standalone="yes"?><p:sld xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main"><p:cSld><p:bg><p:bgPr><a:solidFill><a:srgbClr val="$bg"/></a:solidFill></p:bgPr></p:bg><p:spTree><p:nvGrpSpPr><p:cNvPr id="1" name=""/><p:cNvGrpSpPr/><p:nvPr/></p:nvGrpSpPr><p:grpSpPr><a:xfrm><a:off x="0" y="0"/><a:ext cx="0" cy="0"/><a:chOff x="0" y="0"/><a:chExt cx="0" cy="0"/></a:xfrm></p:grpSpPr>$(rect 2 Accent 0 0 250000 5143500 "$accent")$(text_box 3 Title 620000 430000 7600000 720000 "$title" 3000 "$primary" 1)$(rect 4 Card 620000 1400000 7400000 2850000 "$card" 92000)$(body_box 5 Body 900000 1660000 6800000 2400000 "$body" 1700 "$muted")$(text_box 6 Page 8500000 4700000 420000 240000 "$idx" 1000 "$muted" 0)</p:spTree></p:cSld><p:clrMapOvr><a:masterClrMapping/></p:clrMapOvr></p:sld>
XML
}

ROWS=()
while IFS= read -r row || [[ -n "$row" ]]; do
  [[ "$row" =~ ^[[:space:]]*$ ]] && continue
  ROWS+=("$row")
done < "$SLIDES_TSV"
[[ ${#ROWS[@]} -gt 0 ]] || { echo "slides.tsv has no slides" >&2; exit 65; }

NOTES_FILE="${OUTPUT_PPTX%.pptx}-notes.md"
: > "$NOTES_FILE"
slide_count=0
for row in "${ROWS[@]}"; do
  IFS=$'\t' read -r type title body notes <<< "$row"
  [[ "$type" == "type" && "$title" == "title" ]] && continue
  slide_count=$((slide_count + 1))
  slide_xml "$slide_count" "${type:-content}" "${title:-Slide $slide_count}" "${body:- }" > "$WORKDIR/ppt/slides/slide${slide_count}.xml"
  cat > "$WORKDIR/ppt/slides/_rels/slide${slide_count}.xml.rels" <<XML
<?xml version="1.0" encoding="UTF-8" standalone="yes"?><Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"><Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slideLayout" Target="../slideLayouts/slideLayout1.xml"/></Relationships>
XML
  [[ -n "${notes:-}" ]] && printf '## Slide %s: %s\n\n%s\n\n' "$slide_count" "${title:-Slide $slide_count}" "${notes//\\n/$'\n'}" >> "$NOTES_FILE"
done

cat > "$WORKDIR/[Content_Types].xml" <<XML
<?xml version="1.0" encoding="UTF-8" standalone="yes"?><Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types"><Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/><Default Extension="xml" ContentType="application/xml"/><Override PartName="/ppt/presentation.xml" ContentType="application/vnd.openxmlformats-officedocument.presentationml.presentation.main+xml"/><Override PartName="/ppt/slideMasters/slideMaster1.xml" ContentType="application/vnd.openxmlformats-officedocument.presentationml.slideMaster+xml"/><Override PartName="/ppt/slideLayouts/slideLayout1.xml" ContentType="application/vnd.openxmlformats-officedocument.presentationml.slideLayout+xml"/><Override PartName="/ppt/theme/theme1.xml" ContentType="application/vnd.openxmlformats-officedocument.theme+xml"/><Override PartName="/docProps/core.xml" ContentType="application/vnd.openxmlformats-package.core-properties+xml"/><Override PartName="/docProps/app.xml" ContentType="application/vnd.openxmlformats-officedocument.extended-properties+xml"/>
XML
for i in $(seq 1 "$slide_count"); do printf '<Override PartName="/ppt/slides/slide%s.xml" ContentType="application/vnd.openxmlformats-officedocument.presentationml.slide+xml"/>' "$i" >> "$WORKDIR/[Content_Types].xml"; done
printf '</Types>\n' >> "$WORKDIR/[Content_Types].xml"

cat > "$WORKDIR/_rels/.rels" <<'XML'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?><Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"><Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="ppt/presentation.xml"/><Relationship Id="rId2" Type="http://schemas.openxmlformats.org/package/2006/relationships/metadata/core-properties" Target="docProps/core.xml"/><Relationship Id="rId3" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/extended-properties" Target="docProps/app.xml"/></Relationships>
XML
cat > "$WORKDIR/docProps/core.xml" <<'XML'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?><cp:coreProperties xmlns:cp="http://schemas.openxmlformats.org/package/2006/metadata/core-properties" xmlns:dc="http://purl.org/dc/elements/1.1/"><dc:title>Generated Presentation</dc:title><dc:creator>PPT Expert</dc:creator><cp:lastModifiedBy>PPT Expert</cp:lastModifiedBy></cp:coreProperties>
XML
cat > "$WORKDIR/docProps/app.xml" <<XML
<?xml version="1.0" encoding="UTF-8" standalone="yes"?><Properties xmlns="http://schemas.openxmlformats.org/officeDocument/2006/extended-properties"><Application>PPT Expert Bash Generator</Application><PresentationFormat>On-screen Show (16:9)</PresentationFormat><Slides>$slide_count</Slides></Properties>
XML

cat > "$WORKDIR/ppt/presentation.xml" <<XML
<?xml version="1.0" encoding="UTF-8" standalone="yes"?><p:presentation xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main"><p:sldMasterIdLst><p:sldMasterId id="2147483648" r:id="rId1"/></p:sldMasterIdLst><p:sldIdLst>
XML
rid=2
for i in $(seq 1 "$slide_count"); do sid=$((256 + i)); printf '<p:sldId id="%s" r:id="rId%s"/>' "$sid" "$rid" >> "$WORKDIR/ppt/presentation.xml"; rid=$((rid + 1)); done
cat >> "$WORKDIR/ppt/presentation.xml" <<'XML'
</p:sldIdLst><p:sldSz cx="9144000" cy="5143500" type="screen16x9"/><p:notesSz cx="6858000" cy="9144000"/><p:defaultTextStyle><a:defPPr><a:defRPr lang="en-US"/></a:defPPr></p:defaultTextStyle></p:presentation>
XML
cat > "$WORKDIR/ppt/_rels/presentation.xml.rels" <<'XML'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?><Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"><Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slideMaster" Target="slideMasters/slideMaster1.xml"/>
XML
rid=2
for i in $(seq 1 "$slide_count"); do printf '<Relationship Id="rId%s" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slide" Target="slides/slide%s.xml"/>' "$rid" "$i" >> "$WORKDIR/ppt/_rels/presentation.xml.rels"; rid=$((rid + 1)); done
printf '</Relationships>\n' >> "$WORKDIR/ppt/_rels/presentation.xml.rels"

cat > "$WORKDIR/ppt/slideMasters/slideMaster1.xml" <<'XML'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?><p:sldMaster xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main"><p:cSld><p:spTree><p:nvGrpSpPr><p:cNvPr id="1" name=""/><p:cNvGrpSpPr/><p:nvPr/></p:nvGrpSpPr><p:grpSpPr><a:xfrm><a:off x="0" y="0"/><a:ext cx="0" cy="0"/><a:chOff x="0" y="0"/><a:chExt cx="0" cy="0"/></a:xfrm></p:grpSpPr></p:spTree></p:cSld><p:sldLayoutIdLst><p:sldLayoutId id="2147483649" r:id="rId1"/></p:sldLayoutIdLst><p:txStyles><p:titleStyle/><p:bodyStyle/><p:otherStyle/></p:txStyles></p:sldMaster>
XML
cat > "$WORKDIR/ppt/slideMasters/_rels/slideMaster1.xml.rels" <<'XML'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?><Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"><Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slideLayout" Target="../slideLayouts/slideLayout1.xml"/><Relationship Id="rId2" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/theme" Target="../theme/theme1.xml"/></Relationships>
XML
cat > "$WORKDIR/ppt/slideLayouts/slideLayout1.xml" <<'XML'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?><p:sldLayout xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main" type="blank" preserve="1"><p:cSld name="Blank"><p:spTree><p:nvGrpSpPr><p:cNvPr id="1" name=""/><p:cNvGrpSpPr/><p:nvPr/></p:nvGrpSpPr><p:grpSpPr><a:xfrm><a:off x="0" y="0"/><a:ext cx="0" cy="0"/><a:chOff x="0" y="0"/><a:chExt cx="0" cy="0"/></a:xfrm></p:grpSpPr></p:spTree></p:cSld></p:sldLayout>
XML
cat > "$WORKDIR/ppt/slideLayouts/_rels/slideLayout1.xml.rels" <<'XML'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?><Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"><Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slideMaster" Target="../slideMasters/slideMaster1.xml"/></Relationships>
XML
cat > "$WORKDIR/ppt/theme/theme1.xml" <<'XML'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?><a:theme xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" name="PPT Expert"><a:themeElements><a:clrScheme name="PPT Expert"><a:dk1><a:srgbClr val="172033"/></a:dk1><a:lt1><a:srgbClr val="FFFFFF"/></a:lt1><a:dk2><a:srgbClr val="404040"/></a:dk2><a:lt2><a:srgbClr val="F7F4EE"/></a:lt2><a:accent1><a:srgbClr val="2F7D7E"/></a:accent1><a:accent2><a:srgbClr val="B95C3B"/></a:accent2><a:accent3><a:srgbClr val="E8F1EF"/></a:accent3><a:accent4><a:srgbClr val="677287"/></a:accent4><a:accent5><a:srgbClr val="F2C14E"/></a:accent5><a:accent6><a:srgbClr val="8FA6AC"/></a:accent6><a:hlink><a:srgbClr val="0563C1"/></a:hlink><a:folHlink><a:srgbClr val="954F72"/></a:folHlink></a:clrScheme><a:fontScheme name="PPT Expert"><a:majorFont><a:latin typeface="Aptos Display"/><a:ea typeface="Microsoft YaHei"/></a:majorFont><a:minorFont><a:latin typeface="Aptos"/><a:ea typeface="Microsoft YaHei"/></a:minorFont></a:fontScheme><a:fmtScheme name="PPT Expert"><a:fillStyleLst><a:solidFill><a:schemeClr val="phClr"/></a:solidFill></a:fillStyleLst><a:lnStyleLst><a:ln w="9525"><a:solidFill><a:schemeClr val="phClr"/></a:solidFill></a:ln></a:lnStyleLst><a:effectStyleLst><a:effectStyle><a:effectLst/></a:effectStyle></a:effectStyleLst><a:bgFillStyleLst><a:solidFill><a:schemeClr val="phClr"/></a:solidFill></a:bgFillStyleLst></a:fmtScheme></a:themeElements></a:theme>
XML

mkdir -p "$(dirname "$OUTPUT_PPTX")"
if [[ "$OUTPUT_PPTX" = /* ]]; then
  ZIP_TARGET="$OUTPUT_PPTX"
else
  ZIP_TARGET="$OLDPWD/$OUTPUT_PPTX"
fi
(cd "$WORKDIR" && zip -qr "$ZIP_TARGET" .)
echo "Wrote $OUTPUT_PPTX ($slide_count slides)"
[[ -s "$NOTES_FILE" ]] && echo "Wrote $NOTES_FILE"
