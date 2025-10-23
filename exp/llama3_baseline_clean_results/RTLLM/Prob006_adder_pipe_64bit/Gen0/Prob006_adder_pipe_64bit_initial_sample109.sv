module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Input registers
reg [63:0] adda_reg;
reg [63:0] addb_reg;
reg i_en_reg;

// Pipeline stage 1: Input registers
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        adda_reg <= 64'd0;
        addb_reg <= 64'd0;
        i_en_reg <= 1'b0;
    end else if (i_en) begin
        adda_reg <= adda;
        addb_reg <= addb;
        i_en_reg <= i_en;
    end else begin
        adda_reg <= adda_reg;
        addb_reg <= addb_reg;
        i_en_reg <= i_en_reg;
    end
end

// Ripple carry adder
reg [63:0] sum;
reg [63:0] carry;

always @(*) begin
    sum = adda_reg + addb_reg;
    carry = (adda_reg[63] + addb_reg[63] + (adda_reg[62:0] + addb_reg[62:0]) > 63'd0);
end

// Pipeline stage 2: Output registers
reg [64:0] result_reg;
reg o_en_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        result_reg <= 65'd0;
        o_en_reg <= 1'b0;
    end else if (i_en_reg) begin
        result_reg <= {1'b0, sum} + {64'd0, carry};
        o_en_reg <= 1'b1;
    end else if (o_en_reg) begin
        result_reg <= result_reg;
        o_en_reg <= 1'b0;
    end else begin
        result_reg <= result_reg;
        o_en_reg <= o_en_reg;
    end
end

// Output assignments
assign result = result_reg;
assign o_en = o_en_reg;

endmodule