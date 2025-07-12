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
    wire [32:0] arith_sub = {1'b0, a} + {1'b0, ~b} + 33'b1;
    wire [31:0] arith_result = (aluc[0] ? arith_sub[31:0] : arith_add[31:0]);
    wire arith_carry = (aluc[0] ? arith_sub[32] : arith_add[32]);
    wire arith_overflow = (aluc[0] ? (a[31]^b[31]) & (a[31]^arith_result[31]) :
                                        (a[31]^~b[31]) & (a[31]^arith_result[31]);

    // Logical Unit
    wire [31:0] and_result = a & b;
    wire [31:0] or_result  = a | b;
    wire [31:0] xor_result = a ^ b;
    wire [31:0] nor_result = ~(a | b);

    // Shift Unit
    wire [4:0] shift_amt = (aluc[3] ? a[4:0] : b[4:0]); // SxLV vs Sx
    wire [31:0] sll_result = b << shift_amt;
    wire [31:0] srl_result = b >> shift_amt;
    wire [31:0] sra_result = $signed(b) >>> shift_amt;

    // Comparison Unit
    wire slt_result = $signed(a) < $signed(b);
    wire sltu_result = a < b;

    // Result Selection
    reg [31:0] result;
    always @(*) begin
        case(aluc)
            ADD, ADDU, SUB, SUBU: result = arith_result;
            AND:  result = and_result;
            OR:   result = or_result;
            XOR:  result = xor_result;
            NOR:  result = nor_result;
            SLT:  result = {31'b0, slt_result};
            SLTU: result = {31'b0, sltu_result};
            SLL, SLLV: result = sll_result;
            SRL, SRLV: result = srl_result;
            SRA, SRAV: result = sra_result;
            LUI: result = {b[15:0], 16'b0};
            default: result = 32'b0;
        endcase
    end

    // Flag Generation
    assign r = result;
    assign zero = (result == 32'b0);
    assign carry = ((aluc == ADD) || (aluc == ADDU) || (aluc == SUB) || (aluc == SUBU)) ? 
                  arith_carry : 1'b0;
    assign negative = result[31];
    assign overflow = ((aluc == ADD) || (aluc == SUB)) ? arith_overflow : 1'b0;
    assign flag = (aluc == SLT) ? slt_result : 
                 (aluc == SLTU) ? sltu_result : 1'b0;

endmodule