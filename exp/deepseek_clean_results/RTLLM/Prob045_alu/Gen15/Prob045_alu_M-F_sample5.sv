module alu(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output reg [31:0] r,
    output zero,
    output carry,
    output negative,
    output overflow,
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

    wire [31:0] b_shift = (aluc == SLLV || aluc == SRLV || aluc == SRAV) ? a : b;
    wire [4:0] shamt = b_shift[4:0];
    wire [32:0] add_result = a + b;
    wire [32:0] sub_result = a - b;

    always @(*) begin
        case (aluc)
            ADD, ADDU: r = a + b;
            SUB, SUBU: r = a - b;
            AND:       r = a & b;
            OR:        r = a | b;
            XOR:       r = a ^ b;
            NOR:       r = ~(a | b);
            SLT:       r = ($signed(a) < $signed(b)) ? 1 : 0;
            SLTU:      r = a < b ? 1 : 0;
            SLL, SLLV: r = b << shamt;
            SRL, SRLV: r = b >> shamt;
            SRA, SRAV: r = $signed(b) >>> shamt;
            LUI:       r = {b[15:0], 16'b0};
            default:    r = 32'b0;
        endcase

        flag = (aluc == SLT || aluc == SLTU) ? r[0] : 1'b0;
    end

    assign zero = (r == 32'b0);
    assign carry = (aluc == ADD || aluc == ADDU) ? add_result[32] : 
                  (aluc == SUB || aluc == SUBU) ? sub_result[32] : 1'b0;
    assign negative = r[31];
    assign overflow = ((aluc == ADD) && (a[31] == b[31]) && (r[31] != a[31])) ||
                    ((aluc == SUB) && (a[31] != b[31]) && (r[31] != a[31]));

endmodule