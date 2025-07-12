module TopModule (
    input [2:0] in,
    output [1:0] out
);

    // Clear hierarchical population count:
    // 1. Count lower 2 bits in parallel (0-2)
    // 2. Add MSB (0 or 1)
    assign out = (in[0] + in[1]) + in[2];

endmodule