module alu(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output [31:0] r,
    output zero,
    output carry,
    output negative,
    output overflow,
    output flag
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
wire [31:0] shift_result;
wire [31:0] logic_result;
wire [31:0] slt_result;

assign add_result = a + b;
assign sub_result = a - b;
assign shift_result = (aluc == SLL) ? a << b[4:0] :
                     (aluc == SRL) ? a >> b[4:0] :
                     (aluc == SRA) ? a >>> b[4:0] :
                     (aluc == SLLV) ? a << a[4:0] :
                     (aluc == SRLV) ? a >> a[4:0] :
                     (aluc == SRAV) ? a >>> a[4:0] : 32'bz;

assign logic_result = (aluc == AND) ? a & b :
                     (aluc == OR) ? a | b :
                     (aluc == XOR) ? a ^ b :
                     (aluc == NOR) ? ~(a | b) : 32'bz;

assign slt_result = (aluc == SLT) ? (signed'(a) < signed'(b)) ? 32'h1 : 32'h0 :
                   (aluc == SLTU) ? (a < b) ? 32'h1 : 32'h0 : 32'bz;

assign r = (aluc == ADD || aluc == ADDU) ? add_result :
           (aluc == SUB || aluc == SUBU) ? sub_result :
           (aluc == SLL || aluc == SRL || aluc == SRA || aluc == SLLV || aluc == SRLV || aluc == SRAV) ? shift_result :
           (aluc == AND || aluc == OR || aluc == XOR || aluc == NOR) ? logic_result :
           (aluc == SLT || aluc == SLTU) ? slt_result :
           (aluc == LUI) ? {16'd0, b[15:0]} : 32'bz;

assign zero = (r == 32'h0);
assign carry = (aluc == ADD || aluc == SUB) ? (add_result[31] != a[31]) : 1'b0;
assign negative = r[31];
assign overflow = (aluc == ADD || aluc == SUB) ? (a[31] == b[31] && r[31] != a[31]) : 1'b0;
assign flag = (aluc == SLT || aluc == SLTU) ? r[0] : 1'b0;

endmodule