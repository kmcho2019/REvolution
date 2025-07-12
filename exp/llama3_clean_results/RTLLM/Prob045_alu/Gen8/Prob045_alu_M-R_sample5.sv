module alu(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output [31:0] r,
    output zero,
    output carry_out,
    output negative,
    output overflow_out,
    output flag
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

// Declare internal wires for result, carry, and overflow
wire [31:0] result;
wire carry_int;
wire overflow_int;

// Assign outputs
assign r = result;
assign zero = (result == 32'h0);
assign carry_out = carry_int;
assign negative = result[31];
assign overflow_out = overflow_int;
assign flag = (aluc == SLT || aluc == SLTU)? result[0] : 1'b0;

// Perform operations based on aluc
assign result = (aluc == ADD || aluc == ADDU)? a + b :
                (aluc == SUB || aluc == SUBU)? a - b :
                (aluc == AND)? a & b :
                (aluc == OR)? a | b :
                (aluc == XOR)? a ^ b :
                (aluc == NOR)? ~(a | b) :
                (aluc == SLT)? (signed'(a) < signed'(b))? 32'h1 : 32'h0 :
                (aluc == SLTU)? (a < b)? 32'h1 : 32'h0 :
                (aluc == SLL)? a << b[4:0] :
                (aluc == SRL)? a >> b[4:0] :
                (aluc == SRA)? a >>> b[4:0] :
                (aluc == SLLV)? a << a[4:0] :
                (aluc == SRLV)? a >> a[4:0] :
                (aluc == SRAV)? a >>> a[4:0] :
                (aluc == LUI)? {16'd0, a[15:0]} : 32'bz;

// Calculate carry and overflow
assign carry_int = (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU)? (a[31] == b[31] && result[31] != a[31]) : 1'b0;
assign overflow_int = (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU)? (a[31] != b[31] && result[31] != a[31]) : 1'b0;

endmodule