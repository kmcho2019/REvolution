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

    // Operation group detection
    wire is_arith = (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU);
    wire is_logic = (aluc == AND || aluc == OR || aluc == XOR || aluc == NOR);
    wire is_shift = (aluc[5:3] == 3'b000);
    wire is_comp  = (aluc == SLT || aluc == SLTU);
    wire is_lui   = (aluc == LUI);

    // Arithmetic Unit
    wire arith_sub = (aluc == SUB || aluc == SUBU);
    wire [32:0] arith_result = arith_sub ? {1'b0,a} - {1'b0,b} : {1'b0,a} + {1'b0,b};
    wire arith_ovf = (aluc == ADD) ? (~a[31] & ~b[31] & arith_result[31]) | 
                                    (a[31] & b[31] & ~arith_result[31]) :
                    (aluc == SUB) ? (~a[31] & b[31] & arith_result[31]) | 
                                    (a[31] & ~b[31] & ~arith_result[31]) : 1'b0;

    // Logical Unit
    wire [31:0] logic_result = 
        (aluc == AND) ? a & b :
        (aluc == OR)  ? a | b :
        (aluc == XOR) ? a ^ b :
        (aluc == NOR) ? ~(a | b) : 32'b0;

    // Hybrid Shifter Unit
    wire [4:0] shift_amt = (aluc[2:0] == 3'b100) ? a[4:0] : b[4:0];
    wire [31:0] shift_result;
    
    // Logarithmic shifter for large shifts, linear for small
    assign shift_result = 
        (shift_amt[4]) ? 
            (aluc[1:0] == 2'b00) ? {b[15:0], 16'b0} : // SLL 16
            (aluc[1:0] == 2'b10) ? {16'b0, b[31:16]} : // SRL 16
            {{16{b[31]}}, b[31:16]} :                  // SRA 16
        (shift_amt[3]) ? 
            (aluc[1:0] == 2'b00) ? {b[23:0], 8'b0} :   // SLL 8
            (aluc[1:0] == 2'b10) ? {8'b0, b[31:8]} :   // SRL 8
            {{8{b[31]}}, b[31:8]} :                   // SRA 8
        (shift_amt[2]) ? 
            (aluc[1:0] == 2'b00) ? {b[27:0], 4'b0} :   // SLL 4
            (aluc[1:0] == 2'b10) ? {4'b0, b[31:4]} :   // SRL 4
            {{4{b[31]}}, b[31:4]} :                   // SRA 4
        (shift_amt[1]) ? 
            (aluc[1:0] == 2'b00) ? {b[29:0], 2'b0} :   // SLL 2
            (aluc[1:0] == 2'b10) ? {2'b0, b[31:2]} :   // SRL 2
            {{2{b[31]}}, b[31:2]} :                  // SRA 2
        (shift_amt[0]) ? 
            (aluc[1:0] == 2'b00) ? {b[30:0], 1'b0} :   // SLL 1
            (aluc[1:0] == 2'b10) ? {1'b0, b[31:1]} :   // SRL 1
            {{1{b[31]}}, b[31:1]} :                   // SRA 1
        b;                                            // No shift

    // Smart Comparator Unit
    wire signed [31:0] a_signed = a;
    wire signed [31:0] b_signed = b;
    wire comp_result = (aluc == SLT) ? (a_signed < b_signed) : (a < b);

    // Result selection with priority encoding
    assign r = 
        is_arith ? arith_result[31:0] :
        is_logic ? logic_result :
        is_shift ? shift_result :
        is_comp  ? {31'b0, comp_result} :
        is_lui   ? {b[15:0], 16'b0} :
        32'b0;

    // Predictive Flag Generation
    // Zero flag using parallel OR tree
    wire [15:0] or_l1 = {|r[31:24], |r[23:16], |r[15:8], |r[7:0]};
    wire [3:0] or_l2 = {|or_l1[15:12], |or_l1[11:8], |or_l1[7:4], |or_l1[3:0]};
    assign zero = ~(|or_l2);

    assign carry = is_arith ? arith_result[32] : 1'b0;
    assign negative = r[31];
    assign overflow = is_arith ? arith_ovf : 1'b0;
    assign flag = is_comp ? comp_result : 1'b0;

endmodule