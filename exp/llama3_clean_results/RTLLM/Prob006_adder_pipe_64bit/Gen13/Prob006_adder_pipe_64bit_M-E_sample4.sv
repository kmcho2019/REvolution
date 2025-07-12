module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output reg o_en
);

reg [63:0] shift_reg_a;
reg [63:0] shift_reg_b;
reg [64:0] sum_reg;
reg [0:0] carry_reg;
reg [5:0] counter;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg_a <= 64'd0;
        shift_reg_b <= 64'd0;
        sum_reg <= 65'd0;
        carry_reg <= 1'd0;
        counter <= 6'd0;
        o_en <= 1'b0;
    end else if (i_en) begin
        if (counter == 6'd0) begin
            shift_reg_a <= adda;
            shift_reg_b <= addb;
            sum_reg <= 65'd0;
            carry_reg <= 1'd0;
            counter <= counter + 1'd1;
        end else if (counter < 6'd64) begin
            {carry_reg, sum_reg[0]} <= shift_reg_a[0] + shift_reg_b[0] + carry_reg;
            sum_reg <= {sum_reg[63:0], 1'd0};
            shift_reg_a <= {shift_reg_a[62:0], 1'd0};
            shift_reg_b <= {shift_reg_b[62:0], 1'd0};
            counter <= counter + 1'd1;
        end else begin
            result <= sum_reg;
            o_en <= 1'b1;
        end
    end else begin
        o_en <= 1'b0;
    end
end

endmodule