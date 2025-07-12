module alu(
    input wire [31:0] a,
    input wire [31:0] b,
    input wire [5:0] aluc,
    output wire [31:0] r,
    output wire zero,
    output wire carry,
    output wire negative,
    output wire overflow,
    output wire flag
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
        ADD: r = a + b;
        ADDU: r = {32'd0} + a + b;
        SUB: r = a - b;
        SUBU: r = {32'd0} + a - b;
        AND: r = a & b;
        OR: r = a | b;
        XOR: r = a ^ b;
        NOR: r = ~(a | b);
        SLT: r = {31'd0, (a[31] == 1 && b[31] == 0) || (a[31] == 1 && b[31] == 1 && a < b) || (a[31] == 0 && b[31] == 1)};
        SLTU: r = {31'd0, a < b};
        SLL: r = a << b[4:0];
        SRL: r = a >> b[4:0];
        SRA: r = a >>> b[4:0];
        SLLV: r = a << a[4:0];
        SRLV: r = a >> a[4:0];
        SRAV: r = a >>> a[4:0];
        LUI: r = {a[15:0], 16'd0};
        default: r = 32'bz;
    endcase
    
    zero = (r == 0);
    carry = (aluc == ADD) ? (a[31] == b[31] && a[31] != r[31]) : 0;
    negative = r[31];
    overflow = (aluc == ADD) ? (a[31] == b[31] && a[31] != r[31]) : 0;
    flag = (aluc == SLT) ? (a < b) : (aluc == SLTU) ? (a < b) : 0;
end

endmodule