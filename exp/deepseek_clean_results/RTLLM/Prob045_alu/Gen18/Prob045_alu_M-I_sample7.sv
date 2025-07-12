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

    // Operation type detection
    wire is_arith = (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU);
    wire is_logic = (aluc == AND || aluc == OR || aluc == XOR || aluc == NOR);
    wire is_shift = (aluc == SLL || aluc == SRL || aluc == SRA || 
                    aluc == SLLV || aluc == SRLV || aluc == SRAV);
    wire is_comp = (aluc == SLT || aluc == SLTU);
    wire is_lui = (aluc == LUI);

    // Shared Arithmetic Unit
    wire do_sub = (aluc == SUB || aluc == SUBU);
    wire [32:0] arith_b = {do_sub ? ~b : b, do_sub};
    wire [32:0] arith_result = {1'b0, a} + arith_b;
    wire arith_ovf = (a[31] == (do_sub ? ~b[31] : b[31])) && 
                    (arith_result[31] != a[31]);

    // Unified Barrel Shifter
    wire [4:0] shift_amount = (aluc == SLLV || aluc == SRLV || aluc == SRAV) ? 
                             a[4:0] : b[4:0];
    wire [31:0] shift_in = (aluc == SLL || aluc == SLLV) ? b : 
                          (aluc == SRA || aluc == SRAV) ? $signed(b) : b;
    wire [31:0] shift_result = 
        (aluc == SLL || aluc == SLLV) ? (shift_in << shift_amount) :
        (aluc == SRL || aluc == SRLV) ? (shift_in >> shift_amount) :
        (shift_in >>> shift_amount);

    // Comparison Logic (shares subtractor result)
    wire slt_result = $signed(a) < $signed(b);
    wire sltu_result = arith_result[32]; // Reuse subtractor carry-out

    // Result Selection
    assign r = 
        is_arith ? arith_result[31:0] :
        is_logic ? 
            (aluc == AND) ? (a & b) :
            (aluc == OR)  ? (a | b) :
            (aluc == XOR) ? (a ^ b) :
            ~(a | b) : // NOR
        is_comp ? 
            (aluc == SLT) ? {31'b0, slt_result} :
            {31'b0, sltu_result} :
        is_shift ? shift_result :
        is_lui ? {b[15:0], 16'b0} :
        32'b0;

    // Flag Generation (only computed when needed)
    assign zero = (r == 32'b0);
    assign carry = is_arith ? arith_result[32] : 1'b0;
    assign negative = r[31];
    assign overflow = is_arith && (aluc == ADD || aluc == SUB) ? arith_ovf : 1'b0;
    assign flag = is_comp ? 
                 (aluc == SLT) ? slt_result : sltu_result : 
                 1'b0;

endmodule