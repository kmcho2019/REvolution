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

reg [31:0] res;
reg [31:0] sa;
reg [31:0] sb;

assign sa = a;
assign sb = b;

always @(a, b, aluc) begin
    case(aluc)
        ADD: begin
            {carry, res} = sa + sb;
        end
        ADDU: begin
            res = sa + sb;
            if (res < sa) begin
                overflow = 1'b1;
            end else begin
                overflow = 1'b0;
            end
        end
        SUB: begin
            {carry, res} = sa - sb;
        end
        SUBU: begin
            res = sa - sb;
            if (res < 0) begin
                overflow = 1'b1;
            end else begin
                overflow = 1'b0;
            end
        end
        AND: begin
            res = sa & sb;
        end
        OR: begin
            res = sa | sb;
        end
        XOR: begin
            res = sa ^ sb;
        end
        NOR: begin
            res = ~(sa | sb);
        end
        SLT: begin
            if (sa < sb) begin
                res = 1;
            end else begin
                res = 0;
            end
        end
        SLTU: begin
            if (sa < sb) begin
                res = 1;
            end else begin
                res = 0;
            end
        end
        SLL: begin
            res = sa << b[4:0];
        end
        SRL: begin
            res = sa >> b[4:0];
        end
        SRA: begin
            res = sa >>> b[4:0];
        end
        SLLV: begin
            res = sa << a[4:0];
        end
        SRLV: begin
            res = sa >> a[4:0];
        end
        SRAV: begin
            res = sa >>> a[4:0];
        end
        LUI: begin
            res = {b[15:0], 16'b0};
        end
        default: begin
            res = 32'bz;
        end
    endcase
end

assign r = res;
assign zero = (res == 0) ? 1'b1 : 1'b0;
assign negative = (res[31] == 1'b1) ? 1'b1 : 1'b0;
assign flag = (aluc == SLT || aluc == SLTU) ? (res[0] == 1'b1) : 1'bz;

endmodule