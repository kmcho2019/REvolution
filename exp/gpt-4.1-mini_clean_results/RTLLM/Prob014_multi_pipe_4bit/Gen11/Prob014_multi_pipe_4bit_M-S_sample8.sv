module multi_pipe_4bit #(
    parameter size = 4,
    parameter product_width = 2 * size
)(
    input                     clk,
    input                     rst_n,       // active low reset
    input      [size-1:0]     mul_a,
    input      [size-1:0]     mul_b,
    output reg [product_width-1:0] mul_out
);

    // Zero-extend multiplicand
    wire [product_width-1:0] mul_a_ext = {{(product_width - size){1'b0}}, mul_a};

    // Generate partial products as individual wires
    wire [product_width-1:0] pp0 = mul_b[0] ? (mul_a_ext << 0) : {product_width{1'b0}};
    wire [product_width-1:0] pp1 = mul_b[1] ? (mul_a_ext << 1) : {product_width{1'b0}};
    wire [product_width-1:0] pp2 = mul_b[2] ? (mul_a_ext << 2) : {product_width{1'b0}};
    wire [product_width-1:0] pp3 = mul_b[3] ? (mul_a_ext << 3) : {product_width{1'b0}};

    // Pipeline stage 1: registers to hold partial products
    reg [product_width-1:0] pp0_reg, pp1_reg, pp2_reg, pp3_reg;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pp0_reg <= {product_width{1'b0}};
            pp1_reg <= {product_width{1'b0}};
            pp2_reg <= {product_width{1'b0}};
            pp3_reg <= {product_width{1'b0}};
        end else begin
            pp0_reg <= pp0;
            pp1_reg <= pp1;
            pp2_reg <= pp2;
            pp3_reg <= pp3;
        end
    end

    // Combinational sums of partial products pairs
    wire [product_width-1:0] sum_low  = pp0_reg + pp1_reg;
    wire [product_width-1:0] sum_high = pp2_reg + pp3_reg;

    // Pipeline stage 2: register final sum
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out <= {product_width{1'b0}};
        else
            mul_out <= sum_low + sum_high;
    end

endmodule