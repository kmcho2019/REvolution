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
    wire [32:0] add_result = a + b;
    wire [32:0] sub_result = a - b;
    wire arith_ovf_add = (a[31] == b[31]) && (add_result[31] != a[31]);
    wire arith_ovf_sub = (a[31] != b[31]) && (sub_result[31] != a[31]);

    // Shift Unit
    wire [4:0] shift_amount = (aluc == SLLV || aluc == SRLV || aluc == SRAV) ? a[4:0] : b[4:0];
    wire [31:0] sll_result = b << shift_amount;
    wire [31:0] srl_result = b >> shift_amount;
    wire [31:0] sra_result = $signed(b) >>> shift_amount;

    // Comparison Unit
    wire slt_result = $signed(a) < $signed(b);
    wire sltu_result = a < b;

    // Main Result Multiplexer
    assign r = 
        (aluc == ADD || aluc == ADDU) ? add_result[31:0] :
        (aluc == SUB || aluc == SUBU) ? sub_result[31:0] :
        (aluc == AND) ? (a & b) :
        (aluc == OR)  ? (a | b) :
        (aluc == XOR) ? (a ^ b) :
        (aluc == NOR) ? ~(a | b) :
        (aluc == SLT) ? {31'b0, slt_result} :
        (aluc == SLTU) ? {31'b0, sltu_result} :
        (aluc == SLL || aluc == SLLV) ? sll_result :
        (aluc == SRL || aluc == SRLV) ? srl_result :
        (aluc == SRA || aluc == SRAV) ? sra_result :
        (aluc == LUI) ? {b[15:0], 16'b0} :
        32'b0;

    // Flag Generation
    assign zero = (r == 32'b0);
    assign carry = 
        (aluc == ADD || aluc == ADDU) ? add_result[32] :
        (aluc == SUB || aluc == SUBU) ? sub_result[32] :
        1'b0;
    assign negative = r[31];
    assign overflow = 
        (aluc == ADD) ? arith_ovf_add :
        (aluc == SUB) ? arith_ovf_sub :
        1'b0;
    assign flag = 
        (aluc == SLT) ? slt_result :
        (aluc == SLTU) ? sltu_result :
        1'b0;

endmodule