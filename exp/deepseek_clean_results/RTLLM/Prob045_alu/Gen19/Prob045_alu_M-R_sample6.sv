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

    // Arithmetic operations
    wire [32:0] add_result = {1'b0, a} + {1'b0, b};
    wire [32:0] sub_result = {1'b0, a} - {1'b0, b};
    wire [32:0] arith_result = aluc[0] ? add_result : sub_result;
    wire arith_ovf = (aluc == ADD) ? ((a[31] == b[31]) && (arith_result[31] != a[31])) :
                    (aluc == SUB) ? ((a[31] != b[31]) && (arith_result[31] != a[31])) : 1'b0;

    // Comparison operations
    wire signed [31:0] signed_a = a;
    wire signed [31:0] signed_b = b;
    wire lt_signed = (signed_a < signed_b);
    wire lt_unsigned = (a < b);
    wire cmp_result = (aluc[0] ? lt_unsigned : lt_signed);

    // Logic operations
    wire [31:0] and_result = a & b;
    wire [31:0] or_result = a | b;
    wire [31:0] xor_result = a ^ b;
    wire [31:0] nor_result = ~(a | b);
    wire [31:0] logic_result = 
        (aluc[1:0] == 2'b00) ? and_result :
        (aluc[1:0] == 2'b01) ? or_result :
        (aluc[1:0] == 2'b10) ? xor_result : nor_result;

    // Shift operations
    wire [4:0] shamt = (aluc[3] && |aluc[2:0]) ? a[4:0] : b[4:0];
    wire [31:0] sll_result = b << shamt;
    wire [31:0] srl_result = b >> shamt;
    wire [31:0] sra_result = $signed(b) >>> shamt;
    wire [31:0] shift_result = 
        (aluc[2:0] == 3'b000) ? sll_result :
        (aluc[2:0] == 3'b010) ? srl_result : sra_result;

    // LUI operation
    wire [31:0] lui_result = {b[15:0], 16'b0};

    // Final result selection
    assign r = 
        (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU) ? arith_result[31:0] :
        (aluc == SLT || aluc == SLTU) ? {31'b0, cmp_result} :
        (aluc == AND || aluc == OR || aluc == XOR || aluc == NOR) ? logic_result :
        (aluc == SLL || aluc == SRL || aluc == SRA || 
         aluc == SLLV || aluc == SRLV || aluc == SRAV) ? shift_result :
        (aluc == LUI) ? lui_result : 32'b0;

    // Flag generation
    assign zero = (r == 0);
    assign carry = ((aluc == ADD || aluc == ADDU) && add_result[32]) ||
                  ((aluc == SUB || aluc == SUBU) && sub_result[32]);
    assign negative = r[31];
    assign overflow = arith_ovf;
    assign flag = (aluc == SLT || aluc == SLTU) ? cmp_result : 1'b0;

endmodule