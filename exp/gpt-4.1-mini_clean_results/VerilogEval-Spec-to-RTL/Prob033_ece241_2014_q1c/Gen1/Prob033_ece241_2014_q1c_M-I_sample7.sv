module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire [8:0] sum = {1'b0, a} + {1'b0, b};  // 9-bit unsigned addition

    assign s = sum[7:0];

    // Overflow = carry into MSB XOR carry out of MSB
    // carry into MSB = sum[7]
    // carry out of MSB = sum[8]
    assign overflow = sum[7] ^ sum[8];

endmodule