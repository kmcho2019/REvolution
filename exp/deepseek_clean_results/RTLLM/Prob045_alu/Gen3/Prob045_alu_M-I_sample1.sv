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

    // Operation type detection with clock gating enables
    wire is_add = (aluc == ADD) | (aluc == ADDU);
    wire is_sub = (aluc == SUB) | (aluc == SUBU);
    wire is_arith = is_add | is_sub;
    wire is_logic = (aluc == AND) | (aluc == OR) | (aluc == XOR) | (aluc == NOR);
    wire is_shift = (aluc == SLL) | (aluc == SRL) | (aluc == SRA) | 
                    (aluc == SLLV) | (aluc == SRLV) | (aluc == SRAV);
    wire is_comp = (aluc == SLT) | (aluc == SLTU);
    wire is_lui = (aluc == LUI);

    // Enhanced Arithmetic Unit with Carry-Select
    wire [31:0] arith_res;
    wire arith_carry, arith_ovf;
    wire signed [31:0] signed_a = a;
    wire signed [31:0] signed_b = b;
    
    // Carry-select adder implementation
    wire [15:0] sum_low, sum_high0, sum_high1;
    wire carry_low = is_add ? (a[15] & b[15]) : (a[15] & ~b[15]);
    
    assign {carry_low, sum_low} = is_add ? (a[15:0] + b[15:0]) : (a[15:0] - b[15:0]);
    assign sum_high0 = is_add ? (a[31:16] + b[31:16]) : (a[31:16] - b[31:16]);
    assign sum_high1 = is_add ? (a[31:16] + b[31:16] + 1) : (a[31:16] - b[31:16] - 1);
    
    assign arith_res = {carry_low ? sum_high1 : sum_high0, sum_low};
    assign arith_carry = is_add ? (carry_low ? (sum_high1[15] & (a[31:16][15] | b[31:16][15])) : 
                                  (sum_high0[15] & (a[31:16][15] | b[31:16][15]))) :
                        (carry_low ? (sum_high1[15] & ~(a[31:16][15] & ~b[31:16][15])) : 
                                  (sum_high0[15] & ~(a[31:16][15] & ~b[31:16][15])));
    
    // Combined overflow detection
    assign arith_ovf = is_arith & ((aluc == ADD) | (aluc == SUB)) ? 
                       (a[31] == b[31]) & (arith_res[31] != a[31]) : 1'b0;

    // Optimized Logic Unit with operand isolation
    wire [31:0] logic_res;
    wire and_res = a & b;
    wire or_res = a | b;
    
    assign logic_res = 
        (aluc == AND) ? and_res :
        (aluc == OR)  ? or_res :
        (aluc == XOR) ? (and_res | or_res) & ~(and_res & or_res) : // XOR from AND/OR
        (aluc == NOR) ? ~or_res : 32'b0;

    // Logarithmic Barrel Shifter with pre-decoding
    wire [4:0] shift_amt = (aluc[3]) ? a[4:0] : b[4:0];
    wire [31:0] shift_res;
    
    // 5:1 mux structure for logarithmic shifting
    wire [31:0] shift16 = (shift_amt[4]) ? 
                         ((aluc[1]) ? {{16{b[31]}}, b[31:16]} : {16'b0, b[31:16]}) : b;
    wire [31:0] shift8 = (shift_amt[3]) ? 
                        ((aluc[1]) ? {{8{shift16[31]}}, shift16[31:8]} : {8'b0, shift16[31:8]}) : shift16;
    wire [31:0] shift4 = (shift_amt[2]) ? 
                        ((aluc[1]) ? {{4{shift8[31]}}, shift8[31:4]} : {4'b0, shift8[31:4]}) : shift8;
    wire [31:0] shift2 = (shift_amt[1]) ? 
                        ((aluc[1]) ? {{2{shift4[31]}}, shift4[31:2]} : {2'b0, shift4[31:2]}) : shift4;
    wire [31:0] shift1 = (shift_amt[0]) ? 
                        ((aluc[1]) ? {shift2[31], shift2[31:1]} : {1'b0, shift2[31:1]}) : shift2;
    
    assign shift_res = (aluc[0]) ? (b << shift_amt) : // SLL/SLLV
                      shift1; // SRL/SRLV/SRA/SRAV

    // Shared Comparison Logic with early termination
    wire comp_res = (aluc == SLT) ? 
                   (signed_a[31] != signed_b[31]) ? signed_a[31] : (signed_a < signed_b) :
                   (a < b);

    // Result selection with low-power mux
    assign r = is_arith ? arith_res :
               is_logic ? logic_res :
               is_shift ? shift_res :
               is_comp ? {31'b0, comp_res} :
               is_lui ? {b[15:0], 16'b0} : 32'b0;

    // Enhanced Flag Generation
    // Parallel prefix OR tree for zero flag
    wire [7:0] or_tree0 = |r[31:24];
    wire [7:0] or_tree1 = |r[23:16];
    wire [7:0] or_tree2 = |r[15:8];
    wire [7:0] or_tree3 = |r[7:0];
    wire [3:0] or_tree4 = |{or_tree0, or_tree1, or_tree2, or_tree3};
    assign zero = ~or_tree4[0];
    
    assign negative = r[31];
    assign carry = is_arith ? arith_carry : 1'b0;
    assign overflow = is_arith & ((aluc == ADD) | (aluc == SUB)) ? arith_ovf : 1'b0;
    assign flag = is_comp ? comp_res : 1'b0;

    // Clock gating for sequential elements (if any)
    // Would be implemented with actual clock gating cells in synthesis
    wire clk_gate = is_arith | is_logic | is_shift | is_comp | is_lui;

endmodule