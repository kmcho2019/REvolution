module multi_8bit (
    input  wire [7:0] A,
    input  wire [7:0] B,
    output wire [15:0] product
);

    // Intermediate sums for each bit of B
    wire [15:0] sum [7:0];

    // First partial sum depends on B[0]
    assign sum[0] = B[0] ? ({{8{1'b0}}, A} << 0) : 16'b0;

    genvar i;
    generate
        for (i = 1; i < 8; i = i + 1) begin : gen_sum
            assign sum[i] = B[i] ? (sum[i-1] + ({{8{1'b0}}, A} << i)) : sum[i-1];
        end
    endgenerate

    assign product = sum[7];

endmodule