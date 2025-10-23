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

    // Arithmetic Unit
    wire [32:0] add_res = a + b;
    wire [32:0] sub_res = a - b;
    wire arith_ovf_add = (a[31] == b[31]) & (add_res[31] != a[31]);
    wire arith_ovf_sub = (a[31] != b[31]) & (sub_res[31] != a[31]);
    
    wire [31:0] arith_result = 
        (aluc == ADD)  ? add_res[31:0] :
        (aluc == ADDU) ? add_res[31:0] :
        (aluc == SUB)  ? sub_res[31:0] :
        (aluc == SUBU) ? sub_res[31:0] : 32'b0;
    
    wire arith_carry = 
        (aluc == ADD || aluc == ADDU) ? add_res[32] :
        (aluc == SUB || aluc == SUBU) ? sub_res[32] : 1'b0;
    
    wire arith_overflow = 
        (aluc == ADD) ? arith_ovf_add :
        (aluc == SUB) ? arith_ovf_sub : 1'b0;

    // Logic Unit
    wire [31:0] logic_result = 
        (aluc == AND) ? (a & b) :
        (aluc == OR)  ? (a | b) :
        (aluc == XOR) ? (a ^ b) :
        (aluc == NOR) ? ~(a | b) : 32'b0;

    // Shift Unit
    wire [4:0] shamt = 
        (aluc == SLLV || aluc == SRLV || aluc == SRAV) ? a[4:0] : b[4:0];
    
    wire [31:0] shift_result = 
        (aluc == SLL || aluc == SLLV)  ? (b << shamt) :
        (aluc == SRL || aluc == SRLV)  ? (b >> shamt) :
        (aluc == SRA || aluc == SRAV)  ? ($signed(b) >>> shamt) : 32'b0;

    // Comparison Unit
    wire [31:0] comp_result = 
        (aluc == SLT)  ? {31'b0, ($signed(a) < $signed(b))} :
        (aluc == SLTU) ? {31'b0, (a < b)} : 32'b0;
    
    wire comp_flag = 
        (aluc == SLT)  ? ($signed(a) < $signed(b)) :
        (aluc == SLTU) ? (a < b) : 1'b0;

    // Immediate Unit (LUI)
    wire [31:0] lui_result = {b[15:0], 16'b0};

    // Result Selection Hierarchy
    wire [31:0] result;
    assign result = 
        // Highest priority: Arithmetic operations
        ((aluc == ADD) || (aluc == ADDU) || (aluc == SUB) || (aluc == SUBU)) ? arith_result :
        // Next priority: Logical operations
        ((aluc == AND) || (aluc == OR) || (aluc == XOR) || (aluc == NOR)) ? logic_result :
        // Then shift operations
        ((aluc == SLL) || (aluc == SRL) || (aluc == SRA) || 
         (aluc == SLLV) || (aluc == SRLV) || (aluc == SRAV)) ? shift_result :
        // Then comparison operations
        ((aluc == SLT) || (aluc == SLTU)) ? comp_result :
        // Finally LUI
        (aluc == LUI) ? lui_result : 32'b0;

    // Flag Generation
    assign zero = (result == 32'b0);
    assign negative = result[31];
    assign carry = 
        ((aluc == ADD) || (aluc == ADDU) || (aluc == SUB) || (aluc == SUBU)) ? arith_carry : 1'b0;
    assign overflow = 
        ((aluc == ADD) || (aluc == SUB)) ? arith_overflow : 1'b0;
    assign flag = 
        ((aluc == SLT) || (aluc == SLTU)) ? comp_flag : 1'b0;

endmodule