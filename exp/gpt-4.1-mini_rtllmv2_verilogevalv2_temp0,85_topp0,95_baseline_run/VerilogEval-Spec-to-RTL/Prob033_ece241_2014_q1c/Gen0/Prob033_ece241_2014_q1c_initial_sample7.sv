module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);

    wire [8:0] sum;

    // Perform addition with one extra bit to capture carry out
    assign sum = {1'b0, a} + {1'b0, b};

    // Assign sum to output s
    assign s = sum[7:0];

    // Overflow detection: overflow = carry_in_to_MSB XOR carry_out_from_MSB
    // carry_in_to_MSB is sum[7], carry_out_from_MSB is sum[8]
    assign overflow = sum[8] ^ sum[7];

endmodule