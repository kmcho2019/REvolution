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

    // Operation category detection
    wire is_arith = (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU);
    wire is_logic = (aluc == AND || aluc == OR || aluc == XOR || aluc == NOR);
    wire is_shift = (aluc == SLL || aluc == SRL || aluc == SRA || 
                    aluc == SLLV || aluc == SRLV || aluc == SRAV);
    wire is_comp  = (aluc == SLT || aluc == SLTU);
    wire is_lui   = (aluc == LUI);

    // Parallel Execution Units -------------------------------------------------

    // 1. Arithmetic Unit (Carry-select adder implementation)
    wire [31:0] arith_result;
    wire arith_carry, arith_overflow;
    wire arith_sub = (aluc == SUB || aluc == SUBU);
    wire [31:0] arith_b = arith_sub ? ~b : b;
    wire arith_cin = arith_sub ? 1'b1 : 1'b0;
    
    // Carry-select adder implementation
    wire [15:0] sum_low, sum_high0, sum_high1;
    wire carry_low, carry_high0, carry_high1;
    
    // Lower 16 bits
    assign {carry_low, sum_low} = a[15:0] + arith_b[15:0] + arith_cin;
    
    // Higher 16 bits (two versions)
    assign {carry_high0, sum_high0} = a[31:16] + arith_b[31:16] + 1'b0;
    assign {carry_high1, sum_high1} = a[31:16] + arith_b[31:16] + 1'b1;
    
    // Final selection
    assign arith_result = {carry_low ? sum_high1 : sum_high0, sum_low};
    assign arith_carry = carry_low ? carry_high1 : carry_high0;
    
    // Overflow detection
    assign arith_overflow = (a[31] == arith_b[31]) && (arith_result[31] != a[31]);

    // 2. Logic Unit
    wire [31:0] logic_result;
    assign logic_result = 
        (aluc == AND) ? (a & b) :
        (aluc == OR)  ? (a | b) :
        (aluc == XOR) ? (a ^ b) :
        (aluc == NOR) ? ~(a | b) : 32'b0;

    // 3. Shift Unit (Logarithmic barrel shifter)
    wire [31:0] shift_result;
    wire [4:0] shift_amt = (aluc[3] /*V-type*/) ? a[4:0] : b[4:0];
    
    // Right/left selection
    wire shift_right = (aluc == SRL || aluc == SRLV || aluc == SRA || aluc == SRAV);
    wire [31:0] shift_in = shift_right ? b : {b[0], b[1], b[2], b[3], b[4], b[5], b[6], b[7],
                                            b[8], b[9], b[10], b[11], b[12], b[13], b[14], b[15],
                                            b[16], b[17], b[18], b[19], b[20], b[21], b[22], b[23],
                                            b[24], b[25], b[26], b[27], b[28], b[29], b[30], b[31]};
    
    // Logarithmic shifter
    wire [31:0] stage1 = shift_amt[0] ? {shift_in[30:0], 1'b0} : shift_in;
    wire [31:0] stage2 = shift_amt[1] ? {stage1[29:0], 2'b0} : stage1;
    wire [31:0] stage3 = shift_amt[2] ? {stage2[27:0], 4'b0} : stage2;
    wire [31:0] stage4 = shift_amt[3] ? {stage3[23:0], 8'b0} : stage3;
    wire [31:0] stage5 = shift_amt[4] ? {stage4[15:0], 16'b0} : stage4;
    
    // Handle arithmetic right shift
    wire sign_bit = (aluc == SRA || aluc == SRAV) & b[31];
    wire [31:0] shifted_val = shift_right ? 
                             {32{sign_bit}} >> (32 - shift_amt) : stage5;
    
    assign shift_result = shift_right ? 
                         {shifted_val, stage5[31:32-shift_amt]} : 
                         stage5[31-shift_amt:0];

    // 4. Comparison Unit (Early termination)
    wire signed [31:0] signed_a = a;
    wire signed [31:0] signed_b = b;
    wire comp_result = (aluc == SLT) ? (signed_a < signed_b) : (a < b);

    // 5. LUI Unit
    wire [31:0] lui_result = {b[15:0], 16'b0};

    // Result Selection ---------------------------------------------------------
    reg [31:0] final_result;
    always @(*) begin
        case (1'b1)  // Priority encoder style
            is_arith: final_result = arith_result;
            is_logic: final_result = logic_result;
            is_shift: final_result = shift_result;
            is_comp:  final_result = {31'b0, comp_result};
            is_lui:   final_result = lui_result;
            default:  final_result = 32'b0;
        endcase
    end

    // Flag Generation ----------------------------------------------------------
    // Zero flag (reduction NOR)
    assign zero = ~(|final_result);
    
    // Negative flag
    assign negative = final_result[31];
    
    // Carry flag (only for arithmetic)
    assign carry = is_arith ? arith_carry : 1'b0;
    
    // Overflow flag (only for signed arithmetic)
    assign overflow = is_arith & ~aluc[0] ? arith_overflow : 1'b0;
    
    // Flag output (only for comparisons)
    assign flag = is_comp ? comp_result : 1'b0;
    
    // Final output
    assign r = final_result;

endmodule