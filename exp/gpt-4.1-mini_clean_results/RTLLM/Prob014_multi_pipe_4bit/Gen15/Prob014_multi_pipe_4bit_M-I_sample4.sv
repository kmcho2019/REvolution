module multi_pipe_4bit #(
    parameter size = 4,
    parameter product_width = 2*size
) (
    input                         clk,
    input                         rst_n,         // async active-low reset
    input      [size-1:0]         mul_a,
    input      [size-1:0]         mul_b,
    output reg [product_width-1:0] mul_out
);

    // Extend multiplicand by zero padding on MSB side to product_width
    wire [product_width-1:0] mul_a_ext = {{size{1'b0}}, mul_a};

    // Generate partial products: mul_b[i] ? (mul_a_ext << i) : 0
    wire [product_width-1:0] partial_products [size-1:0];
    genvar i;
    generate
        for (i=0; i < size; i=i+1) begin : gen_partial_products
            assign partial_products[i] = mul_b[i] ? (mul_a_ext << i) : {product_width{1'b0}};
        end
    endgenerate

    // Stage 1 registers: Register partial products (array of registers)
    reg [product_width-1:0] pp_reg [size-1:0];
    integer idx;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (idx = 0; idx < size; idx = idx + 1)
                pp_reg[idx] <= {product_width{1'b0}};
        end else begin
            for (idx = 0; idx < size; idx = idx + 1)
                pp_reg[idx] <= partial_products[idx];
        end
    end

    // Stage 2 combinational sums of pairs of partial products
    wire [product_width-1:0] sum_pairs [(size/2)-1:0];

    generate
        for (i=0; i < size/2; i=i+1) begin : gen_sum_pairs
            assign sum_pairs[i] = pp_reg[2*i] + pp_reg[2*i+1];
        end
    endgenerate

    // If size is odd, pass last partial product as is (not used here since size=4 even)
    // For generality, can be handled here but not needed for size=4

    // Stage 2 registers: register sums of pairs
    reg [product_width-1:0] sum_pairs_reg [(size/2)-1:0];
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (idx=0; idx < size/2; idx=idx+1)
                sum_pairs_reg[idx] <= {product_width{1'b0}};
        end else begin
            for (idx=0; idx < size/2; idx=idx+1)
                sum_pairs_reg[idx] <= sum_pairs[idx];
        end
    end

    // Stage 3 combinational final sum of registered pair sums
    // size=4: sum_pairs_reg[0] + sum_pairs_reg[1]
    wire [product_width-1:0] final_sum = sum_pairs_reg[0] + sum_pairs_reg[1];

    // Stage 3 register: output registered final product
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out <= {product_width{1'b0}};
        else
            mul_out <= final_sum;
    end

endmodule