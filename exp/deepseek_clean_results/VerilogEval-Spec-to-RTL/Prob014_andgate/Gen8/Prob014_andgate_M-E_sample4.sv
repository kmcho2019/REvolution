module TopModule(
    input a,
    input b,
    output out
);
    // Implement AND as a 2-input LUT using a multiplexer
    // Inputs a,b form the 2-bit select for the mux
    // Truth table: 00->0, 01->0, 10->0, 11->1
    assign out = (a & b) ? 1'b1 : 1'b0;
endmodule