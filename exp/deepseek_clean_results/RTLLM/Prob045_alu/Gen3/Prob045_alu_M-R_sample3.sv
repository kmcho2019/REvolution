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

    wire signed [31:0] signed_a = a;
    wire signed [31:0] signed_b = b;
    wire [4:0] shift_amount = (aluc[3] ? a[4:0] : b[4:0]);
    
    // Arithmetic operations
    wire [32:0] add_res = {1'b0, a} + {1'b0, b};
    wire [32:0] sub_res = {1'b0, a} - {1'b0, b};
    wire [31:0] arith_res = 
        (aluc == ADD || aluc == ADDU) ? add_res[31:0] :
        (aluc == SUB || aluc == SUBU) ? sub_res[31:0] :
        32'b0;
    
    // Logical operations
    wire [31:0] logic_res = 
        (aluc == AND) ? (a & b) :
        (aluc == OR)  ? (a | b) :
        (aluc == XOR) ? (a ^ b) :
        (aluc == NOR) ? ~(a | b) :
        32'b0;
    
    // Comparison operations
    wire [31:0] comp_res = 
        (aluc == SLT)  ? {31'b0, signed_a < signed_b} :
        (aluc == SLTU) ? {31'b0, a < b} :
        32'b0;
    
    // Shift operations
    wire [31:0] shift_res = 
        (aluc == SLL)  ? (b << shift_amount) :
        (aluc == SRL)  ? (b >> shift_amount) :
        (aluc == SRA)  ? ($signed(b) >>> shift_amount) :
        32'b0;
    
    // LUI operation
    wire [31:0] lui_res = (aluc == LUI) ? {b[15:0], 16'b0} : 32'b0;
    
    // Final result selection
    assign r = 
        (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU) ? arith_res :
        (aluc == AND || aluc == OR || aluc == XOR || aluc == NOR) ? logic_res :
        (aluc == SLT || aluc == SLTU) ? comp_res :
        (aluc == SLL || aluc == SRL || aluc == SRA) ? shift_res :
        (aluc == LUI) ? lui_res :
        32'b0;
    
    // Status flags
    assign zero = (r == 32'b0);
    assign carry = 
        (aluc == ADD || aluc == ADDU) ? add_res[32] : 
        (aluc == SUB || aluc == SUBU) ? sub_res[32] : 
        1'b0;
    assign negative = r[31];
    assign overflow = 
        (aluc == ADD && (a[31] == b[31]) && (r[31] != a[31])) ||
        (aluc == SUB && (a[31] != b[31]) && (r[31] != a[31]));
    assign flag = 
        (aluc == SLT) ? (signed_a < signed_b) :
        (aluc == SLTU) ? (a < b) : 
        1'b0;

endmodule