module alu(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output reg [31:0] r,
    output zero,
    output reg carry,
    output negative,
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

    always @(*) begin
        flag = 1'b0;
        carry = 1'b0;
        overflow = 1'b0;
        
        case (aluc)
            ADD, ADDU, SUB, SUBU: begin
                {carry, r} = {1'b0, a} + {1'b0, (aluc[0] ? ~b : b)} + aluc[0];
                overflow = (aluc == ADD || aluc == SUB) ? (carry ^ r[31]) : 1'b0;
            end
            AND:       r = a & b;
            OR:        r = a | b;
            XOR:       r = a ^ b;
            NOR:       r = ~(a | b);
            SLT:      begin r = $signed(a) < $signed(b); flag = r[0]; end
            SLTU:      begin r = a < b; flag = r[0]; end
            LUI:       r = {b[15:0], 16'b0};
            SLL, SLLV: r = b << (aluc[2:0] == 3'b100 ? a[4:0] : b[4:0]);
            SRL, SRLV: r = b >> (aluc[2:0] == 3'b100 ? a[4:0] : b[4:0]);
            SRA, SRAV: r = $signed(b) >>> (aluc[2:0] == 3'b100 ? a[4:0] : b[4:0]);
            default:   r = 32'b0;
        endcase
    end

    assign zero = (r == 32'b0);
    assign negative = r[31];

endmodule