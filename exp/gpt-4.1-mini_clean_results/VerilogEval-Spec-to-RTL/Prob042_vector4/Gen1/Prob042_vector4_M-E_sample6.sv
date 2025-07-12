module TopModule(
    input  [7:0] in,
    output [31:0] out
);

    wire [15:0] stage1;

    // First stage: extend 8 bits to 16 bits by replicating bit 7 eight times
    assign stage1 = { {8{in[7]}}, in };

    // Second stage: extend 16 bits to 32 bits by replicating stage1[15] sixteen times
    assign out = { {16{stage1[15]}}, stage1 };

endmodule