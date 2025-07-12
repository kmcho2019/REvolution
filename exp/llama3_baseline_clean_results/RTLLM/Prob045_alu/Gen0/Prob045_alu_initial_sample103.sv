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

reg [31:0] res;
reg zero, carry, negative, overflow, flag;

always @(*) begin
    case (aluc)
        ADD: begin
            res = a + b;
            carry = (a[31] & b[31] & ~res[31]) | (~a[31] & ~b[31] & res[31]);
            overflow = carry;
        end
        ADDU: begin
            res = a + b;
            carry = (a[31] & b[31] & ~res[31]) | (~a[31] & ~b[31] & res[31]);
            overflow = 0;
        end
        SUB: begin
            res = a - b;
            carry = (a[31] & ~b[31] & ~res[31]) | (~a[31] & b[31] & res[31]);
            overflow = carry;
        end
        SUBU: begin
            res = a - b;
            carry = (a[31] & ~b[31] & ~res[31]) | (~a[31] & b[31] & res[31]);
            overflow = 0;
        end
        AND: res = a & b;
        OR: res = a | b;
        XOR: res = a ^ b;
        NOR: res = ~(a | b);
        SLT: begin
            res = (a < b) ? 1 : 0;
            flag = res[0];
        end
        SLTU: begin
            res = (a < b) ? 1 : 0;
            flag = res[0];
        end
        SLL: res = a << b[4:0];
        SRL: res = a >> b[4:0];
        SRA: res = (a[31] ? -1 : 0) >> b[4:0];
        SLLV: res = a << b;
        SRLV: res = a >> b;
        SRAV: res = (a[31] ? -1 : 0) >> b;
        LUI: res = {a[15:0], 16'b0};
        default: res = {32{1'bz}};
    endcase

    zero = ~|res;
    negative = res[31];
    flag = (aluc == SLT || aluc == SLTU) ? res[0] : 1'bz;
end

assign r = res;

endmodule