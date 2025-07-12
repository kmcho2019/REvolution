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

    // Extend multiplicand with zeros on MSB side
    wire [product_width-1:0] mul_a_ext = {{size{1'b0}}, mul_a};

    // First pipeline stage registers for partial products
    reg [product_width-1:0] pp0, pp1, pp2, pp3;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pp0 <= 0;
            pp1 <= 0;
            pp2 <= 0;
            pp3 <= 0;
        end else begin
            pp0 <= mul_b[0] ? (mul_a_ext << 0) : 0;
            pp1 <= mul_b[1] ? (mul_a_ext << 1) : 0;
            pp2 <= mul_b[2] ? (mul_a_ext << 2) : 0;
            pp3 <= mul_b[3] ? (mul_a_ext << 3) : 0;
        end
    end

    // Second pipeline stage register for final sum
    reg [product_width-1:0] sum_reg;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_reg <= 0;
            mul_out <= 0;
        end else begin
            sum_reg <= pp0 + pp1 + pp2 + pp3;
            mul_out <= sum_reg;
        end
    end

endmodule