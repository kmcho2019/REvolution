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

// Internal wires
wire [31:0] arith_result;
wire [31:0] logic_result;
wire [31:0] shift_result;

// Arithmetic operations
assign arith_result = (aluc == ADD)? a + b :
                      (aluc == ADDU)? a + b :
                      (aluc == SUB)? a - b :
                      (aluc == SUBU)? a - b :
                      32'bx;

// Logical operations
assign logic_result = (aluc == AND)? a & b :
                     (aluc == OR)? a | b :
                     (aluc == XOR)? a ^ b :
                     (aluc == NOR)? ~(a | b) :
                     32'bx;

// Shift operations
assign shift_result = (aluc == SLL)? a << b[4:0] :
                     (aluc == SRL)? a >> b[4:0] :
                     (aluc == SRA)? a >>> b[4:0] :
                     (aluc == SLLV)? a << b :
                     (aluc == SRLV)? a >> b :
                     (aluc == SRAV)? a >>> b :
                     32'bx;

// ALU logic
always @(*) begin
    case(aluc)
        LUI: r = {16'b0, a[15:0]};
        SLL, SRL, SRA, SLLV, SRLV, SRAV: r = shift_result;
        AND, OR, XOR, NOR: r = logic_result;
        ADD, ADDU, SUB, SUBU: r = arith_result;
        SLT: r = (signed'(a) < signed'(b))? 32'd1 : 32'd0;
        SLTU: r = (a < b)? 32'd1 : 32'd0;
        default: r = 32'bx;
    endcase
    
    // Calculate flags
    zero = (r == 32'd0);
    carry = ((aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU) && (r[31] == 1'b1))? 1'b1 : 1'b0;
    negative = (r[31] == 1'b1);
    overflow = ((aluc == ADD || aluc == SUB) && (a[31]!= b[31]) && (a[31]!= r[31]))? 1'b1 : 1'b0;
    flag = ((aluc == SLT && (signed'(a) < signed'(b))) || (aluc == SLTU && (a < b)))? 1'b1 : 1'b0;
end

endmodule