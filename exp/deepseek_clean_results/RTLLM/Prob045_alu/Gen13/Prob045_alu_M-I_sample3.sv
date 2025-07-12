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
    wire [31:0] b_operand = (aluc == SUB || aluc == SUBU) ? ~b + 1 : b;
    wire [32:0] arith_result = {1'b0, a} + {1'b0, b_operand};
    wire [31:0] logic_result;
    wire [31:0] shift_result;
    wire compare_result;
    wire op_arith = (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU);
    wire op_compare = (aluc == SLT || aluc == SLTU);

    // Logic operations
    assign logic_result = 
        (aluc == AND) ? a & b :
        (aluc == OR)  ? a | b :
        (aluc == XOR) ? a ^ b :
        (aluc == NOR) ? ~(a | b) : 32'b0;

    // Shift operations
    wire [4:0] shift_amt = 
        (aluc == SLLV || aluc == SRLV || aluc == SRAV) ? a[4:0] : b[4:0];
    
    assign shift_result = 
        (aluc == SLL || aluc == SLLV) ? b << shift_amt :
        (aluc == SRL || aluc == SRLV) ? b >> shift_amt :
        (aluc == SRA || aluc == SRAV) ? $signed(b) >>> shift_amt :
        (aluc == LUI) ? {b[15:0], 16'b0} : 32'b0;

    // Comparison operations
    assign compare_result = 
        (aluc == SLT) ? ($signed(a) < $signed(b)) :
        (aluc == SLTU) ? (a < b) : 1'b0;

    // Result selection
    always @(*) begin
        case (1'b1)
            op_arith:   r = arith_result[31:0];
            (aluc == AND || aluc == OR || aluc == XOR || aluc == NOR): 
                        r = logic_result;
            (aluc == SLT || aluc == SLTU): 
                        r = {31'b0, compare_result};
            (aluc == SLL || aluc == SRL || aluc == SRA || 
             aluc == SLLV || aluc == SRLV || aluc == SRAV || aluc == LUI): 
                        r = shift_result;
            default:    r = 32'b0;
        endcase
    end

    // Flag generation
    assign zero = (r == 32'b0);
    assign negative = r[31];
    assign carry = op_arith ? arith_result[32] : 1'b0;
    
    assign overflow = 
        (aluc == ADD) ? (~a[31] & ~b[31] & r[31]) | (a[31] & b[31] & ~r[31]) :
        (aluc == SUB) ? (~a[31] & b[31] & r[31]) | (a[31] & ~b[31] & ~r[31]) :
        1'b0;
    
    assign flag = op_compare ? compare_result : 1'b0;

endmodule