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

    wire signed [31:0] a_signed = a;
    wire signed [31:0] b_signed = b;
    wire [4:0] shift_amount = (aluc == SLLV || aluc == SRLV || aluc == SRAV) ? a[4:0] : b[4:0];
    
    // Shared arithmetic logic
    wire is_add = (aluc == ADD || aluc == ADDU);
    wire is_sub = (aluc == SUB || aluc == SUBU);
    wire do_arith = is_add || is_sub;
    wire [32:0] arith_result = is_add ? ({1'b0, a} + {1'b0, b}) : 
                                        ({1'b0, a} - {1'b0, b});
    
    // Conditional shift operations
    wire do_shift = (aluc == SLL || aluc == SRL || aluc == SRA || 
                    aluc == SLLV || aluc == SRLV || aluc == SRAV);
    wire [31:0] shift_result = 
        (aluc == SLL || aluc == SLLV) ? (b << shift_amount) :
        (aluc == SRL || aluc == SRLV) ? (b >> shift_amount) :
        ($signed(b) >>> shift_amount);
    
    // Conditional comparison (only computed when needed)
    wire do_compare = (aluc == SLT || aluc == SLTU);
    wire slt_result = do_compare & (aluc == SLT) ? (a_signed < b_signed) : 1'b0;
    wire sltu_result = do_compare & (aluc == SLTU) ? (a < b) : 1'b0;
    
    // Hierarchical result selection
    wire [31:0] logic_result = 
        (aluc == AND) ? (a & b) :
        (aluc == OR)  ? (a | b) :
        (aluc == XOR) ? (a ^ b) :
        (aluc == NOR) ? ~(a | b) :
        32'b0;
    
    assign r = 
        do_arith ? arith_result[31:0] :
        do_shift ? shift_result :
        do_compare ? {31'b0, (aluc == SLT) ? slt_result : sltu_result} :
        (aluc == LUI) ? {b[15:0], 16'b0} :
        logic_result;
    
    // Optimized flag generation
    assign zero = (r == 32'b0);
    assign carry = do_arith ? arith_result[32] : 1'b0;
    assign negative = r[31];
    assign overflow = 
        (aluc == ADD) ? (~a[31] & ~b[31] & r[31]) | (a[31] & b[31] & ~r[31]) :
        (aluc == SUB) ? (~a[31] & b[31] & r[31]) | (a[31] & ~b[31] & ~r[31]) :
        1'b0;
    assign flag = do_compare ? ((aluc == SLT) ? slt_result : sltu_result) : 1'b0;

endmodule