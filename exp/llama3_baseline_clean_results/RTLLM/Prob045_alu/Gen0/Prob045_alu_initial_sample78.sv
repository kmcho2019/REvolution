module alu (
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
reg [5:0] shift_amount;

always @(*) begin
    res = 32'd0;
    case (aluc)
        ADD: res = a + b;
        ADDU: res = a + b;
        SUB: res = a - b;
        SUBU: res = a - b;
        AND: res = a & b;
        OR: res = a | b;
        XOR: res = a ^ b;
        NOR: res = ~(a | b);
        SLT: res = (a < b) ? 32'd1 : 32'd0;
        SLTU: res = ({32{a[31]}} + a) < ({32{b[31]}} + b) ? 32'd1 : 32'd0;
        SLL: shift_amount = a[4:0]; res = b << shift_amount;
        SRL: shift_amount = a[4:0]; res = b >> shift_amount;
        SRA: shift_amount = a[4:0]; res = {b[31], b[31:1]} >> shift_amount;
        SLLV: res = b << a[4:0];
        SRLV: res = b >> a[4:0];
        SRAV: res = {b[31], b[31:1]} >> a[4:0];
        LUI: res = {a[15:0], 16'd0};
        default: res = 32'dz;
    endcase

    r = res;
    zero = (res == 32'd0);
    carry = (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU) && (res[31] != (a[31] ^ b[31]));
    negative = (aluc == ADD || aluc == SUB) && res[31];
    overflow = (aluc == ADD || aluc == SUB) && ((a[31] && b[31] && !res[31]) || (!a[31] && !b[31] && res[31]));
    flag = (aluc == SLT || aluc == SLTU) ? res[0] : 1'dz;
end

endmodule