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
reg z, c, n, o, f;

always @(*) begin
    case (aluc)
        ADD, ADDU: begin
            {c, result} = a + b;
            o = (a[31] == b[31] && result[31] != a[31]);
        end
        SUB, SUBU: begin
            {c, result} = a - b;
            o = (a[31] != b[31] && result[31] != a[31]);
        end
        AND: begin
            result = a & b;
            c = 1'b0;
            o = 1'b0;
        end
        OR: begin
            result = a | b;
            c = 1'b0;
            o = 1'b0;
        end
        XOR: begin
            result = a ^ b;
            c = 1'b0;
            o = 1'b0;
        end
        NOR: begin
            result = ~(a | b);
            c = 1'b0;
            o = 1'b0;
        end
        SLT: begin
            result = (signed'(a) < signed'(b))? 32'h1 : 32'h0;
            c = 1'b0;
            o = 1'b0;
            f = result[0];
        end
        SLTU: begin
            result = (a < b)? 32'h1 : 32'h0;
            c = 1'b0;
            o = 1'b0;
            f = result[0];
        end
        SLL: result = a << b[4:0];
        SRL: result = a >> b[4:0];
        SRA: result = a >>> b[4:0];
        SLLV: result = a << a[4:0];
        SRLV: result = a >> a[4:0];
        SRAV: result = a >>> a[4:0];
        LUI: begin
            result = {16'd0, a[15:0]};
            c = 1'b0;
            o = 1'b0;
        end
        default: result = 32'bz;
    endcase
    z = (result == 32'h0);
    n = result[31];
    if (aluc != SLT && aluc != SLTU) begin
        f = 1'b0;
    end
end

assign r = result;
assign zero = z;
assign carry = c;
assign negative = n;
assign overflow = o;
assign flag = f;

endmodule