module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output o_en
);

reg [63:0] adda_reg1;
reg [63:0] addb_reg1;
reg [63:0] adda_reg2;
reg [63:0] addb_reg2;
reg [64:0] sum_reg;
reg o_en_reg;
reg [63:0] adda_reg3;
reg [63:0] addb_reg3;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        adda_reg1 <= 64'd0;
        addb_reg1 <= 64'd0;
        adda_reg2 <= 64'd0;
        addb_reg2 <= 64'd0;
        adda_reg3 <= 64'd0;
        addb_reg3 <= 64'd0;
        sum_reg <= 65'd0;
        o_en_reg <= 1'b0;
    end else begin
        adda_reg1 <= adda;
        addb_reg1 <= addb;
        adda_reg2 <= adda_reg1;
        addb_reg2 <= addb_reg1;
        adda_reg3 <= adda_reg2;
        addb_reg3 <= addb_reg2;
        if (i_en) begin
            o_en_reg <= 1'b1;
        end else begin
            o_en_reg <= 1'b0;
        end
    end
end

reg [63:0] sum;
wire [63:0] carry;

always @ (*) begin
    sum = adda_reg3 + addb_reg3;
    carry = (sum[63] == 1) ? 1 : 0;
    sum_reg = {carry, sum};
end

always @ (posedge clk) begin
    result <= sum_reg;
    o_en <= o_en_reg && i_en;
end

endmodule