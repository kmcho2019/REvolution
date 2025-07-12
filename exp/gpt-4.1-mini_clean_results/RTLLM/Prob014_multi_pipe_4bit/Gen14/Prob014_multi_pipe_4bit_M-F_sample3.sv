module multi_pipe_4bit #(
    parameter size = 4,
    parameter product_width = 2 * size
)(
    input                         clk,
    input                         rst_n,       // active low async reset
    input      [size-1:0]         mul_a,
    input      [size-1:0]         mul_b,
    output reg [product_width-1:0] mul_out
);

    // Extend multiplicand by zero padding on MSB side to product width
    wire [product_width-1:0] mul_a_ext = {{size{1'b0}}, mul_a};

    // Generate partial products: mul_b[i] ? (mul_a_ext << i) : 0
    wire [product_width-1:0] partial_products [size-1:0];
    genvar i;
    generate
        for (i=0; i < size; i=i+1) begin : gen_partial_products
            assign partial_products[i] = mul_b[i] ? (mul_a_ext << i) : {product_width{1'b0}};
        end
    endgenerate

    // Stage 1: Register partial products (array of registers)
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

    // Balanced adder tree for summation of partial products
    // For size=4, sum pairs first, then sum the results.
    wire [product_width-1:0] sum_stage1 [((size+1)/2)-1:0];  // ceil(size/2)

    generate
        for (i=0; i < size/2; i=i+1) begin : gen_sum_stage1_pairs
            assign sum_stage1[i] = pp_reg[2*i] + pp_reg[2*i+1];
        end
        if (size % 2 == 1) begin : gen_sum_stage1_odd
            assign sum_stage1[size/2] = pp_reg[size-1];
        end
    endgenerate

    // Stage 2: Final sum register
    reg [product_width-1:0] sum_stage2;
    always @(*) begin
        if (size == 4) begin
            sum_stage2 = sum_stage1[0] + sum_stage1[1];
        end else if (size == 3) begin
            sum_stage2 = sum_stage1[0] + sum_stage1[1];
        end else if (size == 2) begin
            sum_stage2 = sum_stage1[0];
        end else if (size == 1) begin
            sum_stage2 = pp_reg[0];
        end else begin
            sum_stage2 = {product_width{1'b0}};
        end
    end

    reg [product_width-1:0] mul_out_reg;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out_reg <= {product_width{1'b0}};
        else
            mul_out_reg <= sum_stage2;
    end

    always @(*) mul_out = mul_out_reg;

endmodule