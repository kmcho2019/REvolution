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

wire [31:0] res;
reg [31:0] result;

assign r = result;
assign zero = (result == 32'b0) ? 1'b1 : 1'b0;
assign negative = result[31];
assign overflow = (aluc == ADD || aluc == SUB) ? ((a[31] == b[31]) && (result[31] != a[31])) : 1'b0;
assign carry = (aluc == ADDU || aluc == SUBU) ? (({32'b0, a} + {32'b0, b})[31]) : 1'b0;
assign flag = (aluc == SLT || aluc == SLTU) ? (a < b) : 1'bz;

always @(*) begin
    case(aluc)
        ADD: result = a + b;
        ADDU: result = {32'b0, a} + {32'b0, b};
        SUB: result = a - b;
        SUBU: result = {32'b0, a} - {32'b0, b};
        AND: result = a & b;
        OR: result = a | b;
        XOR: result = a ^ b;
        NOR: result = ~(a | b);
        SLT: result = (a < b) ? 32'b1 : 32'b0;
        SLTU: result = ({32'b0, a} < {32'b0, b}) ? 32'b1 : 32'b0;
        SLL: result = a << b[4:0];
        SRL: result = a >> b[4:0];
        SRA: result = a >>> b[4:0];
        SLLV: result = a << a[4:0];
        SRLV: result = a >> a[4:0];
        SRAV: result = a >>> a[4:0];
        LUI: result = {b[15:0], 16'b0};
        default: result = 32'bz;
    endcase
end

endmodule