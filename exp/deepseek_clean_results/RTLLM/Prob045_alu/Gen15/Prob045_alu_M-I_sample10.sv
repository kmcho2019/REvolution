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

    // Operation codes (unchanged)
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
    wire is_arith = (aluc == ADD) | (aluc == ADDU) | (aluc == SUB) | (aluc == SUBU);
    wire is_logic = (aluc == AND) | (aluc == OR) | (aluc == XOR) | (aluc == NOR);
    wire is_shift = (aluc == SLL) | (aluc == SRL) | (aluc == SRA) | 
                   (aluc == SLLV) | (aluc == SRLV) | (aluc == SRAV);
    wire is_comp = (aluc == SLT) | (aluc == SLTU);
    wire is_lui = (aluc == LUI);

    // Optimized arithmetic operations (carry-select adder)
    wire [31:0] b_arith = (aluc == SUB || aluc == SUBU) ? ~b : b;
    wire [32:0] arith_core = {1'b0, a} + {1'b0, b_arith} + ((aluc == SUB || aluc == SUBU) ? 33'b1 : 33'b0);
    wire [31:0] arith_result = arith_core[31:0];
    wire arith_carry = arith_core[32];

    // Overflow detection optimization
    wire add_ovf = ~a[31] & ~b_arith[31] & arith_result[31];
    wire sub_ovf = (aluc == SUB) & ((~a[31] & b[31] & arith_result[31]) | (a[31] & ~b[31] & ~arith_result[31]));
    wire arith_ovf = (aluc == ADD) ? (a[31] & b[31] & ~arith_result[31]) | add_ovf :
                    (aluc == SUB) ? sub_ovf : 1'b0;

    // Optimized barrel shifter
    wire [4:0] shift_amt = (aluc[3]) ? a[4:0] : b[4:0];  // SLLV/SRLV/SRAV use a[4:0]
    wire shift_left = (aluc == SLL || aluc == SLLV);
    wire shift_arith = (aluc == SRA || aluc == SRAV);
    
    wire [31:0] shift_in = shift_left ? {b[15:0], 16'b0} : b;
    wire [31:0] shift_stage1 = shift_amt[0] ? (shift_left ? {shift_in[30:0], 1'b0} : 
                              {shift_arith & shift_in[31], shift_in[31:1]} : shift_in;
    wire [31:0] shift_stage2 = shift_amt[1] ? (shift_left ? {shift_stage1[29:0], 2'b0} : 
                              { {2{shift_arith & shift_stage1[31]}}, shift_stage1[31:2]} ) : shift_stage1;
    wire [31:0] shift_stage4 = shift_amt[2] ? (shift_left ? {shift_stage2[27:0], 4'b0} : 
                              { {4{shift_arith & shift_stage2[31]}}, shift_stage2[31:4]} ) : shift_stage2;
    wire [31:0] shift_stage8 = shift_amt[3] ? (shift_left ? {shift_stage4[23:0], 8'b0} : 
                              { {8{shift_arith & shift_stage4[31]}}, shift_stage4[31:8]} ) : shift_stage4;
    wire [31:0] shift_result = shift_amt[4] ? (shift_left ? {shift_stage8[15:0], 16'b0} : 
                              { {16{shift_arith & shift_stage8[31]}}, shift_stage8[31:16]} ) : shift_stage8;

    // Optimized logic operations
    wire [31:0] logic_result = 
        (aluc == AND) ? (a & b) :
        (aluc == OR)  ? (a | b) :
        (aluc == XOR) ? (a ^ b) :
        (aluc == NOR) ? ~(a | b) : 32'b0;

    // Shared comparison logic
    wire comp_result = 
        (aluc == SLT)  ? ($signed(a) < $signed(b)) :
        (aluc == SLTU) ? (a < b) : 1'b0;

    // Hierarchical result selection
    wire [31:0] r_arith = arith_result;
    wire [31:0] r_logic = logic_result;
    wire [31:0] r_shift = shift_result;
    wire [31:0] r_comp = {31'b0, comp_result};
    wire [31:0] r_lui = {b[15:0], 16'b0};
    
    assign r = is_arith ? r_arith :
              is_logic ? r_logic :
              is_shift ? r_shift :
              is_comp ? r_comp :
              is_lui ? r_lui :
              32'b0;

    // Optimized flag generation
    assign zero = ~(|r);
    assign negative = is_arith | is_comp ? r[31] : 1'b0;
    assign carry = is_arith ? arith_carry : 1'b0;
    assign overflow = is_arith ? arith_ovf : 1'b0;
    assign flag = is_comp ? comp_result : 1'b0;

endmodule