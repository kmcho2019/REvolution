module alu(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output reg [31:0] r,
    output reg zero,
    output reg carry,
    output reg negative,
    output reg overflow,
    output reg flag
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

always @(*)
begin
    case(aluc)
        ADD: 
        begin
            {carry, r} = a + b;
            overflow = (a[31] == b[31] && b[31]!= r[31]);
        end
        ADDU: 
        begin
            {carry, r} = a + b;
            overflow = 1'b0;
        end
        SUB: 
        begin
            {carry, r} = a - b;
            overflow = (a[31]!= b[31] && b[31] == r[31]);
        end
        SUBU: 
        begin
            {carry, r} = a - b;
            overflow = 1'b0;
        end
        AND: r = a & b;
        OR: r = a | b;
        XOR: r = a ^ b;
        NOR: r = ~(a | b);
        SLT: 
        begin
            flag = (signed'(a) < signed'(b))? 1'b1 : 1'b0;
            r = 32'b0;
        end
        SLTU: 
        begin
            flag = (a < b)? 1'b1 : 1'b0;
            r = 32'b0;
        end
        SLL: r = a << b[4:0];
        SRL: r = a >> b[4:0];
        SRA: r = a >>> b[4:0];
        SLLV: r = a << a[4:0];
        SRLV: r = a >> a[4:0];
        SRAV: r = a >>> a[4:0];
        LUI: r = {a[15:0], 16'b0};
        default: r = 32'bz;
    endcase
    zero = (r == 32'b0)? 1'b1 : 1'b0;
    negative = r[31];
end

endmodule