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

wire [31:0] r_add;
wire [31:0] r_addu;
wire [31:0] r_sub;
wire [31:0] r_subu;
wire [31:0] r_and;
wire [31:0] r_or;
wire [31:0] r_xor;
wire [31:0] r_nor;
wire [31:0] r_slt;
wire [31:0] r_sltu;
wire [31:0] r_sll;
wire [31:0] r_srl;
wire [31:0] r_sra;
wire [31:0] r_sllv;
wire [31:0] r_srlv;
wire [31:0] r_srav;
wire [31:0] r_lui;

assign r_add = a + b;
assign r_addu = a + b;
assign r_sub = a - b;
assign r_subu = a - b;
assign r_and = a & b;
assign r_or = a | b;
assign r_xor = a ^ b;
assign r_nor = ~(a | b);
assign r_slt = (signed'(a) < signed'(b))? 32'h1 : 32'h0;
assign r_sltu = (a < b)? 32'h1 : 32'h0;
assign r_sll = a << b[4:0];
assign r_srl = a >> b[4:0];
assign r_sra = a >>> b[4:0];
assign r_sllv = a << a[4:0];
assign r_srlv = a >> a[4:0];
assign r_srav = a >>> a[4:0];
assign r_lui = {16'd0, b[15:0]};

assign r = (aluc == ADD)? r_add : 
            (aluc == ADDU)? r_addu : 
            (aluc == SUB)? r_sub : 
            (aluc == SUBU)? r_subu : 
            (aluc == AND)? r_and : 
            (aluc == OR)? r_or : 
            (aluc == XOR)? r_xor : 
            (aluc == NOR)? r_nor : 
            (aluc == SLT)? r_slt : 
            (aluc == SLTU)? r_sltu : 
            (aluc == SLL)? r_sll : 
            (aluc == SRL)? r_srl : 
            (aluc == SRA)? r_sra : 
            (aluc == SLLV)? r_sllv : 
            (aluc == SRLV)? r_srlv : 
            (aluc == SRAV)? r_srav : 
            (aluc == LUI)? r_lui : 
            32'bz;

assign zero = (r == 32'h0)? 1'b1 : 1'b0;

// Calculate carry for addition operations
assign carry = ((aluc == ADD) || (aluc == ADDU))? 
               ((a[31] == 1'b0 && b[31] == 1'b0 && r[31] == 1'b1) || 
                (a[31] == 1'b1 && b[31] == 1'b1 && r[31] == 1'b0)) : 
               ((aluc == SUB) || (aluc == SUBU))? 
               ((a[31] == 1'b0 && b[31] == 1'b1 && r[31] == 1'b1) || 
                (a[31] == 1'b1 && b[31] == 1'b0 && r[31] == 1'b0)) : 
               1'b0;

assign negative = r[31];
assign overflow = ((aluc == ADD) || (aluc == ADDU))? 
                  ((a[31] == 1'b0 && b[31] == 1'b0 && r[31] == 1'b1) || 
                   (a[31] == 1'b1 && b[31] == 1'b1 && r[31] == 1'b0)) : 
                  ((aluc == SUB) || (aluc == SUBU))? 
                  ((a[31] == 1'b0 && b[31] == 1'b1 && r[31] == 1'b1) || 
                   (a[31] == 1'b1 && b[31] == 1'b0 && r[31] == 1'b0)) : 
                  1'b0;

assign flag = ((aluc == SLT) || (aluc == SLTU))? 
              (r_slt[0] || r_sltu[0]) : 
              1'b0;

endmodule