module multi_8bit (
    input  wire [7:0] A,
    input  wire [7:0] B,
    output wire [15:0] product
);

    wire [15:0] sum [7:0];

    // Initial sum: if B[0] is 1, add A shifted by 0, else zero
    assign sum[0] = B[0] ? {8'b0, A} : 16'b0;

    genvar i;
    generate
        for (i = 1; i < 8; i = i + 1) begin : gen_sum
            // If B[i] is 1, add A shifted left by i to sum[i-1], else keep sum[i-1]
            assign sum[i] = B[i] ? (sum[i-1] + ( {8'b0, A} << i )) : sum[i-1];
        end
    endgenerate

    assign product = sum[7];

endmodule