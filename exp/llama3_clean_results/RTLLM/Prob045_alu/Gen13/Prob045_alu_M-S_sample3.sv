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

// Define operation codes
parameter ADD = 6'b100000;
parameter ADDU = 6'b100001;
parameter SUB = 6'b100010;
parameter SUBU = 6'b100011;
parameter AND = 6'b100100;
parameter OR = 6'b100101;
parameter XOR = 6'b100110;
parameter NOR = 6'b100111;
parameter SLT = 6'b101010;
parameter SLTU = 6'b101011;
parameter SLL = 6'b000000;
parameter SRL = 6'b000010;
parameter SRA = 6'b000011;
parameter SLLV = 6'b000100;
parameter SRLV = 6'b000110;
parameter SRAV = 6'b000111;
parameter LUI = 6'b001111;

always @(*) begin
    case(aluc)
        LUI: r = {a[15:0], 16'd0};
        SLL, SLLV: r = (aluc == SLL) ? a << b[4:0] : a << b;
        SRL, SRLV: r = (aluc == SRL) ? a >> b[4:0] : a >> b;
        SRA, SRAV: r = (aluc == SRA) ? a >>> b[4:0] : a >>> b;
        AND: r = a & b;
        OR: r = a | b;
        XOR: r = a ^ b;
        NOR: r = ~(a | b);
        ADD, ADDU: begin
            r = a + b;
            if (aluc == ADDU) carry = (r[31] == 1'b1);
            else if (aluc == ADD) overflow = ((a[31] != b[31]) && (a[31] != r[31]));
        end
        SUB, SUBU: begin
            r = a - b;
            if (aluc == SUBU) carry = (r[31] == 1'b1);
            else if (aluc == SUB) overflow = ((a[31] == b[31]) && (a[31] != r[31]));
        end
        SLT: begin
            r = (signed'(a) < signed'(b)) ? 32'd1 : 32'd0;
            flag = (signed'(a) < signed'(b));
        end
        SLTU: begin
            r = (a < b) ? 32'd1 : 32'd0;
            flag = (a < b);
        end
        default: r = 32'bx;
    endcase

    // Calculate flags
    zero = (r == 32'd0);
    negative = r[31];
end

endmodule