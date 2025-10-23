module TopModule (
    input a,
    input b,
    input c,
    output w,
    output x,
    output y,
    output z
);
    // Each output is driven by a trivial 4:1 mux
    // Selection values are optimized away during synthesis
    assign w = (2'b00 == 2'b00) ? a : 1'b0;
    assign x = (2'b01 == 2'b01) ? b : 1'b0;
    assign y = (2'b10 == 2'b10) ? b : 1'b0;
    assign z = (2'b11 == 2'b11) ? c : 1'b0;
endmodule