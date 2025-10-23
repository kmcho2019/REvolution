module alu(
    input wire [31:0] a,
    input wire [31:0] b,
    input wire [5:0] aluc,
    output wire [31:0] r,
    output wire zero,
    output wire carry,
    output wire negative,
    output wire overflow,
    output wire flag
);

parameter ADD = 6'b100000;
parameter ADDU = 6'b100001;
parameter SUB = 6'b100010;
parameter SUBU = 6'b100011;
parameter AND = 6'b100100;
parameter OR = 6'b100101;
parameter XOR = 6'b100110;
parameter NOR = 6'b100111;
parameter SLT = 6'b101010;
parameter SLTU = 6'b101011;
parameter SLL = 6'b000000;
parameter SRL = 6'b000010;
parameter SRA = 6'b000011;
parameter SLLV = 6'b000100;
parameter SRLV = 6'b000110;
parameter SRAV = 6'b000111;
parameter LUI = 6'b001111;

wire [31:0] add_result;
wire [31:0] sub_result;
wire [31:0] and_result;
wire [31:0] or_result;
wire [31:0] xor_result;
wire [31:0] nor_result;
wire [31:0] slt_result;
wire [31:0] sltu_result;
wire [31:0] sll_result;
wire [31:0] srl_result;
wire [31:0] sra_result;
wire [31:0] lui_result;

assign add_result = a + b;
assign sub_result = a - b;
assign and_result = a & b;
assign or_result = a | b;
assign xor_result = a ^ b;
assign nor_result = ~(a | b);
assign slt_result = (a < b) ? 32'd1 : 32'd0;
assign sltu_result = (a < b) ? 32'd1 : 32'd0;
assign sll_result = a << b[4:0];
assign srl_result = a >> b[4:0];
assign sra_result = a >>> b[4:0];
assign lui_result = {a[15:0], 16'd0};

assign r = (aluc == ADD) ? add_result :
           (aluc == ADDU) ? add_result :
           (aluc == SUB) ? sub_result :
           (aluc == SUBU) ? sub_result :
           (aluc == AND) ? and_result :
           (aluc == OR) ? or_result :
           (aluc == XOR) ? xor_result :
           (aluc == NOR) ? nor_result :
           (aluc == SLT) ? slt_result :
           (aluc == SLTU) ? sltu_result :
           (aluc == SLL) ? sll_result :
           (aluc == SRL) ? srl_result :
           (aluc == SRA) ? sra_result :
           (aluc == LUI) ? lui_result : 32'd0;

assign zero = (r == 0);
assign carry = (a[31] == b[31] && a[31] != r[31]);
assign negative = r[31];
assign overflow = (a[31] == b[31] && a[31] != r[31]);
assign flag = (aluc == SLT || aluc == SLTU) ? (a < b) : 1'd0;

endmodule