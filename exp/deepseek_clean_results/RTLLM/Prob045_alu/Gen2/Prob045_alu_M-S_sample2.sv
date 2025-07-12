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
    wire [31:0] sum = (aluc == ADD || aluc == ADDU) ? a + b : a - b;
    wire [4:0] shamt = (aluc == SLLV || aluc == SRLV || aluc == SRAV) ? a[4:0] : b[4:0];
    wire [31:0] shifted = 
        (aluc == SLL || aluc == SLLV) ? b << shamt :
        (aluc == SRL || aluc == SRLV) ? b >> shamt :
        $signed(b) >>> shamt;

    // Main ALU operation
    always @(*) begin
        case (aluc)
            ADD, ADDU, SUB, SUBU: r = sum;
            AND:  r = a & b;
            OR:   r = a | b;
            XOR:  r = a ^ b;
            NOR:  r = ~(a | b);
            SLT:  r = ($signed(a) < $signed(b)) ? 1 : 0;
            SLTU: r = (a < b) ? 1 : 0;
            SLL, SRL, SRA, SLLV, SRLV, SRAV: r = shifted;
            LUI:  r = {b[15:0], 16'b0};
            default: r = 32'b0;
        endcase
    end

    // Status flags
    assign zero = (r == 32'b0);
    assign carry = (aluc == ADDU || aluc == SUBU) ? sum[32] : 1'b0;
    assign negative = r[31];
    assign overflow = ((aluc == ADD) && (a[31] == b[31]) && (r[31] != a[31])) ||
                     ((aluc == SUB) && (a[31] != b[31]) && (r[31] != a[31]));
    assign flag = (aluc == SLT) ? ($signed(a) < $signed(b)) :
                 (aluc == SLTU) ? (a < b) : 1'b0;

endmodule