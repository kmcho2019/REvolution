module TopModule (
    input x,
    input y,
    output z
);
    // Implement as a 2:1 mux where:
    // select = y
    // in0 = x (selected when y=0)
    // in1 = 0 (selected when y=1)
    assign z = y ? 1'b0 : x;
endmodule