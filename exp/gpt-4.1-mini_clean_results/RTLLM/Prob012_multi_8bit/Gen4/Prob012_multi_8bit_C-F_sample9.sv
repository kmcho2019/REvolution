module multi_8bit (
    input  [7:0] A,
    input  [7:0] B,
    output [15:0] product
);
    // Pre-extend multiplicand once for reuse
    wire [15:0] A_ext = {8'd0, A};

    // Generate partial products based on multiplier bits with shifted multiplicand
    wire [15:0] partial_products [7:0];
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : PARTIAL_PROD_GEN
            assign partial_products[i] = B[i] ? (A_ext << i) : 16'd0;
        end
    endgenerate

    // Balanced tree reduction function for adding partial products
    // Implemented recursively using a generate construct and localparams for size control
    function automatic [15:0] balanced_sum;
        input integer start_idx;
        input integer end_idx;
        integer mid;
        begin
            if (start_idx == end_idx) begin
                balanced_sum = partial_products[start_idx];
            end else begin
                mid = (start_idx + end_idx) >> 1;
                balanced_sum = balanced_sum(start_idx, mid) + balanced_sum(mid+1, end_idx);
            end
        end
    endfunction

    assign product = balanced_sum(0,7);

endmodule