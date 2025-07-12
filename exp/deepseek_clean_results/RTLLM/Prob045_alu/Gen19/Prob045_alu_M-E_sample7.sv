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

    // Parallel Arithmetic Unit
    wire [32:0] arith_add = {1'b0, a} + {1'b0, b};
    wire [32:0] arith_sub = {1'b0, a} - {1'b0, b};
    wire arith_ovf_add = (a[31] == b[31]) && (arith_add[31] != a[31]);
    wire arith_ovf_sub = (a[31] != b[31]) && (arith_sub[31] != a[31]);
    
    // Parallel Logic Unit
    wire [31:0] logic_and = a & b;
    wire [31:0] logic_or  = a | b;
    wire [31:0] logic_xor = a ^ b;
    wire [31:0] logic_nor = ~(a | b);

    // Parallel Shift Unit
    wire [4:0] shamt = (aluc[3] && |aluc[2:1]) ? a[4:0] : b[4:0];
    wire [31:0] shift_sll = b << shamt;
    wire [31:0] shift_srl = b >> shamt;
    wire [31:0] shift_sra = $signed(b) >>> shamt;
    wire [31:0] shift_lui = {b[15:0], 16'b0};

    // Shared Comparison Logic
    wire signed [31:0] signed_a = a;
    wire signed [31:0] signed_b = b;
    wire slt_result = signed_a < signed_b;
    wire sltu_result = a < b;

    // Operation Group Selection
    wire [31:0] arith_result =
        (aluc == ADD)  ? arith_add[31:0] :
        (aluc == ADDU) ? arith_add[31:0] :
        (aluc == SUB)  ? arith_sub[31:0] :
        (aluc == SUBU) ? arith_sub[31:0] :
        (aluc == SLT)  ? {31'b0, slt_result} :
        (aluc == SLTU) ? {31'b0, sltu_result} :
        32'b0;

    wire [31:0] logic_result =
        (aluc == AND) ? logic_and :
        (aluc == OR)  ? logic_or :
        (aluc == XOR) ? logic_xor :
        (aluc == NOR) ? logic_nor :
        32'b0;

    wire [31:0] shift_result =
        (aluc == SLL)  ? shift_sll :
        (aluc == SRL)  ? shift_srl :
        (aluc == SRA)  ? shift_sra :
        (aluc == SLLV) ? shift_sll :
        (aluc == SRLV) ? shift_srl :
        (aluc == SRAV) ? shift_sra :
        (aluc == LUI)  ? shift_lui :
        32'b0;

    // Final Result Selection
    assign r = (aluc[5:4] == 2'b10) ? 
              (aluc[3] ? arith_result : logic_result) :
              shift_result;

    // Parallel Zero Detection (OR reduction tree)
    wire [15:0] zero_low = |r[15:0];
    wire [15:0] zero_high = |r[31:16];
    assign zero = ~(zero_low | zero_high);

    // Operation-Specific Flag Generation
    assign carry = (aluc == ADD || aluc == ADDU) ? arith_add[32] :
                 (aluc == SUB || aluc == SUBU) ? arith_sub[32] :
                 1'b0;

    assign negative = r[31];

    assign overflow = (aluc == ADD) ? arith_ovf_add :
                    (aluc == SUB) ? arith_ovf_sub :
                    1'b0;

    assign flag = (aluc == SLT) ? slt_result :
                 (aluc == SLTU) ? sltu_result :
                 1'b0;

endmodule