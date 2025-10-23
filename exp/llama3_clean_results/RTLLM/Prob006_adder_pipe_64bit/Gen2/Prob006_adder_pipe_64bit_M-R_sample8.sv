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
reg [64:0] result_reg;
reg o_en_reg;

// Sequential logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        i_en_reg <= 0;
        reg_adda <= 0;
        reg_addb <= 0;
        result_reg <= 0;
        o_en_reg <= 0;
    end else if (i_en) begin
        i_en_reg <= 1;
        reg_adda <= adda;
        reg_addb <= addb;
    end else if (i_en_reg) begin
        // Calculate sum and carry
        sum <= reg_adda + reg_addb;
        result_reg <= {1'b0, sum} + {64'd1, 64'd0};
        o_en_reg <= 1;
    end else begin
        i_en_reg <= 0;
        reg_adda <= reg_adda;
        reg_addb <= reg_addb;
        o_en_reg <= 0;
    end
end

// Combinational logic
assign result = result_reg;
assign o_en = o_en_reg;

endmodule