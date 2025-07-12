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

// Define operation codes
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
    case (aluc)
        ADD:   r = a + b;
        ADDU:  r = a + b;
        SUB:   r = a - b;
        SUBU:  r = a - b;
        AND:   r = a & b;
        OR:    r = a | b;
        XOR:   r = a ^ b;
        NOR:   r = ~(a | b);
        SLL:   r = a << b[4:0];
        SRL:   r = a >> b[4:0];
        SRA:   r = a >>> b[4:0];
        SLT:   r = (signed'(a) < signed'(b))? 32'd1 : 32'd0;
        SLTU:  r = (a < b)? 32'd1 : 32'd0;
        LUI:   r = {a[15:0], 16'd0};
        default: r = 32'bx;
    endcase

    zero = (r == 32'd0);
    carry = ((aluc == ADD) && ((a[31]!= b[31]) && (a[31]!= r[31])))? 1'b1 :
            ((aluc == SUB) && ((a[31]== b[31]) && (a[31]!= r[31])))? 1'b1 : 1'b0;
    negative = (r[31] == 1'b1);
    overflow = ((aluc == ADD) && ((a[31]!= b[31]) && (a[31]!= r[31])))? 1'b1 :
               ((aluc == SUB) && ((a[31]== b[31]) && (a[31]!= r[31])))? 1'b1 : 1'b0;
    flag = (aluc == SLT)? (signed'(a) < signed'(b)) : (aluc == SLTU)? (a < b) : 1'b0;
end

endmodule