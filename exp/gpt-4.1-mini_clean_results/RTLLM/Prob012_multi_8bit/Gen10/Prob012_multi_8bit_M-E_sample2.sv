module multi_8bit (
    input  wire [7:0] A,
    input  wire [7:0] B,
    output wire [15:0] product
);
    // Internal 16-bit accumulator for product
    // Initialize to zero
    // For each bit i of B, if B[i] is 1, add A shifted left by i to the product
    // Since shifts by variable amounts are synthesizable here as static shifts (constant i), this is valid

    wire [15:0] partial_sums [7:0];

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_partial_sum
            assign partial_sums[i] = B[i] ? ({8'b0, A} << i) : 16'b0;
        end
    endgenerate

    // Sum all partial_sums
    // Since this is not a balanced tree, sum them sequentially
    // To keep code concise, use a reduction addition via a for loop in a function

    function [15:0] sum_all;
        input [15:0] parts [7:0];
        integer j;
        reg [15:0] s;
        begin
            s = 16'b0;
            for (j = 0; j < 8; j = j + 1) begin
                s = s + parts[j];
            end
            sum_all = s;
        end
    endfunction

    assign product = sum_all(partial_sums);

endmodule