module adder_pipe_64bit (
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
reg [64:0] sum;
reg o_en_reg;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg_adda <= 64'd0;
        reg_addb <= 64'd0;
        sum <= 65'd0;
        o_en_reg <= 1'b0;
    end else if (i_en) begin
        reg_adda <= adda;
        reg_addb <= addb;
        sum <= {1'b0, adda} + {1'b0, addb};
        o_en_reg <= 1'b1;
    end else begin
        o_en_reg <= 1'b0;
    end
end

assign result = sum;
assign o_en = o_en_reg;

endmodule