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

    // Arithmetic units
    wire [32:0] add_result = {1'b0, a} + {1'b0, b};
    wire [32:0] sub_result = {1'b0, a} - {1'b0, b};
    wire [32:0] arith_result = (aluc == ADD || aluc == ADDU) ? add_result : 
                               (aluc == SUB || aluc == SUBU) ? sub_result : 33'b0;

    // Logical operations
    wire [31:0] and_result = a & b;
    wire [31:0] or_result  = a | b;
    wire [31:0] xor_result = a ^ b;
    wire [31:0] nor_result = ~(a | b);
    wire [31:0] logic_result = (aluc == AND) ? and_result :
                               (aluc == OR)  ? or_result  :
                               (aluc == XOR) ? xor_result :
                               (aluc == NOR) ? nor_result : 32'b0;

    // Shift operations
    wire [4:0] shift_amount = (aluc[3]) ? a[4:0] : b[4:0]; // SLLV/SRLV/SRAV use a[4:0]
    wire [31:0] sll_result = b << shift_amount;
    wire [31:0] srl_result = b >> shift_amount;
    wire [31:0] sra_result = $signed(b) >>> shift_amount;
    wire [31:0] shift_result = (aluc == SLL || aluc == SLLV) ? sll_result :
                               (aluc == SRL || aluc == SRLV) ? srl_result :
                               (aluc == SRA || aluc == SRAV) ? sra_result : 32'b0;

    // Comparison operations
    wire slt_result = $signed(a) < $signed(b);
    wire sltu_result = a < b;
    wire [31:0] compare_result = {31'b0, (aluc == SLT) ? slt_result : sltu_result};

    // LUI operation
    wire [31:0] lui_result = {b[15:0], 16'b0};

    // Result selection (priority encoded)
    assign r = (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU) ? arith_result[31:0] :
               (aluc == AND || aluc == OR || aluc == XOR || aluc == NOR) ? logic_result :
               (aluc == SLL || aluc == SRL || aluc == SRA || 
                aluc == SLLV || aluc == SRLV || aluc == SRAV) ? shift_result :
               (aluc == SLT || aluc == SLTU) ? compare_result :
               (aluc == LUI) ? lui_result : 32'b0;

    // Flag generation (parallel computation)
    assign zero = (r == 32'b0);
    assign carry = (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU) ? arith_result[32] : 1'b0;
    assign negative = r[31];
    
    // Overflow detection
    wire add_ovf = (~a[31] & ~b[31] & r[31]) | (a[31] & b[31] & ~r[31]);
    wire sub_ovf = (~a[31] & b[31] & r[31]) | (a[31] & ~b[31] & ~r[31]);
    assign overflow = (aluc == ADD) ? add_ovf : 
                     (aluc == SUB) ? sub_ovf : 1'b0;
    
    assign flag = (aluc == SLT) ? slt_result :
                 (aluc == SLTU) ? sltu_result : 1'b0;

endmodule