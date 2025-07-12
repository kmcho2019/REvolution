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

    // Operation classification
    wire is_add = (aluc == ADD || aluc == ADDU);
    wire is_sub = (aluc == SUB || aluc == SUBU);
    wire is_logic = (aluc == AND || aluc == OR || aluc == XOR || aluc == NOR);
    wire is_shift = (aluc == SLL || aluc == SRL || aluc == SRA || 
                    aluc == SLLV || aluc == SRLV || aluc == SRAV);
    wire is_comp = (aluc == SLT || aluc == SLTU);
    wire is_lui = (aluc == LUI);

    // Arithmetic Unit
    wire [32:0] arith_full;
    wire use_signed = (aluc == ADD || aluc == SUB);
    
    assign arith_full = is_add ? 
                       (use_signed ? $signed(a) + $signed(b) : {1'b0, a} + {1'b0, b} :
                       is_sub ? 
                       (use_signed ? $signed(a) - $signed(b) : {1'b0, a} - {1'b0, b}) : 
                       33'b0;
    
    wire [31:0] arith_result = arith_full[31:0];
    wire arith_carry = arith_full[32];
    wire arith_overflow = use_signed & 
                         ((is_add & (a[31] == b[31]) & (arith_result[31] != a[31])) |
                         ((is_sub & (a[31] != b[31]) & (arith_result[31] != a[31])));

    // Logic Unit
    wire [31:0] logic_result = 
        (aluc == AND) ? (a & b) :
        (aluc == OR)  ? (a | b) :
        (aluc == XOR) ? (a ^ b) :
        (aluc == NOR) ? ~(a | b) : 32'b0;

    // Shift Unit
    wire [4:0] shift_amount = 
        (aluc == SLLV || aluc == SRLV || aluc == SRAV) ? a[4:0] : b[4:0];
    
    wire [31:0] shift_left = b << shift_amount;
    wire [31:0] shift_right_logical = b >> shift_amount;
    wire [31:0] shift_right_arithmetic = $signed(b) >>> shift_amount;
    
    wire [31:0] shift_result = 
        (aluc == SLL || aluc == SLLV) ? shift_left :
        (aluc == SRL || aluc == SRLV) ? shift_right_logical :
        (aluc == SRA || aluc == SRAV) ? shift_right_arithmetic : 32'b0;

    // Comparison Unit (executes in parallel)
    wire comp_unsigned = (aluc == SLTU);
    wire [32:0] comp_diff = {1'b0, a} - {1'b0, b};
    wire comp_result = comp_unsigned ? comp_diff[32] : 
                      (a[31] != b[31]) ? a[31] : comp_diff[31];

    // Special Operations
    wire [31:0] lui_result = {b[15:0], 16'b0};

    // Result Selection
    wire [31:0] result = 
        (is_add || is_sub) ? arith_result :
        is_logic ? logic_result :
        is_shift ? shift_result :
        is_comp ? {31'b0, comp_result} :
        is_lui ? lui_result : 32'b0;

    // Flag Generation
    wire early_zero = ~|result;  // NOR reduction for zero detection
    
    assign r = result;
    assign zero = early_zero;
    assign carry = (is_add || is_sub) ? arith_carry : 1'b0;
    assign negative = result[31];
    assign overflow = (is_add || is_sub) ? arith_overflow : 1'b0;
    assign flag = is_comp ? comp_result : 1'b0;

endmodule