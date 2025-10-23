module alu(
    input [31:0] a, b,
    input [5:0] aluc,
    output [31:0] r,
    output zero, carry, negative, overflow, flag
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

always @(*) begin
    case (aluc)
        ADD: res = a + b;
        ADDU: res = a + b;
        SUB: res = a - b;
        SUBU: res = a - b;
        AND: res = a & b;
        OR: res = a | b;
        XOR: res = a ^ b;
        NOR: res = ~(a | b);
        SLT: res = (signed'(a) < signed'(b))? 32'b1 : 32'b0;
        SLTU: res = (a < b)? 32'b1 : 32'b0;
        SLL: res = a << 5'b0;
        SRL: res = a >> 5'b0;
        SRA: res = a >>> 5'b0;
        SLLV: res = a << b[4:0];
        SRLV: res = a >> b[4:0];
        SRAV: res = a >>> b[4:0];
        LUI: res = {a[15:0], 16'b0};
        default: res = 32'bz;
    endcase
end

assign r = res;
assign zero = (res == 0)? 1'b1 : 1'b0;
assign carry = (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU)? (res[31]!= (a[31] ^ b[31])) : 1'b0;
assign negative = res[31]? 1'b1 : 1'b0;
assign overflow = (aluc == ADD || aluc == SUB)? ((a[31] == b[31]) && (a[31]!= res[31])) : 1'b0;
assign flag = (aluc == SLT || aluc == SLTU)? res[0] : 1'bz;

endmodule