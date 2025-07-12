module TopModule (
    input a,
    input b,
    input c,
    output w,
    output x,
    output y,
    output z
);
    // Decoder-style implementation
    // Each output is driven by an AND gate with appropriate enable
    assign w = a & 1'b1;  // Always enabled for a
    assign x = b & 1'b1;  // Always enabled for b
    assign y = b & 1'b1;  // Always enabled for b
    assign z = c & 1'b1;  // Always enabled for c
endmodule