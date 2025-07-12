module alu(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output reg [31:0] r,
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

    wire [31:0] b_operand = aluc[0] ? ~b : b;
    wire [32:0] arith_result = {1'b0, a} + {1'b0, b_operand} + aluc[0];
    wire [4:0] shift_amount = aluc[2] ? a[4:0] : b[4:0];

    always @(*) begin
        case (aluc)
            ADD, ADDU, SUB, SUBU: r = arith_result[31:0];
            AND:       r = a & b;
            OR:        r = a | b;
            XOR:       r = a ^ b;
            NOR:       r = ~(a | b);
            SLT:       r = $signed(a) < $signed(b);
            SLTU:      r = a < b;
            LUI:       r = {b[15:0], 16'b0};
            SLL, SLLV: r = b << shift_amount;
            SRL, SRLV: r = b >> shift_amount;
            SRA, SRAV: r = $signed(b) >>> shift_amount;
            default:   r = 32'b0;
        endcase
    end

    assign zero = (r == 32'b0);
    assign negative = r[31];
    assign carry = arith_result[32] & (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU);
    assign overflow = (aluc == ADD || aluc == SUB) ? (arith_result[32] ^ arith_result[31]) : 1'b0;
    assign flag = (aluc == SLT || aluc == SLTU) ? r[0] : 1'b0;

endmodule