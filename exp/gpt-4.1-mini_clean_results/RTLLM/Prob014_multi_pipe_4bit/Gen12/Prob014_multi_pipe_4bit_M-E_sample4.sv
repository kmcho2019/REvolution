module multi_pipe_4bit #(
    parameter size = 4,
    parameter product_width = 2 * size
)(
    input                      clk,
    input                      rst_n,      // Active low reset
    input      [size-1:0]      mul_a,
    input      [size-1:0]      mul_b,
    output reg [product_width-1:0] mul_out
);

    // Extend mul_a to product width with zeros at MSBs
    wire [product_width-1:0] mul_a_ext = {{(product_width - size){1'b0}}, mul_a};

    // Generate partial products for lower half bits (bits 0 and 1 of mul_b)
    wire [product_width-1:0] pp_lower0 = mul_b[0] ? (mul_a_ext << 0) : {product_width{1'b0}};
    wire [product_width-1:0] pp_lower1 = mul_b[1] ? (mul_a_ext << 1) : {product_width{1'b0}};

    // Generate partial products for upper half bits (bits 2 and 3 of mul_b)
    wire [product_width-1:0] pp_upper2 = mul_b[2] ? (mul_a_ext << 2) : {product_width{1'b0}};
    wire [product_width-1:0] pp_upper3 = mul_b[3] ? (mul_a_ext << 3) : {product_width{1'b0}};

    // Pipeline stage 1 registers to hold partial products sums for lower and upper halves
    reg [product_width-1:0] sum_lower_reg;
    reg [product_width-1:0] sum_upper_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_lower_reg <= {product_width{1'b0}};
            sum_upper_reg <= {product_width{1'b0}};
        end else begin
            sum_lower_reg <= pp_lower0 + pp_lower1;
            sum_upper_reg <= pp_upper2 + pp_upper3;
        end
    end

    // Pipeline stage 2 register to hold final multiplication result (sum of previous two sums)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= {product_width{1'b0}};
        end else begin
            mul_out <= sum_lower_reg + sum_upper_reg;
        end
    end

endmodule