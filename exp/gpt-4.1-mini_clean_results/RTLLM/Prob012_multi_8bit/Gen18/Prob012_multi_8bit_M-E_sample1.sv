module multi_8bit (
    input  wire [7:0] A,
    input  wire [7:0] B,
    output wire [15:0] product
);
    // Internal signal to hold intermediate sums
    wire [15:0] partial_sum [0:8];
    assign partial_sum[0] = 16'b0;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : add_stage
            // Shift multiplicand A by i positions
            wire [15:0] shifted_A = {8'b0, A} << i;
            // Conditionally add shifted_A if B[i] is 1
            assign partial_sum[i+1] = partial_sum[i] + (B[i] ? shifted_A : 16'b0);
        end
    endgenerate

    assign product = partial_sum[8];
endmodule