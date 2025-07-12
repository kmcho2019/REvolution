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

    // Parallel operation results
    wire [31:0] add_result, sub_result;
    wire [31:0] and_result, or_result, xor_result, nor_result;
    wire [31:0] sll_result, srl_result, sra_result;
    wire [31:0] slt_result, sltu_result;
    wire [31:0] lui_result;
    
    // Operation-specific flags
    wire add_carry, sub_carry;
    wire add_overflow, sub_overflow;
    wire comparison_flag;
    
    // Shift amount calculation
    wire [4:0] shift_amount = 
        (aluc == SLLV || aluc == SRLV || aluc == SRAV) ? a[4:0] : b[4:0];
    
    // Parallel operation execution
    assign {add_carry, add_result} = a + b;
    assign {sub_carry, sub_result} = a - b;
    
    assign and_result = a & b;
    assign or_result  = a | b;
    assign xor_result = a ^ b;
    assign nor_result = ~(a | b);
    
    assign sll_result = b << shift_amount;
    assign srl_result = b >> shift_amount;
    assign sra_result = $signed(b) >>> shift_amount;
    
    assign slt_result  = {31'b0, $signed(a) < $signed(b)};
    assign sltu_result = {31'b0, a < b};
    assign lui_result  = {b[15:0], 16'b0};
    
    // Early flag prediction
    assign add_overflow = (a[31] == b[31]) && (add_result[31] != a[31]);
    assign sub_overflow = (a[31] != b[31]) && (sub_result[31] != a[31]);
    assign comparison_flag = (aluc == SLT) ? ($signed(a) < $signed(b)) : (a < b);
    
    // Result selection
    assign r = 
        (aluc == ADD || aluc == ADDU) ? add_result :
        (aluc == SUB || aluc == SUBU) ? sub_result :
        (aluc == AND) ? and_result :
        (aluc == OR)  ? or_result :
        (aluc == XOR) ? xor_result :
        (aluc == NOR) ? nor_result :
        (aluc == SLT) ? slt_result :
        (aluc == SLTU) ? sltu_result :
        (aluc == SLL || aluc == SLLV) ? sll_result :
        (aluc == SRL || aluc == SRLV) ? srl_result :
        (aluc == SRA || aluc == SRAV) ? sra_result :
        (aluc == LUI) ? lui_result : 32'b0;
    
    // Final flag generation
    assign zero = (r == 32'b0);
    assign carry = 
        (aluc == ADD || aluc == ADDU) ? add_carry :
        (aluc == SUB || aluc == SUBU) ? sub_carry : 1'b0;
    assign negative = r[31];
    assign overflow = 
        (aluc == ADD) ? add_overflow :
        (aluc == SUB) ? sub_overflow : 1'b0;
    assign flag = 
        (aluc == SLT || aluc == SLTU) ? comparison_flag : 1'b0;

endmodule