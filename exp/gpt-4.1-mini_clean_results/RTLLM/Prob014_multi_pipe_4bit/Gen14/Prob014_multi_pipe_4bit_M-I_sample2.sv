module multi_pipe_4bit #(
    parameter size = 4,
    parameter product_width = 2 * size
)(
    input                      clk,
    input                      rst_n,       // active low reset
    input      [size-1:0]      mul_a,
    input      [size-1:0]      mul_b,
    output reg [product_width-1:0] mul_out
);

    // Extend multiplicand by prepending size zeros to MSB
    wire [product_width-1:0] mul_a_ext = {{size{1'b0}}, mul_a};

    // First pipeline stage partial products for bits 0,1 and bits 2,3
    reg [product_width-1:0] pp0, pp1, pp2, pp3;
    reg [product_width-1:0] sum_low, sum_high;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pp0 <= {product_width{1'b0}};
            pp1 <= {product_width{1'b0}};
            pp2 <= {product_width{1'b0}};
            pp3 <= {product_width{1'b0}};
            sum_low <= {product_width{1'b0}};
            sum_high <= {product_width{1'b0}};
        end else begin
            // Generate and register partial products
            pp0 <= mul_b[0] ? (mul_a_ext << 0) : {product_width{1'b0}};
            pp1 <= mul_b[1] ? (mul_a_ext << 1) : {product_width{1'b0}};
            pp2 <= mul_b[2] ? (mul_a_ext << 2) : {product_width{1'b0}};
            pp3 <= mul_b[3] ? (mul_a_ext << 3) : {product_width{1'b0}};

            // Sum partial products pairs to reduce addition delay
            sum_low  <= pp0 + pp1;
            sum_high <= pp2 + pp3;
        end
    end

    // Second pipeline stage sums the two intermediate sums and registers final product
    reg [product_width-1:0] product_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            product_reg <= {product_width{1'b0}};
            mul_out <= {product_width{1'b0}};
        end else begin
            product_reg <= sum_low + sum_high;
            mul_out <= product_reg;
        end
    end

endmodule