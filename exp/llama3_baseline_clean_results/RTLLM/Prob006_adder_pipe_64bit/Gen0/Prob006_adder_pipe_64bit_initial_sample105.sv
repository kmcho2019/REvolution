module adder_pipe_64bit (
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
reg [63:0] sum;
reg [63:0] carry;
reg o_en_reg;

assign result = {carry[63], sum};
assign o_en = o_en_reg;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        adda_reg <= 64'd0;
        addb_reg <= 64'd0;
        i_en_reg <= 1'd0;
        sum <= 64'd0;
        carry <= 64'd0;
        o_en_reg <= 1'd0;
    end else begin
        // Input Stage
        adda_reg <= adda;
        addb_reg <= addb;
        i_en_reg <= i_en;
        
        // Addition Stage
        sum <= adda_reg + addb_reg;
        carry <= (adda_reg + addb_reg) >> 64;
        
        // Output Stage
        if (i_en_reg) begin
            o_en_reg <= 1'd1;
        end else begin
            o_en_reg <= 1'd0;
        end
    end
end

endmodule