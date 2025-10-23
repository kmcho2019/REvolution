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

    // Parallel Arithmetic Units
    wire [32:0] signed_arith = 
        (aluc == ADD) ? ($signed(a) + $signed(b)) :
        (aluc == SUB) ? ($signed(a) - $signed(b)) : 33'b0;
    
    wire [32:0] unsigned_arith = 
        (aluc == ADDU) ? ({1'b0, a} + {1'b0, b}) :
        (aluc == SUBU) ? ({1'b0, a} - {1'b0, b}) : 33'b0;
    
    wire [31:0] arith_result = 
        (aluc == ADD || aluc == SUB) ? signed_arith[31:0] :
        (aluc == ADDU || aluc == SUBU) ? unsigned_arith[31:0] : 32'b0;

    // Parallel Logic Unit
    wire [31:0] logic_result = 
        (aluc == AND) ? (a & b) :
        (aluc == OR)  ? (a | b) :
        (aluc == XOR) ? (a ^ b) :
        (aluc == NOR) ? ~(a | b) : 32'b0;

    // Logarithmic Barrel Shifter
    wire [4:0] shift_amt = 
        (aluc == SLLV || aluc == SRLV || aluc == SRAV) ? a[4:0] : b[4:0];
    
    wire [31:0] shift_stage1 = 
        (shift_amt[0]) ? ((aluc == SLL || aluc == SLLV) ? {b[30:0], 1'b0} :
                         (aluc == SRA || aluc == SRAV) ? {b[31], b[31:1]} :
                         {1'b0, b[31:1]}) : b;
    
    wire [31:0] shift_stage2 = 
        (shift_amt[1]) ? ((aluc == SLL || aluc == SLLV) ? {shift_stage1[29:0], 2'b0} :
                         (aluc == SRA || aluc == SRAV) ? {{2{shift_stage1[31]}}, shift_stage1[31:2]} :
                         {2'b0, shift_stage1[31:2]}) : shift_stage1;
    
    wire [31:0] shift_stage4 = 
        (shift_amt[2]) ? ((aluc == SLL || aluc == SLLV) ? {shift_stage2[27:0], 4'b0} :
                         (aluc == SRA || aluc == SRAV) ? {{4{shift_stage2[31]}}, shift_stage2[31:4]} :
                         {4'b0, shift_stage2[31:4]}) : shift_stage2;
    
    wire [31:0] shift_stage8 = 
        (shift_amt[3]) ? ((aluc == SLL || aluc == SLLV) ? {shift_stage4[23:0], 8'b0} :
                         (aluc == SRA || aluc == SRAV) ? {{8{shift_stage4[31]}}, shift_stage4[31:8]} :
                         {8'b0, shift_stage4[31:8]}) : shift_stage4;
    
    wire [31:0] shift_result = 
        (shift_amt[4]) ? ((aluc == SLL || aluc == SLLV) ? {shift_stage8[15:0], 16'b0} :
                         (aluc == SRA || aluc == SRAV) ? {{16{shift_stage8[31]}}, shift_stage8[31:16]} :
                         {16'b0, shift_stage8[31:16]}) : shift_stage8;

    // Comparison Unit
    wire [31:0] comp_result = 
        (aluc == SLT) ? {31'b0, ($signed(a) < $signed(b))} :
        (aluc == SLTU) ? {31'b0, (a < b)} : 32'b0;

    // LUI Unit
    wire [31:0] lui_result = {b[15:0], 16'b0};

    // Priority-based Result Selection
    wire [31:0] result = 
        is_arith ? arith_result :
        is_logic ? logic_result :
        is_shift ? shift_result :
        is_comp ? comp_result :
        is_lui ? lui_result : 32'b0;

    // Early Flag Prediction
    wire signed_overflow = 
        (aluc == ADD) ? (a[31] == b[31]) && (result[31] != a[31]) :
        (aluc == SUB) ? (a[31] != b[31]) && (result[31] != a[31]) : 1'b0;
    
    wire arith_carry = 
        (aluc == ADD || aluc == ADDU) ? unsigned_arith[32] :
        (aluc == SUB || aluc == SUBU) ? unsigned_arith[32] : 1'b0;
    
    wire comp_flag = 
        (aluc == SLT) ? ($signed(a) < $signed(b)) :
        (aluc == SLTU) ? (a < b) : 1'b0;

    // Output Assignment
    assign r = result;
    assign zero = (result == 32'b0);
    assign carry = is_arith ? arith_carry : 1'b0;
    assign negative = result[31];
    assign overflow = (aluc == ADD || aluc == SUB) ? signed_overflow : 1'b0;
    assign flag = is_comp ? comp_flag : 1'b0;

endmodule