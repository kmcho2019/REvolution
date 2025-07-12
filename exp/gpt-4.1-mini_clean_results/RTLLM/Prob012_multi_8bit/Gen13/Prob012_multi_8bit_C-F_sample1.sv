module multi_8bit (
    input  [7:0] A,
    input  [7:0] B,
    output [15:0] product
);
    // Generate partial products conditioned on B bits
    wire [15:0] partial_products [7:0];
    genvar i;

    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_partial_products
            assign partial_products[i] = B[i] ? ({{8{1'b0}}, A} << i) : 16'd0;
        end
    endgenerate

    // Recursive function to sum partial products with balanced tree
    function [15:0] balanced_sum;
        input integer start, end_idx;
        integer mid;
        begin
            if (start == end_idx)
                balanced_sum = partial_products[start];
            else begin
                mid = (start + end_idx) >> 1;
                balanced_sum = balanced_sum(start, mid) + balanced_sum(mid+1, end_idx);
            end
        end
    endfunction

    assign product = balanced_sum(0,7);

endmodule