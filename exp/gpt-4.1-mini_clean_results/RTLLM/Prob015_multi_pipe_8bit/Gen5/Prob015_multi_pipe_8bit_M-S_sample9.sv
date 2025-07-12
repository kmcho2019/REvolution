module multi_pipe_8bit (
    input              clk,
    input              rst_n,
    input              mul_en_in,
    input      [7:0]   mul_a,
    input      [7:0]   mul_b,
    output reg         mul_en_out,
    output reg [15:0]  mul_out
);

    reg         mul_en_reg;
    reg  [7:0]  mul_a_reg;
    reg  [7:0]  mul_b_reg;
    reg  [15:0] mul_out_reg;

    wire [15:0] partial_products [7:0];
    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_reg  <= 1'b0;
            mul_a_reg   <= 8'd0;
            mul_b_reg   <= 8'd0;
            mul_en_out  <= 1'b0;
            mul_out_reg <= 16'd0;
            mul_out     <= 16'd0;
        end else begin
            mul_en_reg <= mul_en_in;
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end
            mul_en_out <= mul_en_reg;
            if (mul_en_reg) begin
                mul_out_reg <= 
                    (mul_b_reg[0] ? (mul_a_reg << 0) : 16'd0) +
                    (mul_b_reg[1] ? (mul_a_reg << 1) : 16'd0) +
                    (mul_b_reg[2] ? (mul_a_reg << 2) : 16'd0) +
                    (mul_b_reg[3] ? (mul_a_reg << 3) : 16'd0) +
                    (mul_b_reg[4] ? (mul_a_reg << 4) : 16'd0) +
                    (mul_b_reg[5] ? (mul_a_reg << 5) : 16'd0) +
                    (mul_b_reg[6] ? (mul_a_reg << 6) : 16'd0) +
                    (mul_b_reg[7] ? (mul_a_reg << 7) : 16'd0);
            end else begin
                mul_out_reg <= 16'd0;
            end
            mul_out <= mul_en_out ? mul_out_reg : 16'd0;
        end
    end

endmodule