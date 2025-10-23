module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output o_en
);

// Stage 1: Input registers for operands A and B
reg [63:0] adda_reg1;
reg [63:0] addb_reg1;
reg i_en_reg1;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        adda_reg1 <= 64'd0;
        addb_reg1 <= 64'd0;
        i_en_reg1 <= 1'b0;
    end else if (i_en) begin
        adda_reg1 <= adda;
        addb_reg1 <= addb;
        i_en_reg1 <= 1'b1;
    end
end

// Stage 2: Ripple carry adder
reg [63:0] sum_reg2;
reg carry_out_reg2;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum_reg2 <= 64'd0;
        carry_out_reg2 <= 1'b0;
    end else if (i_en_reg1) begin
        {carry_out_reg2, sum_reg2} <= adda_reg1 + addb_reg1;
    end
end

// Stage 3: Output register for the result
reg [64:0] result_reg3;
reg i_en_reg3;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        result_reg3 <= 65'd0;
        i_en_reg3 <= 1'b0;
    end else if (i_en_reg1) begin
        result_reg3 <= {carry_out_reg2, sum_reg2};
        i_en_reg3 <= 1'b1;
    end
end

// Stage 4: Output enable signal generation
reg o_en_reg4;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        o_en_reg4 <= 1'b0;
    end else if (i_en_reg3) begin
        o_en_reg4 <= 1'b1;
    end else if (~i_en_reg3) begin
        o_en_reg4 <= 1'b0;
    end
end

assign result = result_reg3;
assign o_en = o_en_reg4;

endmodule