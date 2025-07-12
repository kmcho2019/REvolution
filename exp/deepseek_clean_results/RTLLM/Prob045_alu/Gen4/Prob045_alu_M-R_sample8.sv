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
    wire [32:0] sum_ext = (aluc == ADD || aluc == ADDU) ? {1'b0, a} + {1'b0, b} : 
                         {1'b0, a} - {1'b0, b};
    wire [31:0] sum = sum_ext[31:0];
    wire [4:0] shamt = (aluc == SLLV || aluc == SRLV || aluc == SRAV) ? a[4:0] : b[4:0];
    
    // Shift operations
    wire [31:0] shifted = 
        (aluc == SLL || aluc == SLLV) ? b << shamt :
        (aluc == SRL || aluc == SRLV) ? b >> shamt :
        $signed(b) >>> shamt;

    // Arithmetic operations
    wire [31:0] arith_result = 
        (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU) ? sum :
        (aluc == SLT) ? ($signed(a) < $signed(b)) :
        (aluc == SLTU) ? (a < b) :
        32'b0;

    // Logical operations
    wire [31:0] logic_result = 
        (aluc == AND) ? a & b :
        (aluc == OR)  ? a | b :
        (aluc == XOR) ? a ^ b :
        (aluc == NOR) ? ~(a | b) :
        32'b0;

    // Special operations
    wire [31:0] special_result = 
        (aluc == LUI) ? {b[15:0], 16'b0} :
        shifted;

    // Final result selection
    assign r = 
        (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU || 
         aluc == SLT || aluc == SLTU) ? arith_result :
        (aluc == AND || aluc == OR || aluc == XOR || aluc == NOR) ? logic_result :
        (aluc == SLL || aluc == SRL || aluc == SRA || 
         aluc == SLLV || aluc == SRLV || aluc == SRAV || aluc == LUI) ? special_result :
        32'b0;

    // Status flags
    assign zero = (r == 32'b0);
    assign carry = (aluc == ADDU || aluc == SUBU) ? sum_ext[32] : 1'b0;
    assign negative = r[31];
    assign overflow = ((aluc == ADD) && (a[31] == b[31]) && (r[31] != a[31])) ||
                    ((aluc == SUB) && (a[31] != b[31]) && (r[31] == b[31]));
    assign flag = (aluc == SLT || aluc == SLTU) ? r[0] : 1'b0;

endmodule