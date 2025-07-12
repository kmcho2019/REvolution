module TopModule (
    input a,
    input b,
    input c,
    output w,
    output x,
    output y,
    output z
);
    // Using muxes with constant select signals to implement the connections
    assign w = (1'b0) ? b : a;  // Always select a
    assign x = (1'b0) ? c : b;  // Always select b
    assign y = (1'b1) ? b : a;  // Always select b (using opposite select)
    assign z = (1'b0) ? a : c;  // Always select c
endmodule