module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output      overflow
);

    wire [8:0] sum;

    // Manual addition with carry propagation
    assign sum[0] = a[0] ^ b[0];
    assign sum[1] = a[1] ^ b[1] ^ (a[0] & b[0]);
    assign sum[2] = a[2] ^ b[2] ^ ((a[1] & b[1]) | (a[1] & sum[1]) | (b[1] & sum[1]));
    assign sum[3] = a[3] ^ b[3] ^ ((a[2] & b[2]) | (a[2] & sum[2]) | (b[2] & sum[2]));
    assign sum[4] = a[4] ^ b[4] ^ ((a[3] & b[3]) | (a[3] & sum[3]) | (b[3] & sum[3]));
    assign sum[5] = a[5] ^ b[5] ^ ((a[4] & b[4]) | (a[4] & sum[4]) | (b[4] & sum[4]));
    assign sum[6] = a[6] ^ b[6] ^ ((a[5] & b[5]) | (a[5] & sum[5]) | (b[5] & sum[5]));
    assign sum[7] = a[7] ^ b[7] ^ ((a[6] & b[6]) | (a[6] & sum[6]) | (b[6] & sum[6]));
    assign sum[8] = (a[7] & b[7]) | (a[7] & sum[7]) | (b[7] & sum[7]);

    // Assign the sum to the output
    assign s = sum[7:0];

    // Detect signed overflow
    assign overflow = (a[7] == b[7] && a[7] != s[7]);

endmodule