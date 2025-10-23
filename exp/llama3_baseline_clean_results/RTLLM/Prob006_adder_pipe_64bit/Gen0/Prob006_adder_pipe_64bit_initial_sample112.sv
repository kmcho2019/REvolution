module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Input registers
reg [63:0] adda_reg1;
reg [63:0] addb_reg1;
reg i_en_reg1;
reg [63:0] adda_reg2;
reg [63:0] addb_reg2;
reg i_en_reg2;
reg [63:0] adda_reg3;
reg [63:0] addb_reg3;
reg i_en_reg3;

// 16-bit ripple carry adder stages
wire [15:0] sum1;
wire [15:0] sum2;
wire [15:0] sum3;
wire [15:0] sum4;
wire c_out1;
wire c_out2;
wire c_out3;

// Output registers
reg [64:0] result_reg;

// First 16-bit ripple carry adder stage
assign sum1 = adda_reg1[15:0] + addb_reg1[15:0];
assign c_out1 = (adda_reg1[15:0] + addb_reg1[15:0]) > 16'd65535;

// Second 16-bit ripple carry adder stage
assign sum2 = adda_reg2[31:16] + addb_reg2[31:16] + c_out1;
assign c_out2 = (adda_reg2[31:16] + addb_reg2[31:16] + c_out1) > 16'd65535;

// Third 16-bit ripple carry adder stage
assign sum3 = adda_reg3[47:32] + addb_reg3[47:32] + c_out2;
assign c_out3 = (adda_reg3[47:32] + addb_reg3[47:32] + c_out2) > 16'd65535;

// Fourth 16-bit ripple carry adder stage
assign result_reg[15:0] = sum1;
assign result_reg[31:16] = sum2;
assign result_reg[47:32] = sum3;
assign result_reg[63:48] = adda_reg3[63:48] + addb_reg3[63:48] + c_out3;
assign result_reg[64] = (adda_reg3[63:48] + addb_reg3[63:48] + c_out3) > 16'd65535;

// Output enable signal
reg o_en_reg1;
reg o_en_reg2;
reg o_en_reg3;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        adda_reg1 <= 64'd0;
        addb_reg1 <= 64'd0;
        i_en_reg1 <= 1'd0;
        adda_reg2 <= 64'd0;
        addb_reg2 <= 64'd0;
        i_en_reg2 <= 1'd0;
        adda_reg3 <= 64'd0;
        addb_reg3 <= 64'd0;
        i_en_reg3 <= 1'd0;
        result_reg <= 65'd0;
        o_en_reg1 <= 1'd0;
        o_en_reg2 <= 1'd0;
        o_en_reg3 <= 1'd0;
        o_en <= 1'd0;
    end else begin
        adda_reg1 <= adda;
        addb_reg1 <= addb;
        i_en_reg1 <= i_en;
        adda_reg2 <= adda_reg1;
        addb_reg2 <= addb_reg1;
        i_en_reg2 <= i_en_reg1;
        adda_reg3 <= adda_reg2;
        addb_reg3 <= addb_reg2;
        i_en_reg3 <= i_en_reg2;
        result <= result_reg;
        o_en_reg1 <= i_en_reg1;
        o_en_reg2 <= o_en_reg1;
        o_en_reg3 <= o_en_reg2;
        o_en <= o_en_reg3;
    end
end

endmodule