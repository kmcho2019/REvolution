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
parameter SUB = 6'b100010;
parameter ADDU = 6'b100001;
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

// Decoding and operation logic
always @(*) begin
    case (aluc)
        ADD: begin
            {carry, r} = a + b;
            overflow = (a[31] == b[31]) && (a[31] != r[31]);
        end
        SUB: begin
            {carry, r} = a - b;
            overflow = (a[31] != b[31]) && (a[31] != r[31]);
        end
        ADDU: begin
            {carry, r} = a + b;
            overflow = 1'b0;
        end
        SUBU: begin
            {carry, r} = a - b;
            overflow = 1'b0;
        end
        AND: r = a & b;
        OR: r = a | b;
        XOR: r = a ^ b;
        NOR: r = ~(a | b);
        SLT: begin
            r = (signed'(a) < signed'(b))? 32'd1 : 32'd0;
            flag = (signed'(a) < signed'(b));
        end
        SLTU: begin
            r = (a < b)? 32'd1 : 32'd0;
            flag = (a < b);
        end
        SLL: r = a << b[4:0];
        SRL: r = a >> b[4:0];
        SRA: r = a >>> b[4:0];
        SLLV: r = a << a[4:0];
        SRLV: r = a >> a[4:0];
        SRAV: r = a >>> a[4:0];
        LUI: r = {b[15:0], 16'd0};
        default: begin
            r = 32'bx;
            carry = 1'bx;
            overflow = 1'bx;
            flag = 1'bx;
        end
    endcase
end

// Output flags
assign zero = (r == 32'd0);
assign negative = (r[31] == 1'b1);

endmodule