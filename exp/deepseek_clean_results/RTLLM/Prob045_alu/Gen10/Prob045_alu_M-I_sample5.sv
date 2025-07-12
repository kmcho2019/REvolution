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

    // Operation group enables
    wire arith_en = (aluc == ADD) || (aluc == ADDU) || (aluc == SUB) || (aluc == SUBU);
    wire logic_en = (aluc == AND) || (aluc == OR) || (aluc == XOR) || (aluc == NOR);
    wire shift_en = (aluc == SLL) || (aluc == SRL) || (aluc == SRA) || 
                   (aluc == SLLV) || (aluc == SRLV) || (aluc == SRAV);
    wire comp_en = (aluc == SLT) || (aluc == SLTU);
    wire lui_en = (aluc == LUI);

    // Shared arithmetic unit
    wire [32:0] arith_result;
    wire is_sub = (aluc == SUB) || (aluc == SUBU);
    wire use_signed = (aluc == ADD) || (aluc == SUB) || (aluc == SLT);
    wire [31:0] arith_b = is_sub ? ~b : b;
    assign arith_result = {1'b0, a} + {1'b0, arith_b} + {32'b0, is_sub};
    
    // Shared logic unit
    wire [31:0] logic_result;
    assign logic_result = 
        (aluc == AND) ? (a & b) :
        (aluc == OR)  ? (a | b) :
        (aluc == XOR) ? (a ^ b) :
        (aluc == NOR) ? ~(a | b) : 32'b0;

    // Unified shift unit
    wire [31:0] shift_result;
    wire [4:0] shift_amount = 
        (aluc[3] /* V-type */) ? a[4:0] : b[4:0]; // SLLV/SRLV/SRAV use a[4:0]
    wire left_shift = (aluc == SLL) || (aluc == SLLV);
    wire arithmetic_shift = (aluc == SRA) || (aluc == SRAV);
    wire [31:0] shift_input = left_shift ? b : 
                            arithmetic_shift ? $signed(b) : b;
    assign shift_result = left_shift ? (shift_input << shift_amount) :
                        arithmetic_shift ? (shift_input >>> shift_amount) :
                        (shift_input >> shift_amount);

    // Comparison results
    wire comp_result = 
        (aluc == SLT) ? ($signed(a) < $signed(b)) : 
        (aluc == SLTU) ? (a < b) : 1'b0;

    // LUI result
    wire [31:0] lui_result = {b[15:0], 16'b0};

    // Stage 1: Operation results
    wire [31:0] stage1_result = 
        (arith_en) ? arith_result[31:0] :
        (logic_en) ? logic_result :
        (shift_en) ? shift_result :
        (comp_en) ? {31'b0, comp_result} :
        (lui_en) ? lui_result : 32'b0;

    // Flag calculation
    wire arith_overflow = use_signed && 
                         (a[31] == arith_b[31]) && 
                         (stage1_result[31] != a[31]);
    
    // Hierarchical zero detection
    wire [7:0] byte_or = |stage1_result;
    assign zero = ~(|byte_or);
    
    assign carry = arith_en && arith_result[32];
    assign negative = stage1_result[31];
    assign overflow = arith_en && arith_overflow;
    assign flag = comp_en && comp_result;

    // Final output
    assign r = stage1_result;

endmodule