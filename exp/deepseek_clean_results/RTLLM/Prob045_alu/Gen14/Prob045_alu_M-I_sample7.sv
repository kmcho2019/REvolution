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

    // Operation group enables (for power gating)
    wire arith_en = |{aluc == ADD, aluc == ADDU, aluc == SUB, aluc == SUBU};
    wire logic_en = |{aluc == AND, aluc == OR, aluc == XOR, aluc == NOR};
    wire shift_en = |{aluc == SLL, aluc == SRL, aluc == SRA, 
                     aluc == SLLV, aluc == SRLV, aluc == SRAV};
    wire comp_en = |{aluc == SLT, aluc == SLTU};
    wire lui_en = (aluc == LUI);

    // Optimized Arithmetic Unit (carry-select)
    wire add_sub = |{aluc == SUB, aluc == SUBU};
    wire [31:0] arith_b = add_sub ? ~b : b;
    wire [15:0] sum_low, sum_high;
    wire carry_low, carry_high;
    
    // Lower 16-bit adder
    assign {carry_low, sum_low} = a[15:0] + arith_b[15:0] + add_sub;
    
    // Higher 16-bit adders (carry-select)
    assign {1'b0, sum_high} = a[31:16] + arith_b[31:16] + carry_low;
    assign carry_high = a[31:16] + arith_b[31:16] + 1'b1;
    
    // Final carry and result
    wire [31:0] arith_result = {carry_low ? sum_high : carry_high[15:0], sum_low};
    wire arith_carry = carry_low ? carry_high[16] : carry_high[15];
    
    // Early overflow detection
    wire arith_overflow = 
        (~a[31] & ~arith_b[31] & arith_result[31]) |
        (a[31] & arith_b[31] & ~arith_result[31]) |
        (add_sub & (~a[31] & b[31] & arith_result[31])) |
        (add_sub & (a[31] & ~b[31] & ~arith_result[31]));

    // Optimized Logic Unit
    wire [31:0] logic_result;
    always @(*) begin
        if (!logic_en) logic_result = 32'b0;
        else case (aluc[1:0])
            2'b00: logic_result = a & b;
            2'b01: logic_result = a | b;
            2'b10: logic_result = a ^ b;
            2'b11: logic_result = ~(a | b);
        endcase
    end

    // Enhanced Barrel Shifter
    wire [4:0] shift_amt = (aluc[3]) ? a[4:0] : b[4:0];
    wire [31:0] shift_result;
    
    // Pre-compute shift directions
    wire left_shift = (aluc[1:0] == 2'b00);
    wire logical_right = (aluc[1:0] == 2'b10);
    
    generate
        genvar i;
        for (i = 0; i < 32; i = i+1) begin : shifter
            wire [31:0] mask = (32'b1 << i);
            wire keep = (shift_amt == i);
            wire [31:0] shifted_val = 
                left_shift ? (b << i) :
                logical_right ? (b >> i) :
                ($signed(b) >>> i);
            assign shift_result = keep ? shifted_val : shift_result;
        end
    endgenerate

    // Comparison Unit with shared comparator
    wire signed_lt = ($signed(a) < $signed(b));
    wire unsigned_lt = (a < b);
    wire comp_result = (aluc == SLT) ? signed_lt : unsigned_lt;

    // Result selection with operand isolation
    reg [31:0] stage1_result;
    always @(*) begin
        case (1'b1)
            arith_en: stage1_result = arith_result;
            logic_en: stage1_result = logic_result;
            shift_en: stage1_result = shift_result;
            comp_en:  stage1_result = {31'b0, comp_result};
            lui_en:   stage1_result = {b[15:0], 16'b0};
            default:  stage1_result = 32'b0;
        endcase
    end

    // Output assignments
    assign r = stage1_result;
    
    // Optimized flag generation
    wire result_nonzero = |stage1_result;
    assign zero = ~result_nonzero;
    assign negative = stage1_result[31];
    assign carry = arith_en ? arith_carry : 1'b0;
    assign overflow = arith_en & 
                    ((aluc == ADD) | (aluc == SUB)) ? arith_overflow : 1'b0;
    assign flag = comp_en ? comp_result : 1'b0;

endmodule