# T59 Viewer Playwright Caveat

The Playwright smoke generated the screenshot matrix, including the
representative compare screenshot copied to `screenshot.png`, but returned:

```text
ERROR: Playwright archive hover clear check found no occupied archive cell
```

Manual screenshot inspection found the generated viewer nonblank and readable.
The caveat appears limited to the interaction smoke for the archive hover clear
check. The non-strict schema/control validator passed.
