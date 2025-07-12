module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output o_en
);

// Internal signals
reg [63:0] a_reg1, b_reg1, sum_reg1;
reg [63:0] a_reg2, b_reg2, sum_reg2;
reg [63:0] a_reg3, b_reg3, sum_reg3;
reg [64:0] result_reg;
reg i_en_reg1, i_en_reg2, i_en_reg3;
reg [63:0] carry_reg1, carry_reg2, carry_reg3;

// First stage: input registers
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        a_reg1 <= 64'd0;
        b_reg1 <= 64'd0;
        i_en_reg1 <= 1'b0;
    end else if (i_en) begin
        a_reg1 <= adda;
        b_reg1 <= addb;
        i_en_reg1 <= 1'b1;
    end
end

// Second stage: calculate sum and carry
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        a_reg2 <= 64'd0;
        b_reg2 <= 64'd0;
        sum_reg1 <= 64'd0;
        carry_reg1 <= 64'd0;
        i_en_reg2 <= 1'b0;
    end else if (i_en_reg1) begin
        a_reg2 <= a_reg1;
        b_reg2 <= b_reg1;
        sum_reg1 <= a_reg1 + b_reg1;
        carry_reg1 <= (a_reg1 + b_reg1) >> 64;
        i_en_reg2 <= 1'b1;
    end
end

// Third stage: calculate sum and carry
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        a_reg3 <= 64'd0;
        b_reg3 <= 64'd0;
        sum_reg2 <= 64'd0;
        carry_reg2 <= 64'd0;
        i_en_reg3 <= 1'b0;
    end else if (i_en_reg2) begin
        a_reg3 <= a_reg2;
        b_reg3 <= b_reg2;
        sum_reg2 <= sum_reg1 + {carry_reg1, 63'd0};
        carry_reg2 <= (sum_reg1 + {carry_reg1, 63'd0}) >> 64;
        i_en_reg3 <= 1'b1;
    end
end

// Final stage: calculate result
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        result_reg <= 65'd0;
        o_en <= 1'b0;
    end else if (i_en_reg3) begin
        result_reg <= {carry_reg2, sum_reg2};
        o_en <= 1'b1;
    end else begin
        o_en <= 1'b0;
    end
end

assign result = result_reg;

endmodule