module multi_pipe_4bit #(
    parameter size = 4,
    parameter product_width = 2 * size
) (
    input                       clk,
    input                       rst_n,
    input      [size-1:0]       mul_a,
    input      [size-1:0]       mul_b,
    output reg [product_width-1:0] mul_out
);

    // Extend multiplicand by size zeros on MSB side
    wire [product_width-1:0] mul_a_ext = {{size{1'b0}}, mul_a};

    // Generate partial products combinationally
    wire [product_width-1:0] partial_products [size-1:0];
    genvar i;
    generate
        for(i = 0; i < size; i = i + 1) begin : gen_partial_products
            assign partial_products[i] = mul_b[i] ? (mul_a_ext << i) : {product_width{1'b0}};
        end
    endgenerate

    // Pipeline stage 1: Register partial products
    reg [product_width-1:0] pp_reg0, pp_reg1, pp_reg2, pp_reg3;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pp_reg0 <= {product_width{1'b0}};
            pp_reg1 <= {product_width{1'b0}};
            pp_reg2 <= {product_width{1'b0}};
            pp_reg3 <= {product_width{1'b0}};
        end else begin
            pp_reg0 <= partial_products[0];
            pp_reg1 <= partial_products[1];
            pp_reg2 <= partial_products[2];
            pp_reg3 <= partial_products[3];
        end
    end

    // Pipeline stage 2: Sum partial products pairwise and register intermediate sums
    reg [product_width-1:0] sum_reg0, sum_reg1;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_reg0 <= {product_width{1'b0}};
            sum_reg1 <= {product_width{1'b0}};
        end else begin
            sum_reg0 <= pp_reg0 + pp_reg1;
            sum_reg1 <= pp_reg2 + pp_reg3;
        end
    end

    // Pipeline stage 3: Sum the two intermediate sums and register final product
    reg [product_width-1:0] product_reg;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            product_reg <= {product_width{1'b0}};
        end else begin
            product_reg <= sum_reg0 + sum_reg1;
        end
    end

    // Output register stage
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= {product_width{1'b0}};
        end else begin
            mul_out <= product_reg;
        end
    end

endmodule