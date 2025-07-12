module alu(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output reg [31:0] r,
    output reg zero,
    output reg carry,
    output reg negative,
    output reg overflow,
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

    // Operation classification
    wire is_add = (aluc == ADD || aluc == ADDU);
    wire is_sub = (aluc == SUB || aluc == SUBU);
    wire is_and = (aluc == AND);
    wire is_or  = (aluc == OR);
    wire is_xor = (aluc == XOR);
    wire is_nor = (aluc == NOR);
    wire is_slt = (aluc == SLT);
    wire is_sltu= (aluc == SLTU);
    wire is_shift = (aluc[5:3] == 3'b000);
    wire is_lui = (aluc == LUI);

    // Parallel Datapaths
    // Arithmetic Unit
    wire [31:0] arith_b = is_sub ? ~b : b;
    wire [32:0] arith_full = {1'b0, a} + {1'b0, arith_b} + is_sub;
    wire [31:0] arith_result = arith_full[31:0];
    wire arith_carry = arith_full[32];
    wire arith_overflow = (a[31] == arith_b[31]) && (a[31] != arith_result[31]);

    // Logic Unit
    wire [31:0] and_result = a & b;
    wire [31:0] or_result  = a | b;
    wire [31:0] xor_result = a ^ b;
    wire [31:0] nor_result = ~(a | b);

    // Shift Unit
    wire [4:0] shift_amt = (aluc[2:0] == 3'b100) ? a[4:0] : b[4:0];
    wire [31:0] shift_in = (aluc == SLL || aluc == SLLV) ? b : a;
    wire [31:0] sll_result = shift_in << shift_amt;
    wire [31:0] srl_result = shift_in >> shift_amt;
    wire [31:0] sra_result = $signed(shift_in) >>> shift_amt;

    // Comparison Unit
    wire signed [31:0] a_signed = a;
    wire signed [31:0] b_signed = b;
    wire slt_result = (aluc == SLTU) ? (a < b) : (a_signed < b_signed);

    // Result Selection
    always @(*) begin
        casex(aluc)
            ADD, ADDU, SUB, SUBU: r = arith_result;
            AND:    r = and_result;
            OR:     r = or_result;
            XOR:    r = xor_result;
            NOR:    r = nor_result;
            SLT, SLTU: r = {31'b0, slt_result};
            SLL, SLLV:  r = sll_result;
            SRL, SRLV:  r = srl_result;
            SRA, SRAV: r = sra_result;
            LUI:    r = {b[15:0], 16'b0};
            default: r = 32'b0;
        endcase

        // Flag generation
        zero = (r == 32'b0);
        negative = r[31];
        flag = (aluc == SLT || aluc == SLTU) ? slt_result : 1'b0;
        
        // Carry/Overflow only relevant for arithmetic ops
        carry = (is_add || is_sub) ? arith_carry : 1'b0;
        overflow = (is_add || is_sub) ? arith_overflow : 1'b0;
    end

endmodule