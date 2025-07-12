module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output o_en
);

// Stage 1: Input operands and enable signal
reg [63:0] adda_reg;
reg [63:0] addb_reg;
reg i_en_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        adda_reg <= 64'd0;
        addb_reg <= 64'd0;
        i_en_reg <= 1'b0;
    end else if (i_en) begin
        adda_reg <= adda;
        addb_reg <= addb;
        i_en_reg <= 1'b1;
    end else begin
        adda_reg <= adda_reg;
        addb_reg <= addb_reg;
        i_en_reg <= i_en_reg;
    end
end

// Stage 2: Calculate sum and carry
reg [63:0] sum_reg;
reg [63:0] carry_reg;
reg i_en_sum_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum_reg <= 64'd0;
        carry_reg <= 64'd0;
        i_en_sum_reg <= 1'b0;
    end else if (i_en_reg) begin
        {carry_reg[0], sum_reg[0]} <= adda_reg[0] + addb_reg[0];
        for (genvar i = 1; i < 64; i++) begin
            {carry_reg[i], sum_reg[i]} <= adda_reg[i] + addb_reg[i] + carry_reg[i-1];
        end
        i_en_sum_reg <= 1'b1;
    end else begin
        sum_reg <= sum_reg;
        carry_reg <= carry_reg;
        i_en_sum_reg <= i_en_sum_reg;
    end
end

// Stage 3: Hold intermediate sum and carry
reg [63:0] sum_reg_2;
reg [63:0] carry_reg_2;
reg i_en_sum_reg_2;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum_reg_2 <= 64'd0;
        carry_reg_2 <= 64'd0;
        i_en_sum_reg_2 <= 1'b0;
    end else if (i_en_sum_reg) begin
        sum_reg_2 <= sum_reg;
        carry_reg_2 <= carry_reg;
        i_en_sum_reg_2 <= 1'b1;
    end else begin
        sum_reg_2 <= sum_reg_2;
        carry_reg_2 <= carry_reg_2;
        i_en_sum_reg_2 <= i_en_sum_reg_2;
    end
end

// Stage 4: Output result and enable signal
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        result <= 65'd0;
        o_en <= 1'b0;
    end else if (i_en_sum_reg_2) begin
        result <= {carry_reg_2[63], sum_reg_2};
        o_en <= 1'b1;
    end else begin
        result <= result;
        o_en <= 1'b0;
    end
end

endmodule