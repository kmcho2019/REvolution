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

    // Arithmetic Unit Results
    wire [31:0] arith_result;
    wire arith_carry, arith_overflow;
    wire [31:0] add_result = a + b;
    wire [31:0] sub_result = a - b;
    
    assign arith_result = (aluc == ADD || aluc == ADDU) ? add_result : 
                         (aluc == SUB || aluc == SUBU) ? sub_result : 32'b0;
    
    // Carry is valid for both signed and unsigned
    assign arith_carry = (aluc == ADD || aluc == ADDU) ? (a + b < a) : 
                         (aluc == SUB || aluc == SUBU) ? (a < b) : 1'b0;
    
    // Overflow only for signed operations
    assign arith_overflow = (aluc == ADD) ? (~a[31] & ~b[31] & add_result[31]) | 
                                              (a[31] & b[31] & ~add_result[31]) :
                            (aluc == SUB) ? (~a[31] & b[31] & sub_result[31]) | 
                                              (a[31] & ~b[31] & ~sub_result[31]) : 1'b0;

    // Logical Unit Results
    wire [31:0] logic_result;
    assign logic_result = (aluc == AND) ? a & b :
                         (aluc == OR)  ? a | b :
                         (aluc == XOR) ? a ^ b :
                         (aluc == NOR) ? ~(a | b) : 32'b0;

    // Shift Unit Results
    wire [4:0] shift_amount = (aluc == SLLV || aluc == SRLV || aluc == SRAV) ? a[4:0] : b[4:0];
    wire [31:0] shift_result;
    assign shift_result = (aluc == SLL || aluc == SLLV) ? b << shift_amount :
                         (aluc == SRL || aluc == SRLV) ? b >> shift_amount :
                         (aluc == SRA || aluc == SRAV) ? $signed(b) >>> shift_amount : 32'b0;

    // Comparison Unit Results
    wire [31:0] comp_result;
    wire comp_flag;
    wire signed [31:0] a_signed = a;
    wire signed [31:0] b_signed = b;
    
    assign comp_result = (aluc == SLT) ? {31'b0, a_signed < b_signed} :
                        (aluc == SLTU) ? {31'b0, a < b} : 32'b0;
    assign comp_flag = (aluc == SLT) ? (a_signed < b_signed) :
                      (aluc == SLTU) ? (a < b) : 1'b0;

    // LUI Operation
    wire [31:0] lui_result = {b[15:0], 16'b0};

    // Final Result Selection
    reg [31:0] final_result;
    always @(*) begin
        case(aluc)
            ADD, ADDU, SUB, SUBU: final_result = arith_result;
            AND, OR, XOR, NOR:    final_result = logic_result;
            SLL, SRL, SRA, 
            SLLV, SRLV, SRAV:    final_result = shift_result;
            SLT, SLTU:            final_result = comp_result;
            LUI:                  final_result = lui_result;
            default:              final_result = 32'b0;
        endcase
    end

    // Output assignments
    assign r = final_result;
    assign zero = (final_result == 32'b0);
    assign negative = final_result[31];
    assign carry = (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU) ? arith_carry : 1'b0;
    assign overflow = (aluc == ADD || aluc == SUB) ? arith_overflow : 1'b0;
    assign flag = (aluc == SLT || aluc == SLTU) ? comp_flag : 1'b0;

endmodule