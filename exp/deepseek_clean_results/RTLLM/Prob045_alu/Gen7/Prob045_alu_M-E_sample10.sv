module alu(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output reg [31:0] r,
    output zero,
    output carry,
    output negative,
    output overflow,
    output reg flag
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
    wire signed [31:0] a_signed = a;
    wire signed [31:0] b_signed = b;
    wire [4:0] shift_amount = (aluc[2:0] == 3'b100) ? a[4:0] : b[4:0];
    
    // Parallel computation units
    wire [31:0] arith_result, logic_result, shift_result, comp_result;
    wire arith_carry, arith_overflow;
    
    // Arithmetic Unit (Carry-select adder)
    wire [31:0] arith_b = (aluc == SUB || aluc == SUBU) ? ~b : b;
    wire cin = (aluc == SUB || aluc == SUBU);
    
    // 16-bit carry-select adder segments
    wire [15:0] sum_low, sum_high0, sum_high1;
    wire carry_low, carry_high0, carry_high1;
    
    // Lower 16 bits (ripple carry)
    {carry_low, sum_low} = a[15:0] + arith_b[15:0] + cin;
    
    // Upper 16 bits (carry-select)
    {carry_high0, sum_high0} = a[31:16] + arith_b[31:16] + 1'b0;
    {carry_high1, sum_high1} = a[31:16] + arith_b[31:16] + 1'b1;
    
    // Final selection
    assign {arith_carry, arith_result} = carry_low ? 
        {carry_high1, {sum_high1, sum_low}} : 
        {carry_high0, {sum_high0, sum_low}};
    
    // Overflow detection
    assign arith_overflow = (~a[31] & ~arith_b[31] & arith_result[31]) |
                          (a[31] & arith_b[31] & ~arith_result[31]);
    
    // Logic Unit
    assign logic_result = (aluc == AND) ? a & b :
                         (aluc == OR)  ? a | b :
                         (aluc == XOR) ? a ^ b :
                         ~(a | b); // NOR
    
    // Logarithmic Barrel Shifter
    wire [31:0] shift_in = (aluc == SLL || aluc == SLLV) ? {b[0], b[1], b[2], b[3], b[4], b[5], b[6], b[7],
                          b[8], b[9], b[10], b[11], b[12], b[13], b[14], b[15],
                          b[16], b[17], b[18], b[19], b[20], b[21], b[22], b[23],
                          b[24], b[25], b[26], b[27], b[28], b[29], b[30], b[31]} : b;
    
    wire [31:0] stage1 = shift_amount[0] ? {shift_in[30:0], (aluc == SRA || aluc == SRAV) ? shift_in[31] : 1'b0} : shift_in;
    wire [31:0] stage2 = shift_amount[1] ? {stage1[29:0], {(2){aluc == SRA || aluc == SRAV ? stage1[31] : 1'b0}}} : stage1;
    wire [31:0] stage3 = shift_amount[2] ? {stage2[27:0], {(4){aluc == SRA || aluc == SRAV ? stage2[31] : 1'b0}}} : stage2;
    wire [31:0] stage4 = shift_amount[3] ? {stage3[23:0], {(8){aluc == SRA || aluc == SRAV ? stage3[31] : 1'b0}}} : stage3;
    assign shift_result = shift_amount[4] ? {stage4[15:0], {(16){aluc == SRA || aluc == SRAV ? stage4[31] : 1'b0}}} : stage4;
    
    // Comparison Unit
    assign comp_result = {31'b0, (aluc == SLT) ? (a_signed < b_signed) : (a < b)};
    
    // Result selection
    always @(*) begin
        case (aluc)
            ADD, ADDU, SUB, SUBU: r = arith_result;
            AND, OR, XOR, NOR:    r = logic_result;
            SLL, SRL, SRA, 
            SLLV, SRLV, SRAV:     r = shift_result;
            SLT, SLTU:            r = comp_result;
            LUI:                  r = {b[15:0], 16'b0};
            default:              r = 32'b0;
        endcase
        
        // Flag output
        flag = (aluc == SLT || aluc == SLTU) ? comp_result[0] : 1'b0;
    end
    
    // Flag generation
    assign zero = ~|r;
    assign negative = r[31];
    assign carry = (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU) ? arith_carry : 1'b0;
    assign overflow = (aluc == ADD || aluc == SUB) ? arith_overflow : 1'b0;

endmodule