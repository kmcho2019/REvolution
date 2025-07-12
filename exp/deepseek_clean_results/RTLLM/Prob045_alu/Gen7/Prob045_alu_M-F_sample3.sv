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
    wire is_addsub = (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU);
    wire is_logic = (aluc == AND || aluc == OR || aluc == XOR || aluc == NOR);
    wire is_shift = (aluc[5:3] == 3'b000 && aluc != 6'b000001); // exclude unused opcode
    wire is_comp = (aluc == SLT || aluc == SLTU);
    wire is_lui = (aluc == LUI);

    // Arithmetic Unit (optimized separate paths)
    wire arith_sub = (aluc == SUB || aluc == SUBU);
    wire [32:0] arith_add = {1'b0,a} + {1'b0,b};
    wire [32:0] arith_subt = {1'b0,a} - {1'b0,b};
    wire [32:0] arith_result = arith_sub ? arith_subt : arith_add;
    
    // Overflow detection (only for signed operations)
    wire add_ovf = ~a[31] & ~b[31] & arith_add[31];
    wire sub_ovf = ~a[31] & b[31] & arith_subt[31];
    assign overflow = (aluc == ADD) ? add_ovf | (a[31] & b[31] & ~arith_add[31]) :
                     (aluc == SUB) ? sub_ovf | (a[31] & ~b[31] & ~arith_subt[31]) : 1'b0;

    // Logical Unit
    wire [31:0] logic_result = 
        (aluc == AND) ? a & b :
        (aluc == OR)  ? a | b :
        (aluc == XOR) ? a ^ b :
        (aluc == NOR) ? ~(a | b) : 32'b0;

    // Barrel Shifter Unit (logarithmic)
    wire [4:0] shift_amt = (aluc[2:0] == 3'b100) ? a[4:0] : b[4:0]; // SLLV/SRLV/SRAV use a[4:0]
    wire shift_left = (aluc == SLL || aluc == SLLV);
    wire shift_right = (aluc == SRL || aluc == SRLV);
    wire shift_arith = (aluc == SRA || aluc == SRAV);
    
    wire [31:0] shift_in = shift_left ? b : {32{shift_arith & b[31]}};
    wire [31:0] shift_stage1 = shift_amt[4] ? {shift_in[15:0], 16'b0} : shift_in;
    wire [31:0] shift_stage2 = shift_amt[3] ? {shift_stage1[23:0], 8'b0} : shift_stage1;
    wire [31:0] shift_stage3 = shift_amt[2] ? {shift_stage2[27:0], 4'b0} : shift_stage2;
    wire [31:0] shift_stage4 = shift_amt[1] ? {shift_stage3[29:0], 2'b0} : shift_stage3;
    wire [31:0] shift_result = shift_amt[0] ? {shift_stage4[30:0], 1'b0} : shift_stage4;
    wire [31:0] shifted_val = shift_right ? {shift_result[0], shift_result[31:1]} : shift_result;

    // Comparison Unit (shared)
    wire signed [31:0] a_signed = a;
    wire signed [31:0] b_signed = b;
    wire comp_result = (aluc == SLT) ? (a_signed < b_signed) : (a < b);

    // Result selection
    assign r = is_addsub ? arith_result[31:0] :
               is_logic  ? logic_result :
               is_shift  ? shifted_val :
               is_comp   ? {31'b0, comp_result} :
               is_lui    ? {b[15:0], 16'b0} :
               32'b0;

    // Flag generation
    assign zero = (r == 32'b0);
    assign carry = is_addsub ? arith_result[32] : 1'b0;
    assign negative = r[31];
    assign flag = is_comp ? comp_result : 1'b0;

endmodule