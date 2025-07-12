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
    case (aluc)
        ADD, ADDU: begin
            {carry, r} = a + b;
            overflow = (aluc == ADD) && (a[31] == b[31] && a[31]!= r[31]);
        end
        SUB, SUBU: begin
            {carry, r} = a - b;
            overflow = (aluc == SUB) && (a[31]!= b[31] && a[31]!= r[31]);
        end
        AND: r = a & b;
        OR: r = a | b;
        XOR: r = a ^ b;
        NOR: r = ~(a | b);
        SLL, SLLV: r = (aluc == SLL)? a << b[4:0] : a << a[4:0];
        SRL, SRLV: r = (aluc == SRL)? a >> b[4:0] : a >> a[4:0];
        SRA, SRAV: r = (aluc == SRA)? a >>> b[4:0] : a >>> a[4:0];
        LUI: r = {16'b0, a[15:0]};
        SLT: begin
            r = ($signed(a) < $signed(b))? 32'd1 : 32'd0;
            flag = ($signed(a) < $signed(b));
        end
        SLTU: begin
            r = (a < b)? 32'd1 : 32'd0;
            flag = (a < b);
        end
        default: r = 32'bx;
    endcase

    zero = (r == 32'd0);
    negative = r[31];
    carry = (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU);
    flag = (aluc == SLT || aluc == SLTU)? flag : 1'bx;
end

endmodule