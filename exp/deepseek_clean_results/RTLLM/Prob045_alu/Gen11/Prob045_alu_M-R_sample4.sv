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
    wire [31:0] add_result = a + b;
    wire [31:0] sub_result = a - b;
    wire [31:0] add_result_u = {1'b0, a} + {1'b0, b};
    wire [31:0] sub_result_u = {1'b0, a} - {1'b0, b};
    
    wire [4:0] shift_amt = aluc[3] ? a[4:0] : b[4:0];
    wire signed [31:0] signed_b = b;
    
    // Result selection
    wire [31:0] arithmetic_result = 
        (aluc == ADD)  ? add_result :
        (aluc == ADDU) ? add_result :
        (aluc == SUB)  ? sub_result :
        (aluc == SUBU) ? sub_result : 32'b0;
    
    wire [31:0] logical_result =
        (aluc == AND)  ? a & b :
        (aluc == OR)   ? a | b :
        (aluc == XOR)  ? a ^ b :
        (aluc == NOR)  ? ~(a | b) : 32'b0;
    
    wire [31:0] shift_result =
        (aluc == SLL || aluc == SLLV) ? b << shift_amt :
        (aluc == SRL || aluc == SRLV) ? b >> shift_amt :
        (aluc == SRA || aluc == SRAV) ? signed_b >>> shift_amt : 32'b0;
    
    wire [31:0] compare_result =
        (aluc == SLT)  ? (a < b) :
        (aluc == SLTU) ? ({1'b0, a} < {1'b0, b}) : 32'b0;
    
    wire [31:0] immediate_result =
        (aluc == LUI) ? {b[15:0], 16'b0} : 32'b0;
    
    // Final result mux
    wire [31:0] result = 
        (aluc[5:4] == 2'b10) ? (aluc[2] ? compare_result : arithmetic_result) :
        (aluc[5:3] == 3'b000) ? shift_result :
        (aluc == LUI) ? immediate_result :
        logical_result;

    // Flag generation
    assign zero = (result == 32'b0);
    assign negative = result[31];
    assign carry = 
        (aluc == ADD || aluc == ADDU) ? add_result_u[32] :
        (aluc == SUB || aluc == SUBU) ? sub_result_u[32] : 1'b0;
    assign overflow =
        (aluc == ADD) ? ((a[31] == b[31]) && (result[31] != a[31])) :
        (aluc == SUB) ? ((a[31] != b[31]) && (result[31] != a[31])) : 1'b0;
    assign flag = (aluc == SLT || aluc == SLTU) ? result[0] : 1'b0;

    // Output assignment
    assign r = result;

endmodule