module alu(
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [5:0] aluc,
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

wire [31:0] res;

assign r = res;
assign zero = (res == 32'd0);
assign negative = res[31];
assign carry = (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU) && (res[31] != a[31] && res[31] != b[31]);
assign overflow = (aluc == ADD || aluc == SUB) && (a[31] == b[31]) && (a[31] != res[31]);
assign flag = (aluc == SLT) ? (signed'(a) < signed'(b)) : (aluc == SLTU) ? (a < b) : 1'bz;

always @(a, b, aluc) begin
    case (aluc)
        ADD: res = a + b;
        ADDU: res = {32{1'b0}} + a + b;
        SUB: res = a - b;
        SUBU: res = {32{1'b0}} + a - b;
        AND: res = a & b;
        OR: res = a | b;
        XOR: res = a ^ b;
        NOR: res = ~(a | b);
        SLT: res = (signed'(a) < signed'(b)) ? 32'd1 : 32'd0;
        SLTU: res = (a < b) ? 32'd1 : 32'd0;
        SLL: res = a << b[4:0];
        SRL: res = a >> b[4:0];
        SRA: res = $signed(a) >>> b[4:0];
        SLLV: res = a << b;
        SRLV: res = a >> b;
        SRAV: res = $signed(a) >>> b;
        LUI: res = {16'b0, a[15:0]};
        default: res = 32'bz;
    endcase
end

endmodule