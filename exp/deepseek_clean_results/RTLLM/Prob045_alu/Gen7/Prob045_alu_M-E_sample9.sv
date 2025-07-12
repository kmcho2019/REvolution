module alu(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output reg [31:0] r,
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

    // Internal signals
    wire [31:0] arith_res, logic_res, shift_res;
    wire arith_carry, arith_overflow;
    wire comp_res;
    wire [4:0] shift_amt;

    // Arithmetic Unit
    assign {arith_carry, arith_res} = 
        (aluc == ADD || aluc == ADDU) ? (a + b) :
        (aluc == SUB || aluc == SUBU) ? (a - b) : {1'b0, 32'b0};
    
    // Overflow detection
    assign arith_overflow = 
        (aluc == ADD && (a[31] == b[31]) && (arith_res[31] != a[31])) ||
        (aluc == SUB && (a[31] != b[31]) && (arith_res[31] != a[31]));

    // Logic Unit
    assign logic_res = 
        (aluc == AND) ? (a & b) :
        (aluc == OR)  ? (a | b) :
        (aluc == XOR) ? (a ^ b) :
        (aluc == NOR) ? ~(a | b) : 32'b0;

    // Comparison Unit
    assign comp_res = 
        (aluc == SLT)  ? ($signed(a) < $signed(b)) :
        (aluc == SLTU) ? (a < b) : 1'b0;

    // Shift Unit (logarithmic shifter)
    assign shift_amt = 
        (aluc == SLLV || aluc == SRLV || aluc == SRAV) ? a[4:0] : b[4:0];
    
    // Logarithmic shifter implementation
    wire [31:0] shift_stage1, shift_stage2, shift_stage3, shift_stage4, shift_stage5;
    
    assign shift_stage1 = (shift_amt[0]) ? 
        ((aluc == SLL || aluc == SLLV) ? {b[30:0], 1'b0} :
        ((aluc == SRL || aluc == SRLV) ? {1'b0, b[31:1]} : 
        {b[31], b[31:1]}) : b;
    
    assign shift_stage2 = (shift_amt[1]) ? 
        ((aluc == SLL || aluc == SLLV) ? {shift_stage1[29:0], 2'b0} :
        ((aluc == SRL || aluc == SRLV) ? {2'b0, shift_stage1[31:2]} : 
        {{2{shift_stage1[31]}}, shift_stage1[31:2]}) : shift_stage1;
    
    assign shift_stage3 = (shift_amt[2]) ? 
        ((aluc == SLL || aluc == SLLV) ? {shift_stage2[27:0], 4'b0} :
        ((aluc == SRL || aluc == SRLV) ? {4'b0, shift_stage2[31:4]} : 
        {{4{shift_stage2[31]}}, shift_stage2[31:4]}) : shift_stage2;
    
    assign shift_stage4 = (shift_amt[3]) ? 
        ((aluc == SLL || aluc == SLLV) ? {shift_stage3[23:0], 8'b0} :
        ((aluc == SRL || aluc == SRLV) ? {8'b0, shift_stage3[31:8]} : 
        {{8{shift_stage3[31]}}, shift_stage3[31:8]}) : shift_stage3;
    
    assign shift_stage5 = (shift_amt[4]) ? 
        ((aluc == SLL || aluc == SLLV) ? {shift_stage4[15:0], 16'b0} :
        ((aluc == SRL || aluc == SRLV) ? {16'b0, shift_stage4[31:16]} : 
        {{16{shift_stage4[31]}}, shift_stage4[31:16]}) : shift_stage4;
    
    assign shift_res = shift_stage5;

    // Result selection
    always @(*) begin
        case (1'b1)  // Priority encoder
            (aluc == LUI): r = {b[15:0], 16'b0};
            (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU): r = arith_res;
            (aluc == AND || aluc == OR || aluc == XOR || aluc == NOR): r = logic_res;
            (aluc == SLT || aluc == SLTU): r = {31'b0, comp_res};
            (aluc == SLL || aluc == SRL || aluc == SRA || 
             aluc == SLLV || aluc == SRLV || aluc == SRAV): r = shift_res;
            default: r = 32'b0;
        endcase
    end

    // Flag generation
    assign zero = (r == 32'b0);
    assign carry = arith_carry & (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU);
    assign negative = r[31];
    assign overflow = arith_overflow & (aluc == ADD || aluc == SUB);
    assign flag = comp_res & (aluc == SLT || aluc == SLTU);

endmodule