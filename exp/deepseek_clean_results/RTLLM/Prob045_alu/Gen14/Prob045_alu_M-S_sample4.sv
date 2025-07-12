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

    // Essential operation codes
    parameter ADD  = 6'b100000;
    parameter SUB  = 6'b100010;
    parameter AND  = 6'b100100;
    parameter OR   = 6'b100101;
    parameter XOR  = 6'b100110;
    parameter NOR  = 6'b100111;
    parameter SLT  = 6'b101010;
    parameter SLTU = 6'b101011;
    parameter SLL  = 6'b000000;
    parameter SRL  = 6'b000010;
    parameter SRA  = 6'b000011;
    parameter LUI  = 6'b001111;

    always @(*) begin
        carry = 0;
        overflow = 0;
        flag = 0;
        negative = 0;
        zero = 0;

        case (aluc)
            ADD, SUB: begin
                r = (aluc == ADD) ? a + b : a - b;
                carry = (aluc == ADD) ? (a + b < a) : (a < b);
                overflow = (a[31] == b[31]) && (r[31] != a[31]);
            end
            AND:  r = a & b;
            OR:   r = a | b;
            XOR:  r = a ^ b;
            NOR:  r = ~(a | b);
            SLT:  begin r = $signed(a) < $signed(b); flag = r[0]; end
            SLTU: begin r = a < b; flag = r[0]; end
            SLL:  r = b << a[4:0];
            SRL:  r = b >> a[4:0];
            SRA:  r = $signed(b) >>> a[4:0];
            LUI:  r = {b[15:0], 16'b0};
            default: r = 0;
        endcase

        negative = r[31];
        zero = (r == 0);
    end

endmodule