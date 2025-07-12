module multi_8bit (
    input  wire [7:0] A,
    input  wire [7:0] B,
    output wire [15:0] product
);

    // Partial products: each is A shifted by i if B[i] is set
    wire [15:0] partial_products [7:0];
    genvar i;

    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_partial_products
            assign partial_products[i] = B[i] ? (A << i) : 16'd0;
        end
    endgenerate

    // Function to recursively sum partial products in a balanced binary tree
    function [15:0] balanced_sum;
        input integer start;
        input integer end_;
        integer mid;
        reg [15:0] left_sum, right_sum;
        begin
            if (start == end_) begin
                balanced_sum = partial_products[start];
            end else begin
                mid = (start + end_) >> 1;
                left_sum  = balanced_sum(start, mid);
                right_sum = balanced_sum(mid+1, end_);
                balanced_sum = left_sum + right_sum;
            end
        end
    endfunction

    // Compute product by summing all partial products using balanced tree
    assign product = balanced_sum(0,7);

endmodule