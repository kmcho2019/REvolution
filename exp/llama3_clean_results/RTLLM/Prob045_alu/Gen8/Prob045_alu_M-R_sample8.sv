module alu(
    input wire [31:0] a,
    input wire [31:0] b,
    input wire [5:0] aluc,
    output wire [31:0] r,
    output wire zero,
    output wire carry,
    output wire negative,
    output wire overflow,
    output wire flag
);

// Define parameters for operations
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

// Assign outputs using combinational logic
assign r = (
    (aluc == ADD)   ? a + b :
    (aluc == ADDU)  ? a + b :
    (aluc == SUB)   ? a - b :
    (aluc == SUBU)  ? a - b :
    (aluc == AND)   ? a & b :
    (aluc == OR)    ? a | b :
    (aluc == XOR)   ? a ^ b :
    (aluc == NOR)   ? ~(a | b) :
    (aluc == SLL)   ? a << b[4:0] :
    (aluc == SRL)   ? a >> b[4:0] :
    (aluc == SRA)   ? a >>> b[4:0] :
    (aluc == SLLV)  ? b << a[4:0] :
    (aluc == SRLV)  ? b >> a[4:0] :
    (aluc == SRAV)  ? b >>> a[4:0] :
    (aluc == LUI)   ? {b[15:0], 16'd0} :
    (aluc == SLT)   ? (signed'(a) < signed'(b)) ? 32'd1 : 32'd0 :
    (aluc == SLTU)  ? (a < b) ? 32'd1 : 32'd0 :
    32'bx
);

assign zero = (r == 0);
assign carry = (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU) ? (a[31] != b[31] && a[31] == r[31]) : 0;
assign negative = r[31];
assign overflow = (aluc == ADD || aluc == SUB) ? (a[31] == b[31] && a[31] != r[31]) : 0;
assign flag = (aluc == SLT || aluc == SLTU) ? (aluc == SLT) ? (signed'(a) < signed'(b)) : (a < b) : 0;

endmodule