module TopModule (
    input a,
    input b,
    input c,
    output w,
    output x,
    output y,
    output z
);
    // Each output is driven by a 2:1 mux with fixed selection
    assign w = (1'b0) ? b : a;  // Always selects a
    assign x = (1'b0) ? c : b;  // Always selects b
    assign y = (1'b0) ? c : b;  // Always selects b
    assign z = (1'b0) ? a : c;  // Always selects c
endmodule