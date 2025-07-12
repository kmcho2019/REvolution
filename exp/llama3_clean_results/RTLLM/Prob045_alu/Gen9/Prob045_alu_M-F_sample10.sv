module alu(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output [31:0] r,
    output zero,
    output carry,
    output negative,
    output overflow,
    output flag
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

// Assign result and calculate flags
logic [31:0] res;
logic z, c, n, o, f;

always_comb begin
    case (aluc)
        ADD, ADDU: res = a + b;
        SUB, SUBU: res = a - b;
        AND: res = a & b;
        OR: res = a | b;
        XOR: res = a ^ b;
        NOR: res = ~(a | b);
        SLL: res = a << b[4:0];
        SRL: res = a >> b[4:0];
        SRA: res = a >>> b[4:0];
        LUI: res = {16'b0, a[15:0]};
        default: res = 32'bx;
    endcase

    // Calculate flags
    z = (res == 32'd0);
    c = ((aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU) && (res[31] == 1'b1)) ? 1'b1 : 1'b0;
    n = (res[31] == 1'b1);
    o = ((aluc == ADD || aluc == SUB) && (a[31] != b[31]) && (a[31] != res[31])) ? 1'b1 : 1'b0;
    f = ((aluc == SLT && $signed(a) < $signed(b)) || (aluc == SLTU && a < b)) ? 1'b1 : 1'b0;

    // Assign outputs
    r = res;
    zero = z;
    carry = c;
    negative = n;
    overflow = o;
    flag = f;
end

endmodule