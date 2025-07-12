module multi_pipe_4bit #(
    parameter size = 4,
    parameter product_width = 2 * size
)(
    input                    clk,
    input                    rst_n,       // active low reset
    input      [size-1:0]    mul_a,
    input      [size-1:0]    mul_b,
    output reg [product_width-1:0] mul_out
);

    // Zero-extend multiplicand by size bits on MSB side
    wire [product_width-1:0] mul_a_ext = {{size{1'b0}}, mul_a};

    // First pipeline stage register to accumulate partial products
    reg [product_width-1:0] stage1_sum;

    integer i;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_sum <= {product_width{1'b0}};
        end else begin
            // Accumulate partial products
            stage1_sum <= {product_width{1'b0}};
            for (i = 0; i < size; i = i + 1) begin
                if (mul_b[i])
                    stage1_sum <= stage1_sum + (mul_a_ext << i);
            end
        end
    end

    // Second pipeline stage: register final product output
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out <= {product_width{1'b0}};
        else
            mul_out <= stage1_sum;
    end

endmodule