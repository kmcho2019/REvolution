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

// Define the module parameters
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

// Perform operations based on aluc
always @(*) begin
    case (aluc)
        ADD, ADDU: r = a + b;
        SUB, SUBU: r = a - b;
        AND: r = a & b;
        OR: r = a | b;
        XOR: r = a ^ b;
        NOR: r = ~(a | b);
        SLL: r = a << b[4:0];
        SRL: r = a >> b[4:0];
        SRA: r = a >>> b[4:0];
        SLLV: r = a << a[4:0];
        SRLV: r = a >> a[4:0];
        SRAV: r = a >>> a[4:0];
        SLT: r = (signed'(a) < signed'(b)) ? 32'h1 : 32'h0;
        SLTU: r = (a < b) ? 32'h1 : 32'h0;
        LUI: r = {a[15:0], 16'h0};
        default: r = 32'bz;
    endcase
end

// Generate flags
assign zero = (r == 32'h0) ? 1'b1 : 1'b0;
assign carry = ((aluc == ADD) || (aluc == ADDU) || (aluc == SUB) || (aluc == SUBU)) ?
               ((a[31] == 1'b0 && b[31] == 1'b0 && r[31] == 1'b1) ||
                (a[31] == 1'b1 && b[31] == 1'b1 && r[31] == 1'b0)) : 
               1'b0;
assign negative = r[31];
assign overflow = ((aluc == ADD) || (aluc == ADDU) || (aluc == SUB) || (aluc == SUBU)) ?
                  ((a[31] == 1'b0 && b[31] == 1'b0 && r[31] == 1'b1) ||
                   (a[31] == 1'b1 && b[31] == 1'b1 && r[31] == 1'b0)) : 
                  1'b0;
assign flag = ((aluc == SLT) || (aluc == SLTU)) ? r[0] : 1'b0;

endmodule