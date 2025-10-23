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

    // Operation category detection
    wire is_arith = (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU);
    wire is_logic = (aluc == AND || aluc == OR || aluc == XOR || aluc == NOR);
    wire is_shift = (aluc == SLL || aluc == SRL || aluc == SRA || 
                    aluc == SLLV || aluc == SRLV || aluc == SRAV);
    wire is_comp  = (aluc == SLT || aluc == SLTU);
    wire is_lui   = (aluc == LUI);

    // Parallel Execution Units -------------------------------------------------

    // 1. Arithmetic Unit
    wire [32:0] arith_full_result;
    wire arith_sub = (aluc == SUB || aluc == SUBU);
    wire [31:0] arith_b = arith_sub ? ~b : b;
    wire arith_cin = arith_sub ? 1'b1 : 1'b0;
    
    assign arith_full_result = {1'b0, a} + {1'b0, arith_b} + arith_cin;
    wire [31:0] arith_result = arith_full_result[31:0];
    wire arith_carry = arith_full_result[32];
    
    // Overflow detection (only for signed operations)
    wire arith_overflow = ~aluc[0] & (a[31] == arith_b[31]) & (arith_result[31] != a[31]);

    // 2. Logic Unit
    wire [31:0] logic_result = 
        (aluc == AND) ? (a & b) :
        (aluc == OR)  ? (a | b) :
        (aluc == XOR) ? (a ^ b) :
        (aluc == NOR) ? ~(a | b) : 32'b0;

    // 3. Shift Unit (Revised implementation)
    wire [4:0] shift_amt = (aluc[3] /*V-type*/) ? a[4:0] : b[4:0];
    wire shift_right = (aluc == SRL || aluc == SRLV || aluc == SRA || aluc == SRAV);
    wire shift_arith = (aluc == SRA || aluc == SRAV);
    
    wire [31:0] shift_result;
    assign shift_result = 
        shift_right ? 
            (shift_arith ? ($signed(b) >>> shift_amt) : (b >> shift_amt)) :
            (b << shift_amt);

    // 4. Comparison Unit
    wire signed [31:0] signed_a = a;
    wire signed [31:0] signed_b = b;
    wire comp_result = (aluc == SLT) ? (signed_a < signed_b) : (a < b);

    // 5. LUI Unit
    wire [31:0] lui_result = {b[15:0], 16'b0};

    // Result Selection ---------------------------------------------------------
    wire [31:0] final_result =
        is_arith ? arith_result :
        is_logic ? logic_result :
        is_shift ? shift_result :
        is_comp  ? {31'b0, comp_result} :
        is_lui   ? lui_result :
        32'b0;

    // Flag Generation ----------------------------------------------------------
    assign zero = (final_result == 32'b0);
    assign negative = final_result[31];
    assign carry = is_arith ? arith_carry : 1'b0;
    assign overflow = is_arith & ~aluc[0] ? arith_overflow : 1'b0;
    assign flag = is_comp ? comp_result : 1'b0;
    
    // Final output
    assign r = final_result;

endmodule