module multi_pipe_4bit #(
    parameter size = 4,
    parameter product_width = 2 * size
)(
    input                      clk,
    input                      rst_n,       // active low async reset
    input      [size-1:0]      mul_a,
    input      [size-1:0]      mul_b,
    output reg [product_width-1:0] mul_out
);

    // Extend multiplicand by zero padding on MSB side to product width
    wire [product_width-1:0] mul_a_ext = {{(product_width - size){1'b0}}, mul_a};

    // Stage 1: Generate partial products combinationally
    // Partial product array: each element is product_width bits
    wire [product_width-1:0] partial_products [size-1:0];

    genvar i;
    generate
        for (i=0; i < size; i=i+1) begin : gen_partial_products
            assign partial_products[i] = mul_b[i] ? (mul_a_ext << i) : {product_width{1'b0}};
        end
    endgenerate

    // Stage 1 registers: register partial products (first pipeline stage)
    reg [product_width-1:0] pp_reg [size-1:0];
    integer idx;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (idx=0; idx<size; idx=idx+1)
                pp_reg[idx] <= {product_width{1'b0}};
        end else begin
            for (idx=0; idx<size; idx=idx+1)
                pp_reg[idx] <= partial_products[idx];
        end
    end

    // Stage 2: Add partial products pairwise combinationally
    // For size=4, sum pp_reg[0] + pp_reg[1] and pp_reg[2] + pp_reg[3]
    wire [product_width-1:0] sum_stage2[ (size/2)-1 : 0 ];

    generate
        for (i=0; i < size/2; i=i+1) begin : gen_sum_stage2
            assign sum_stage2[i] = pp_reg[2*i] + pp_reg[2*i + 1];
        end
    endgenerate

    // Stage 2 registers: register sums of partial products (second pipeline stage)
    reg [product_width-1:0] sum_stage2_reg [ (size/2)-1 : 0 ];
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (idx=0; idx < size/2; idx=idx+1)
                sum_stage2_reg[idx] <= {product_width{1'b0}};
        end else begin
            for (idx=0; idx < size/2; idx=idx+1)
                sum_stage2_reg[idx] <= sum_stage2[idx];
        end
    end

    // Final product combinational sum of the two sums registered at stage 2
    // sum_stage2_reg[0] + sum_stage2_reg[1]
    wire [product_width-1:0] final_sum = sum_stage2_reg[0] + sum_stage2_reg[1];

    // Output register stage (also stage 2 per spec)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out <= {product_width{1'b0}};
        else
            mul_out <= final_sum;
    end

endmodule