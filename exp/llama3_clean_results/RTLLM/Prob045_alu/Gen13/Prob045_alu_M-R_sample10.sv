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

// Calculate the result (r)
assign r = (aluc == LUI) ? {a[15:0], 16'd0} :
           (aluc == SLL) ? a << b[4:0] :
           (aluc == SRL) ? a >> b[4:0] :
           (aluc == SRA) ? a >>> b[4:0] :
           (aluc == SLLV) ? a << b[4:0] :
           (aluc == SRLV) ? a >> b[4:0] :
           (aluc == SRAV) ? a >>> b[4:0] :
           (aluc == AND) ? a & b :
           (aluc == OR) ? a | b :
           (aluc == XOR) ? a ^ b :
           (aluc == NOR) ? ~(a | b) :
           (aluc == ADD) ? a + b :
           (aluc == ADDU) ? a + b :
           (aluc == SUB) ? a - b :
           (aluc == SUBU) ? a - b :
           (aluc == SLT) ? (signed'(a) < signed'(b)) ? 32'd1 : 32'd0 :
           (aluc == SLTU) ? (a < b) ? 32'd1 : 32'd0 :
           32'bx;

// Calculate the zero flag
assign zero = (r == 32'd0) ? 1'b1 : 1'b0;

// Calculate the carry flag
assign carry = (aluc == ADD) ? ((a[31]!= b[31]) && (a[31]!= r[31])) ? 1'b1 : 1'b0 :
               (aluc == ADDU) ? (r[31] == 1'b1) ? 1'b1 : 1'b0 :
               (aluc == SUB) ? ((a[31]== b[31]) && (a[31]!= r[31])) ? 1'b1 : 1'b0 :
               (aluc == SUBU) ? (r[31] == 1'b1) ? 1'b1 : 1'b0 :
               1'b0;

// Calculate the negative flag
assign negative = (r[31] == 1'b1) ? 1'b1 : 1'b0;

// Calculate the overflow flag
assign overflow = (aluc == ADD) ? ((a[31]!= b[31]) && (a[31]!= r[31])) ? 1'b1 : 1'b0 :
                  (aluc == SUB) ? ((a[31]== b[31]) && (a[31]!= r[31])) ? 1'b1 : 1'b0 :
                  1'b0;

// Calculate the flag
assign flag = (aluc == SLT) ? (signed'(a) < signed'(b)) ? 1'b1 : 1'b0 :
               (aluc == SLTU) ? (a < b) ? 1'b1 : 1'b0 :
               1'b0;

endmodule