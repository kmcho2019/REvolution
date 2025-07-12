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
    wire [32:0] arith_add = {1'b0, a} + {1'b0, b};
    wire [32:0] arith_sub = {1'b0, a} - {1'b0, b};
    wire arith_ovf_add = ~(a[31] ^ b[31]) & (a[31] ^ arith_add[31]);
    wire arith_ovf_sub = (a[31] ^ b[31]) & (a[31] ^ arith_sub[31]);

    // Logical Unit
    wire [31:0] logic_and = a & b;
    wire [31:0] logic_or  = a | b;
    wire [31:0] logic_xor = a ^ b;
    wire [31:0] logic_nor = ~(a | b);

    // Shift Unit
    wire [4:0] shift_amt = (aluc[3]) ? a[4:0] : b[4:0]; // SxLV ops
    wire [31:0] shift_sll = b << shift_amt;
    wire [31:0] shift_srl = b >> shift_amt;
    wire [31:0] shift_sra = $signed(b) >>> shift_amt;

    // Compare Unit
    wire cmp_slt  = $signed(a) < $signed(b);
    wire cmp_sltu = a < b;

    // Result Selection
    assign r = 
        (aluc == ADD || aluc == ADDU) ? arith_add[31:0] :
        (aluc == SUB || aluc == SUBU) ? arith_sub[31:0] :
        (aluc == AND) ? logic_and :
        (aluc == OR)  ? logic_or :
        (aluc == XOR) ? logic_xor :
        (aluc == NOR) ? logic_nor :
        (aluc == SLT) ? {31'b0, cmp_slt} :
        (aluc == SLTU)? {31'b0, cmp_sltu} :
        (aluc == SLL || aluc == SLLV) ? shift_sll :
        (aluc == SRL || aluc == SRLV) ? shift_srl :
        (aluc == SRA || aluc == SRAV) ? shift_sra :
        (aluc == LUI) ? {b[15:0], 16'b0} :
        32'b0; // Default safe value

    // Flag Generation
    assign zero = (r == 32'b0);
    assign negative = r[31];
    assign carry = 
        (aluc == ADD || aluc == ADDU) ? arith_add[32] :
        (aluc == SUB || aluc == SUBU) ? arith_sub[32] :
        1'b0;
    assign overflow = 
        (aluc == ADD) ? arith_ovf_add :
        (aluc == SUB) ? arith_ovf_sub :
        1'b0;
    assign flag = 
        (aluc == SLT) ? cmp_slt :
        (aluc == SLTU)? cmp_sltu :
        1'b0;

endmodule