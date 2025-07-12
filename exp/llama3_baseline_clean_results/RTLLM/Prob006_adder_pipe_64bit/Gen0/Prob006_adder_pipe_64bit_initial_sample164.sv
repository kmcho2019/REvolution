module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output o_en
);

reg [63:0] pipe_reg_a;
reg [63:0] pipe_reg_b;
reg pipe_en;
reg [64:0] sum;
reg [63:0] carry;
reg [63:0] temp_sum;
reg o_en_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        pipe_reg_a <= 64'd0;
        pipe_reg_b <= 64'd0;
        pipe_en <= 1'b0;
        o_en_reg <= 1'b0;
    end else if (i_en) begin
        pipe_reg_a <= adda;
        pipe_reg_b <= addb;
        pipe_en <= 1'b1;
        o_en_reg <= 1'b0;
    end else if (pipe_en) begin
        pipe_en <= 1'b0;
        o_en_reg <= 1'b1;
    end
end

always @(*) begin
    carry = 64'd0;
    temp_sum = 64'd0;
    for (int i = 0; i < 64; i++) begin
        if (i == 0) begin
            temp_sum[i] = pipe_reg_a[i] ^ pipe_reg_b[i];
            carry[i] = pipe_reg_a[i] & pipe_reg_b[i];
        end else begin
            temp_sum[i] = pipe_reg_a[i] ^ pipe_reg_b[i] ^ carry[i-1];
            carry[i] = (pipe_reg_a[i] & pipe_reg_b[i]) | (pipe_reg_a[i] & carry[i-1]) | (pipe_reg_b[i] & carry[i-1]);
        end
    end
    sum = {carry[63], temp_sum};
end

always @(posedge clk) begin
    if (pipe_en) begin
        result <= sum;
    end
    o_en <= o_en_reg;
end

endmodule