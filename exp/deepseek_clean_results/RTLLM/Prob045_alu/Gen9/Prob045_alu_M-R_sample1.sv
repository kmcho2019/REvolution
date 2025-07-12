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

    // Internal signals
    wire [31:0] arith_result, logic_result, shift_result;
    wire [32:0] add_out, sub_out;
    wire arith_carry, arith_overflow;
    wire is_arith = (aluc == ADD) | (aluc == ADDU) | (aluc == SUB) | (aluc == SUBU);
    wire is_logic = (aluc == AND) | (aluc == OR) | (aluc == XOR) | (aluc == NOR);
    wire is_shift = (aluc == SLL) | (aluc == SRL) | (aluc == SRA) | 
                   (aluc == SLLV) | (aluc == SRLV) | (aluc == SRAV);
    
    // Arithmetic Unit
    assign add_out = {1'b0, a} + {1'b0, b};
    assign sub_out = {1'b0, a} - {1'b0, b};
    assign arith_result = (aluc == ADD || aluc == ADDU) ? add_out[31:0] : sub_out[31:0];
    assign arith_carry = (aluc == ADD || aluc == ADDU) ? add_out[32] : sub_out[32];
    
    // Overflow detection
    wire add_ovf = (~a[31] & ~b[31] & arith_result[31]) | (a[31] & b[31] & ~arith_result[31]);
    wire sub_ovf = (~a[31] & b[31] & arith_result[31]) | (a[31] & ~b[31] & ~arith_result[31]);
    assign arith_overflow = (aluc == ADD) ? add_ovf : 
                           (aluc == SUB) ? sub_ovf : 1'b0;
    
    // Logic Unit
    assign logic_result = (aluc == AND) ? a & b :
                        (aluc == OR)  ? a | b :
                        (aluc == XOR) ? a ^ b :
                        (aluc == NOR) ? ~(a | b) : 32'b0;
    
    // Shift Unit
    wire [4:0] shift_amount = (aluc == SLLV || aluc == SRLV || aluc == SRAV) ? a[4:0] : b[4:0];
    wire [31:0] shift_in = (aluc == SLLV || aluc == SRLV || aluc == SRAV) ? b : a;
    
    assign shift_result = (aluc == SLL || aluc == SLLV) ? shift_in << shift_amount :
                         (aluc == SRL || aluc == SRLV) ? shift_in >> shift_amount :
                         (aluc == SRA || aluc == SRAV) ? $signed(shift_in) >>> shift_amount : 32'b0;
    
    // Comparison Unit
    wire signed [31:0] a_signed = a;
    wire signed [31:0] b_signed = b;
    wire slt_result = a_signed < b_signed;
    wire sltu_result = a < b;
    wire [31:0] comp_result = (aluc == SLT) ? {31'b0, slt_result} :
                             (aluc == SLTU) ? {31'b0, sltu_result} : 32'b0;
    
    // Result multiplexer
    assign r = (is_arith) ? arith_result :
              (is_logic) ? logic_result :
              (is_shift) ? shift_result :
              (aluc == SLT || aluc == SLTU) ? comp_result :
              (aluc == LUI) ? {b[15:0], 16'b0} : 32'b0;
    
    // Flag generation
    assign zero = (r == 32'b0);
    assign carry = is_arith ? arith_carry : 1'b0;
    assign negative = r[31];
    assign overflow = is_arith ? arith_overflow : 1'b0;
    assign flag = (aluc == SLT) ? slt_result :
                 (aluc == SLTU) ? sltu_result : 1'b0;

endmodule