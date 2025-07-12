module alu(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output [31:0] r,
    output zero,
    output carry,
    output negative,
    output overflow,
    output reg flag
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

    // Arithmetic operations
    wire [31:0] arith_b = (aluc[1]) ? ~b : b;  // Invert for subtraction
    wire [32:0] arith_full = {1'b0, a} + {1'b0, arith_b} + aluc[1];
    wire [31:0] arith_result = arith_full[31:0];
    
    // Logic operations
    wire [31:0] and_result = a & b;
    wire [31:0] or_result  = a | b;
    wire [31:0] xor_result = a ^ b;
    wire [31:0] nor_result = ~(a | b);
    
    // Comparison operations
    wire signed [31:0] a_signed = a;
    wire signed [31:0] b_signed = b;
    wire slt_result = (aluc == SLTU) ? (a < b) : (a_signed < b_signed);
    
    // Shift operations
    wire [4:0] shift_amount = (aluc[2:0] == 3'b100) ? a[4:0] : b[4:0];
    wire [31:0] shift_in = b;
    wire [31:0] sll_result = shift_in << shift_amount;
    wire [31:0] srl_result = shift_in >> shift_amount;
    wire [31:0] sra_result = $signed(shift_in) >>> shift_amount;
    
    // Result multiplexer
    assign r = 
        (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU) ? arith_result :
        (aluc == AND) ? and_result :
        (aluc == OR)  ? or_result :
        (aluc == XOR) ? xor_result :
        (aluc == NOR) ? nor_result :
        (aluc == SLT || aluc == SLTU) ? {31'b0, slt_result} :
        (aluc == SLL || aluc == SLLV) ? sll_result :
        (aluc == SRL || aluc == SRLV) ? srl_result :
        (aluc == SRA || aluc == SRAV) ? sra_result :
        (aluc == LUI) ? {b[15:0], 16'b0} :
        32'b0;
    
    // Flag outputs
    assign zero = (r == 32'b0);
    assign negative = r[31];
    assign carry = arith_full[32];
    assign overflow = (a[31] == arith_b[31]) && (a[31] != arith_result[31]);
    
    // Flag output needs conditional assignment
    always @(*) begin
        flag = (aluc == SLT || aluc == SLTU) ? slt_result : 1'b0;
    end

endmodule