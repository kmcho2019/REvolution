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

    // Operation type detection with enables
    wire is_add = (aluc == ADD) | (aluc == ADDU);
    wire is_sub = (aluc == SUB) | (aluc == SUBU);
    wire is_arith = is_add | is_sub;
    wire is_logic = (aluc == AND) | (aluc == OR) | (aluc == XOR) | (aluc == NOR);
    wire is_shift = (aluc == SLL) | (aluc == SRL) | (aluc == SRA) | 
                    (aluc == SLLV) | (aluc == SRLV) | (aluc == SRAV);
    wire is_comp = (aluc == SLT) | (aluc == SLTU);
    wire is_lui = (aluc == LUI);

    // Shared Arithmetic Unit
    wire [32:0] arith_res;
    wire arith_carry, arith_ovf;
    wire signed [31:0] signed_a = a;
    wire signed [31:0] signed_b = b;
    
    assign arith_res = is_add ? {1'b0, a} + {1'b0, b} : 
                      is_sub ? {1'b0, a} - {1'b0, b} : 33'b0;
    
    assign arith_carry = arith_res[32];
    assign arith_ovf = is_add ? (~a[31] & ~b[31] & arith_res[31]) | (a[31] & b[31] & ~arith_res[31]) :
                       is_sub ? (~a[31] & b[31] & arith_res[31]) | (a[31] & ~b[31] & ~arith_res[31]) : 1'b0;

    // Optimized Logic Unit
    wire [31:0] logic_res;
    assign logic_res = 
        (aluc == AND) ? (a & b) :
        (aluc == OR)  ? (a | b) :
        (aluc == XOR) ? (a ^ b) :
        (aluc == NOR) ? ~(a | b) : 32'b0;

    // Hierarchical Barrel Shifter
    wire [4:0] shift_amt = (aluc[3]) ? a[4:0] : b[4:0]; // SxLV ops use a[4:0]
    wire [31:0] shift_res;
    
    // 5-stage hierarchical shifter
    wire [31:0] stage0 = (shift_amt[0]) ? ((aluc[1]) ? {b[31], b[31:1]} : {1'b0, b[31:1]}) : b;
    wire [31:0] stage1 = (shift_amt[1]) ? ((aluc[1]) ? {{2{stage0[31]}}, stage0[31:2]} : {2'b0, stage0[31:2]}) : stage0;
    wire [31:0] stage2 = (shift_amt[2]) ? ((aluc[1]) ? {{4{stage1[31]}}, stage1[31:4]} : {4'b0, stage1[31:4]}) : stage1;
    wire [31:0] stage3 = (shift_amt[3]) ? ((aluc[1]) ? {{8{stage2[31]}}, stage2[31:8]} : {8'b0, stage2[31:8]}) : stage2;
    wire [31:0] stage4 = (shift_amt[4]) ? ((aluc[1]) ? {{16{stage3[31]}}, stage3[31:16]} : {16'b0, stage3[31:16]}) : stage3;
    
    assign shift_res = (aluc[0]) ? (b << shift_amt) : // SLL/SLLV
                      (aluc[1:0] == 2'b10) ? stage4 : // SRL/SRLV
                      stage4; // SRA/SRAV (handled by sign extension)

    // Shared Comparison Logic
    wire comp_res = (aluc == SLT) ? (signed_a < signed_b) : (a < b);
    
    // Result selection
    assign r = is_arith ? arith_res[31:0] :
               is_logic ? logic_res :
               is_shift ? shift_res :
               is_comp ? {31'b0, comp_res} :
               is_lui ? {b[15:0], 16'b0} : 32'b0;

    // Optimized Flag Generation
    assign zero = ~|r; // Reduction NOR
    assign negative = r[31];
    assign carry = is_arith ? arith_carry : 1'b0;
    assign overflow = is_arith & ((aluc == ADD) | (aluc == SUB)) ? arith_ovf : 1'b0;
    assign flag = is_comp ? comp_res : 1'b0; // Always driven (no high-Z)

endmodule