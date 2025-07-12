module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output o_en
);

reg [63:0] a_reg;
reg [63:0] b_reg;
reg i_en_reg;
reg [63:0] sum_reg;
reg o_en_reg;

// Stage 1: Register input operands and enable signal
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        a_reg <= 64'd0;
        b_reg <= 64'd0;
        i_en_reg <= 1'b0;
    end else if (i_en) begin
        a_reg <= adda;
        b_reg <= addb;
        i_en_reg <= i_en;
    end
end

// Stage 2: Perform addition and store sum
reg [64:0] sum;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum_reg <= 65'd0;
    end else if (i_en_reg) begin
        sum_reg <= a_reg + b_reg;
    end
end

// Stage 3: Update output enable signal
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        o_en_reg <= 1'b0;
    end else if (i_en_reg) begin
        o_en_reg <= 1'b1;
    end else begin
        o_en_reg <= 1'b0;
    end
end

// Assign output signals
assign result = sum_reg;
assign o_en = o_en_reg;

endmodule