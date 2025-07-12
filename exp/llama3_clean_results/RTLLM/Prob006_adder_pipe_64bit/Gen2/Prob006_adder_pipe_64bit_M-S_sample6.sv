module adder_pipe_64bit #(
    parameter DATA_WIDTH = 64
)(
    input clk,
    input rst_n,
    input i_en,
    input [DATA_WIDTH-1:0] adda,
    input [DATA_WIDTH-1:0] addb,
    output [DATA_WIDTH:0] result,
    output o_en
);

reg [DATA_WIDTH-1:0] adda_reg, addb_reg;
reg i_en_reg;
reg [DATA_WIDTH:0] sum_reg;
reg o_en_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        adda_reg <= {DATA_WIDTH{1'b0}};
        addb_reg <= {DATA_WIDTH{1'b0}};
        i_en_reg <= 1'b0;
        sum_reg <= {DATA_WIDTH+1{1'b0}};
        o_en_reg <= 1'b0;
    end else begin
        adda_reg <= adda;
        addb_reg <= addb;
        i_en_reg <= i_en;
        if (i_en) begin
            sum_reg <= {1'b0} + adda_reg + addb_reg; // Properly handle the carry signal
            o_en_reg <= 1'b1;
        end else begin
            o_en_reg <= 1'b0;
        end
    end
end

assign result = sum_reg;
assign o_en = o_en_reg;

endmodule