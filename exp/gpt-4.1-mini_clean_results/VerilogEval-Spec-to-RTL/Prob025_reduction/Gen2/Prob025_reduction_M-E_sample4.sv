module TopModule (
    input  [7:0] in,
    output       parity
);
    wire [3:0] sum_nibbles;
    wire [4:0] sum_bits;

    // Count bits by summing groups of bits (popcount style)
    // First level: sum pairs of bits into 2-bit values
    wire [1:0] sum0 = in[0] + in[1];
    wire [1:0] sum1 = in[2] + in[3];
    wire [1:0] sum2 = in[4] + in[5];
    wire [1:0] sum3 = in[6] + in[7];

    // Second level: sum these pairs into 3-bit values
    wire [2:0] sum01 = sum0 + sum1;
    wire [2:0] sum23 = sum2 + sum3;

    // Final level: sum all bits
    wire [3:0] total_sum = sum01 + sum23;

    // parity = ~LSB of total sum (even parity bit)
    assign parity = ~total_sum[0];
endmodule