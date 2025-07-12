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

reg [31:0] result;
always @(*) begin
    case (aluc)
        ADD, ADDU: result = a + b;
        SUB, SUBU: result = a - b;
        AND: result = a & b;
        OR: result = a | b;
        XOR: result = a ^ b;
        NOR: result = ~(a | b);
        SLT: result = (signed'(a) < signed'(b))? 32'd1 : 32'd0;
        SLTU: result = (a < b)? 32'd1 : 32'd0;
        SLL: result = a << b[4:0];
        SRL: result = a >> b[4:0];
        SRA: result = a >>> b[4:0];
        SLLV: result = a << a[4:0];
        SRLV: result = a >> a[4:0];
        SRAV: result = a >>> a[4:0];
        LUI: result = {a[15:0], 16'd0};
        default: result = 32'bx;
    endcase
end

always @(*) begin
    zero = (result == 32'd0);
    carry = (a[31]!= b[31]) && (a[31]!= result[31]);
    negative = result[31];
    overflow = (a[31]!= b[31]) && (a[31]!= result[31]);
    flag = (aluc == SLT || aluc == SLTU)? (result!= 0) : 1'b0;
end

assign r = result;

endmodule