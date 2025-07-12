module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output o_en
);

reg [63:0] reg_adda;
reg [63:0] reg_addb;
reg i_en_reg;
reg [63:0] sum;
reg [63:0] carry;
reg o_en_reg;

// Synchronize input enable signal and input operands
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        i_en_reg <= 0;
        reg_adda <= 0;
        reg_addb <= 0;
    end else if (i_en) begin
        i_en_reg <= 1;
        reg_adda <= adda;
        reg_addb <= addb;
    end else begin
        i_en_reg <= 0;
        reg_adda <= reg_adda;
        reg_addb <= reg_addb;
    end
end

// Calculate sum and carry
assign sum = reg_adda + reg_addb;
assign carry = (reg_adda + reg_addb) > 64'd18446744073709551615;

// Update output enable signal
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        o_en_reg <= 0;
    end else if (i_en_reg) begin
        o_en_reg <= 1;
    end else if (~i_en_reg && sum != 0) begin
        o_en_reg <= 1;
    end else begin
        o_en_reg <= 0;
    end
end

// Update result
assign result = {carry, sum};
assign o_en = o_en_reg;

endmodule