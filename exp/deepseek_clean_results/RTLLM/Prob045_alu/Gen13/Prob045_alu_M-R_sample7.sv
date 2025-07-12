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

    // Operation type detection
    wire is_add  = (aluc == ADD || aluc == ADDU);
    wire is_sub  = (aluc == SUB || aluc == SUBU);
    wire is_arith = is_add || is_sub;
    wire is_logic = (aluc == AND || aluc == OR || aluc == XOR || aluc == NOR);
    wire is_shift = (aluc == SLL || aluc == SRL || aluc == SRA || 
                    aluc == SLLV || aluc == SRLV || aluc == SRAV);
    wire is_comp = (aluc == SLT || aluc == SLTU);
    wire is_lui = (aluc == LUI);

    // Shared Arithmetic Unit
    wire [31:0] arith_b = is_sub ? ~b : b;
    wire [32:0] arith_result = {1'b0, a} + {1'b0, arith_b} + {32'b0, is_sub};
    wire [31:0] arith_out = arith_result[31:0];

    // Logic Unit
    wire [31:0] logic_out = 
        (aluc == AND) ? (a & b) :
        (aluc == OR)  ? (a | b) :
        (aluc == XOR) ? (a ^ b) :
        (aluc == NOR) ? ~(a | b) : 32'b0;

    // Shift Unit
    wire [4:0] shift_amt = 
        (aluc == SLLV || aluc == SRLV || aluc == SRAV) ? a[4:0] : b[4:0];
    
    wire [31:0] shift_out = 
        (aluc == SLL || aluc == SLLV) ? (b << shift_amt) :
        (aluc == SRL || aluc == SRLV) ? (b >> shift_amt) :
        (aluc == SRA || aluc == SRAV) ? ($signed(b) >>> shift_amt) : 32'b0;

    // Comparison Unit
    wire [31:0] comp_out = 
        (aluc == SLT) ? {31'b0, $signed(a) < $signed(b)} :
        (aluc == SLTU) ? {31'b0, a < b} : 32'b0;

    // LUI Unit
    wire [31:0] lui_out = {b[15:0], 16'b0};

    // Result Selection
    wire [31:0] result = 
        is_arith ? arith_out :
        is_logic ? logic_out :
        is_shift ? shift_out :
        is_comp ? comp_out :
        is_lui ? lui_out : 32'b0;

    // Flag Generation
    wire signed_overflow = 
        is_add ? (a[31] == b[31]) && (result[31] != a[31]) :
        is_sub ? (a[31] != b[31]) && (result[31] != a[31]) : 1'b0;
    
    wire comp_flag = 
        (aluc == SLT) ? ($signed(a) < $signed(b)) :
        (aluc == SLTU) ? (a < b) : 1'b0;

    // Output Assignment
    assign r = result;
    assign zero = (result == 32'b0);
    assign carry = is_arith ? arith_result[32] : 1'b0;
    assign negative = result[31];
    assign overflow = (aluc == ADD || aluc == SUB) ? signed_overflow : 1'b0;
    assign flag = is_comp ? comp_flag : 1'b0;

endmodule