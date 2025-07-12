module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output o_en
);

reg [63:0] adda_reg;
reg [63:0] addb_reg;
reg i_en_reg;
reg [64:0] sum_reg;
reg o_en_reg;

// Stage 1: Input register stage
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

// Stage 2: Ripple carry adder stage
reg [63:0] sum;
reg carry;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum <= 64'd0;
        carry <= 1'b0;
    end else if (i_en_reg) begin
        {carry, sum} <= adda_reg + addb_reg;
    end else begin
        sum <= sum;
        carry <= carry;
    end
end

// Stage 3: Output register stage
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum_reg <= 65'd0;
        o_en_reg <= 1'b0;
    end else if (i_en_reg) begin
        sum_reg <= {carry, sum};
        o_en_reg <= 1'b1;
    end else begin
        sum_reg <= sum_reg;
        o_en_reg <= o_en_reg;
    end
end

assign result = sum_reg;
assign o_en = o_en_reg;

endmodule