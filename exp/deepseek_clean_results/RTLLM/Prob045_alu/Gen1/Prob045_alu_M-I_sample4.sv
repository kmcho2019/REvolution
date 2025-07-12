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

    // Internal signals
    wire signed [31:0] a_signed = a;
    wire signed [31:0] b_signed = b;
    wire [4:0] shamt = b[4:0];
    wire [31:0] shift_result;
    wire [31:0] arith_result;
    wire arith_carry;
    wire slt_result = (a_signed < b_signed);
    wire sltu_result = (a < b);
    wire add_sub = (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU);
    wire is_add = (aluc == ADD || aluc == ADDU);
    wire is_sub = !is_add && add_sub;
    wire is_signed = (aluc == ADD || aluc == SUB || aluc == SLT);

    // Shared arithmetic unit
    assign {arith_carry, arith_result} = is_add ? (a + b) : (a - b);

    // Shared shifter
    assign shift_result = 
        (aluc == SLL || aluc == SLLV) ? (b << (aluc == SLL ? a[4:0] : shamt)) :
        (aluc == SRL || aluc == SRLV) ? (b >> (aluc == SRL ? a[4:0] : shamt)) :
        ($signed(b) >>> (aluc == SRA ? a[4:0] : shamt));

    // Result selection
    always @(*) begin
        case (aluc)
            ADD, ADDU, SUB, SUBU: r = arith_result;
            AND:  r = a & b;
            OR:   r = a | b;
            XOR:  r = a ^ b;
            NOR:  r = ~(a | b);
            SLT:  r = {31'b0, slt_result};
            SLTU: r = {31'b0, sltu_result};
            SLL, SRL, SRA, SLLV, SRLV, SRAV: r = shift_result;
            LUI:  r = {b[15:0], 16'b0};
            default: r = 32'b0;
        endcase
    end

    // Status flags
    assign zero = (r == 32'b0);
    assign carry = add_sub ? arith_carry : 1'b0;
    assign negative = r[31];
    assign overflow = is_signed && add_sub && 
                     ((is_add && (a[31] == b[31]) && (r[31] != a[31])) ||
                      (is_sub && (a[31] != b[31]) && (r[31] != a[31])));
    assign flag = (aluc == SLT) ? slt_result : 
                 (aluc == SLTU) ? sltu_result : 1'b0;

endmodule