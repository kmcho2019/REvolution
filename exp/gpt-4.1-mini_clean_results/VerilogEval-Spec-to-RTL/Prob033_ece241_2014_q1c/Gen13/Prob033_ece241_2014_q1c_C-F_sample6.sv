module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire [8:0] sum_ext;

    // Perform addition as 9-bit unsigned to capture carry out
    assign sum_ext = {1'b0, a} + {1'b0, b};

    assign s = sum_ext[7:0];

    // carry into MSB = sum_ext[7] carry from bit 6 addition = sum_ext[8-1] carry-in to MSB
    // carry out MSB = sum_ext[8]
    // overflow = carry into MSB xor carry out MSB
    assign overflow = sum_ext[7] ^ sum_ext[8];

endmodule