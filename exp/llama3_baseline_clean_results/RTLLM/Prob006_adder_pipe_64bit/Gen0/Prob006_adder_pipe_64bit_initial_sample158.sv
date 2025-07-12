module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output o_en
);

reg [63:0] adda_reg1, adda_reg2, adda_reg3;
reg [63:0] addb_reg1, addb_reg2, addb_reg3;
reg [63:0] sum_reg1, sum_reg2, sum_reg3;
reg [0:0] carry_reg1, carry_reg2, carry_reg3;
reg i_en_reg1, i_en_reg2, i_en_reg3;
reg o_en_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        adda_reg1 <= 64'd0;
        adda_reg2 <= 64'd0;
        adda_reg3 <= 64'd0;
        addb_reg1 <= 64'd0;
        addb_reg2 <= 64'd0;
        addb_reg3 <= 64'd0;
        sum_reg1 <= 64'd0;
        sum_reg2 <= 64'd0;
        sum_reg3 <= 64'd0;
        carry_reg1 <= 1'b0;
        carry_reg2 <= 1'b0;
        carry_reg3 <= 1'b0;
        i_en_reg1 <= 1'b0;
        i_en_reg2 <= 1'b0;
        i_en_reg3 <= 1'b0;
        o_en_reg <= 1'b0;
    end else begin
        // Stage 1: Input registers
        adda_reg1 <= adda;
        addb_reg1 <= addb;
        i_en_reg1 <= i_en;

        // Stage 2: Calculation and carry generation
        adda_reg2 <= adda_reg1;
        addb_reg2 <= addb_reg1;
        sum_reg1 <= adda_reg1 + addb_reg1;
        carry_reg1 <= (adda_reg1[63] + addb_reg1[63] + 1'd0) >> 1;
        i_en_reg2 <= i_en_reg1;

        // Stage 3: Carry propagation and sum calculation
        adda_reg3 <= {carry_reg1, adda_reg2[62:0]};
        addb_reg3 <= addb_reg2;
        sum_reg2 <= adda_reg3 + addb_reg3;
        carry_reg2 <= (adda_reg3[63] + addb_reg3[63] + 1'd0) >> 1;
        i_en_reg3 <= i_en_reg2;

        // Stage 4: Final calculation and result
        sum_reg3 <= {carry_reg2, sum_reg2[62:0]};
        carry_reg3 <= (sum_reg3[63] + 1'd0) >> 1;
        o_en_reg <= i_en_reg3;
    end
end

assign result = {carry_reg3, sum_reg3[63:0]};
assign o_en = o_en_reg;

endmodule