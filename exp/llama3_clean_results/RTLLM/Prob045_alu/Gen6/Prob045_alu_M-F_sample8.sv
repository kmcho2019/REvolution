module alu(
    input wire [31:0] a,
    input wire [31:0] b,
    input wire [5:0] aluc,
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

reg [31:0] result;
reg [31:0] bitwise_result;
reg [31:0] arithmetic_result;
reg [31:0] shift_result;

always @(*) begin
    // Bitwise Operations Module
    case (aluc)
        AND: bitwise_result = a & b;
        OR: bitwise_result = a | b;
        XOR: bitwise_result = a ^ b;
        NOR: bitwise_result = ~(a | b);
        default: bitwise_result = 32'd0;
    endcase

    // Arithmetic Circuits Module
    case (aluc)
        ADD: arithmetic_result = a + b;
        ADDU: arithmetic_result = a + b;
        SUB: arithmetic_result = a - b;
        SUBU: arithmetic_result = a - b;
        default: arithmetic_result = 32'd0;
    endcase

    // Shift Operations Module
    case (aluc)
        SLL: shift_result = a << b[4:0];
        SRL: shift_result = a >> b[4:0];
        SRA: shift_result = a >>> b[4:0];
        SLLV: shift_result = a << a[4:0];
        SRLV: shift_result = a >> a[4:0];
        SRAV: shift_result = a >>> a[4:0];
        default: shift_result = 32'd0;
    endcase

    // LUI Operation
    case (aluc)
        LUI: result = {a[15:0], 16'd0};
        default: result = 32'd0;
    endcase

    // Mux for result
    case (aluc)
        AND, OR, XOR, NOR: r = bitwise_result;
        ADD, ADDU, SUB, SUBU: r = arithmetic_result;
        SLL, SRL, SRA, SLLV, SRLV, SRAV: r = shift_result;
        LUI: r = {a[15:0], 16'd0};
        default: r = 32'd0;
    endcase

    // Flag Generation Unit
    zero = (r == 32'd0);
    carry = (aluc == ADD) ? (a[31] != b[31] && r[31] != a[31]) :
             (aluc == ADDU) ? (r[31] == 1'b1) : 1'b0;
    negative = r[31];
    overflow = (aluc == ADD) ? (a[31] != b[31] && r[31] != a[31]) :
                (aluc == SUB) ? (a[31] == b[31] && r[31] != a[31]) : 1'b0;
    flag = (aluc == SLT) ? (signed'(a) < signed'(b)) :
           (aluc == SLTU) ? (a < b) : 1'b0;
end

endmodule