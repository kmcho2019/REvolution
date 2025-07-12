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

    // Arithmetic Unit
    wire [31:0] b_operand = (aluc == SUB || aluc == SUBU) ? ~b : b;
    wire [32:0] arith_result = {1'b0, a} + {1'b0, b_operand} + ((aluc == SUB || aluc == SUBU) ? 1 : 0);
    wire arith_ovf = (a[31] == b_operand[31]) && (arith_result[31] != a[31]);

    // Shift Unit
    wire [4:0] shift_amount = (aluc[3] ? a[4:0] : b[4:0]); // SLLV/SRLV/SRAV use a[4:0]
    wire [31:0] shift_result = 
        (aluc[1:0] == 2'b00) ? b << shift_amount : // SLL/SLLV
        (aluc[1:0] == 2'b10) ? b >> shift_amount : // SRL/SRLV
        $signed(b) >>> shift_amount;                // SRA/SRAV

    // Result Selection
    assign r = 
        (aluc == AND) ? a & b :
        (aluc == OR)  ? a | b :
        (aluc == XOR) ? a ^ b :
        (aluc == NOR) ? ~(a | b) :
        (aluc == SLT) ? {31'b0, $signed(a) < $signed(b)} :
        (aluc == SLTU) ? {31'b0, a < b} :
        (aluc == LUI) ? {b[15:0], 16'b0} :
        (aluc[5:4] == 2'b10) ? arith_result[31:0] : // ADD/ADDU/SUB/SUBU
        (aluc[5:3] == 3'b000) ? shift_result :      // All shift operations
        32'b0;

    // Flag Generation
    assign zero = (r == 32'b0);
    assign carry = (aluc[5:4] == 2'b10) ? arith_result[32] : 1'b0;
    assign negative = r[31];
    assign overflow = ((aluc == ADD) || (aluc == SUB)) ? arith_ovf : 1'b0;
    assign flag = (aluc == SLT) ? ($signed(a) < $signed(b)) :
                 (aluc == SLTU) ? (a < b) : 1'b0;

endmodule