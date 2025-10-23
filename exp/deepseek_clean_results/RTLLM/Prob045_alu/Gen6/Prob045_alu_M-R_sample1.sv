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
    wire signed [31:0] signed_a = a;
    wire signed [31:0] signed_b = b;
    wire [4:0] shift_amount = (aluc[3] ? a[4:0] : b[4:0]);  // SLLV/SRLV/SRAV use a[4:0]
    
    // Arithmetic operations
    wire is_add = (aluc == ADD || aluc == ADDU);
    wire is_sub = (aluc == SUB || aluc == SUBU);
    wire [32:0] arith_res = is_add ? {1'b0, a} + {1'b0, b} :
                           is_sub ? {1'b0, a} + {1'b0, ~b} + 33'b1 : 33'b0;
    wire [31:0] arith_result = arith_res[31:0];
    
    // Comparison operations
    wire is_slt = (aluc == SLT);
    wire is_sltu = (aluc == SLTU);
    wire [31:0] cmp_result = is_slt ? {31'b0, signed_a < signed_b} :
                            is_sltu ? {31'b0, a < b} : 32'b0;
    
    // Logical operations
    wire is_and = (aluc == AND);
    wire is_or = (aluc == OR);
    wire is_xor = (aluc == XOR);
    wire is_nor = (aluc == NOR);
    wire [31:0] logic_result = is_and ? a & b :
                              is_or ? a | b :
                              is_xor ? a ^ b :
                              is_nor ? ~(a | b) : 32'b0;
    
    // Shift operations
    wire is_shift = (aluc[5:4] == 2'b00);
    wire [31:0] shift_result = 
        (aluc == SLL || aluc == SLLV) ? b << shift_amount :
        (aluc == SRL || aluc == SRLV) ? b >> shift_amount :
        (aluc == SRA || aluc == SRAV) ? $signed(b) >>> shift_amount : 32'b0;
    
    // Immediate operation
    wire is_lui = (aluc == LUI);
    wire [31:0] lui_result = {b[15:0], 16'b0};
    
    // Final result selection
    assign r = is_add || is_sub ? arith_result :
              is_slt || is_sltu ? cmp_result :
              is_and || is_or || is_xor || is_nor ? logic_result :
              is_shift ? shift_result :
              is_lui ? lui_result : 32'b0;
    
    // Flag assignments
    assign zero = (r == 32'b0);
    assign negative = r[31];
    assign overflow = (is_add && (a[31] == b[31]) && (r[31] != a[31])) ||
                     (is_sub && (a[31] != b[31]) && (r[31] != a[31]));
    assign carry = (is_add || is_sub) ? arith_res[32] : 1'b0;
    assign flag = is_slt ? cmp_result[0] : 
                 is_sltu ? cmp_result[0] : 1'b0;

endmodule