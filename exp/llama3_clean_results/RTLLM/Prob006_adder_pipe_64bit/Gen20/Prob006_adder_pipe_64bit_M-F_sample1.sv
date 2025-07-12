module adder_pipe_64bit (
    input           clk,
    input           rst_n,
    input           i_en,
    input   [63:0]  adda,
    input   [63:0]  addb,
    output  [64:0]  result,
    output          o_en
);

reg [7:0] adda_reg [7:0];
reg [7:0] addb_reg [7:0];
reg [64:0] result_reg;
reg         o_en_reg;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (int i = 0; i < 8; i++) begin
            adda_reg[i] <= 8'b0;
            addb_reg[i] <= 8'b0;
        end
        o_en_reg <= 1'b0;
        result_reg <= 65'b0;
    end else if (i_en) begin
        for (int i = 0; i < 8; i++) begin
            adda_reg[i] <= adda[(i*8)+7:i*8];
            addb_reg[i] <= addb[(i*8)+7:i*8];
        end
        o_en_reg <= 1'b1;
    end else begin
        o_en_reg <= 1'b0;
    end
end

reg [64:0] sum;
always @ (*) begin
    sum = {1'b0, adda_reg[0]} + {1'b0, addb_reg[0]};
    for (int i = 1; i < 8; i++) begin
        sum = {sum[63:0], adda_reg[i]} + {sum[63:0], addb_reg[i]} + {64'b0, sum[64]};
    end
end

always @ (posedge clk) begin
    if (i_en) begin
        result_reg <= sum;
    end
end

assign result = result_reg;
assign o_en = o_en_reg;

endmodule