module alu(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output reg [31:0] r,
    output zero,
    output carry,
    output negative,
    output overflow,
    output reg flag
);

    // Operation codes
    parameter ADD  = 6'b100000;
    parameter ADDU = 6'b100001;
    parameter SUB  = 6'b100010;
    parameter SUBU = 6'b100011;
    parameter AND  = 6'b100100;
    parameter OR   = 6'b100101;
    parameter XOR  = 6'b100110;
    parameter NOR  = 6'b100111;
    parameter SLT  = 6'b101010;
    parameter SLTU = 6'b101011;
    parameter SLL  = 6'b000000;
    parameter SRL  = 6'b000010;
    parameter SRA  = 6'b000011;
    parameter SLLV = 6'b000100;
    parameter SRLV = 6'b000110;
    parameter SRAV = 6'b000111;
    parameter LUI  = 6'b001111;

    // Internal signals
    wire [31:0] arith_res, logic_res, shift_res;
    wire arith_carry, arith_ovf;
    wire signed [31:0] signed_a = a;
    wire signed [31:0] signed_b = b;
    wire [4:0] shift_amt = (aluc[3]) ? a[4:0] : b[4:0];

    // Arithmetic operations
    assign {arith_carry, arith_res} = 
        (aluc == ADD || aluc == ADDU) ? (a + b) :
        (aluc == SUB || aluc == SUBU) ? (a - b) :
        {1'b0, 32'b0};

    // Overflow detection (only for signed operations)
    assign arith_ovf = 
        (aluc == ADD) ? ((a[31] == b[31]) && (arith_res[31] != a[31])) :
        (aluc == SUB) ? ((a[31] != b[31]) && (arith_res[31] != a[31])) :
        1'b0;

    // Logic operations
    assign logic_res = 
        (aluc == AND) ? (a & b) :
        (aluc == OR)  ? (a | b) :
        (aluc == XOR) ? (a ^ b) :
        (aluc == NOR) ? ~(a | b) :
        32'b0;

    // Shift operations
    assign shift_res = 
        (aluc == SLL || aluc == SLLV) ? (b << shift_amt) :
        (aluc == SRL || aluc == SRLV) ? (b >> shift_amt) :
        (aluc == SRA || aluc == SRAV) ? (($signed(b)) >>> shift_amt) :
        32'b0;

    // Comparison operations
    always @(*) begin
        case(aluc)
            SLT:  flag = (signed_a < signed_b);
            SLTU: flag = (a < b);
            default: flag = 1'b0;
        endcase
    end

    // Result selection
    always @(*) begin
        case(aluc)
            ADD, ADDU, SUB, SUBU: r = arith_res;
            AND, OR, XOR, NOR:    r = logic_res;
            SLL, SRL, SRA, SLLV, SRLV, SRAV: r = shift_res;
            LUI:                   r = {b[15:0], 16'b0};
            SLT, SLTU:             r = {31'b0, flag};
            default:               r = 32'bz;
        endcase
    end

    // Flag generation
    assign zero = (r == 32'b0);
    assign negative = r[31];
    assign carry = (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU) ? arith_carry : 1'b0;
    assign overflow = arith_ovf;

endmodule