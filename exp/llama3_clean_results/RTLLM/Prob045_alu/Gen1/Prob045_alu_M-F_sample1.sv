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
reg flag_reg;

assign r = res;
assign flag = flag_reg;

always @(a, b, aluc) begin
    case (aluc)
        ADD: begin
            res = a + b;
            flag_reg = 1'b0;
        end
        ADDU: begin
            res = a + b;
            flag_reg = 1'b0;
        end
        SUB: begin
            res = a - b;
            flag_reg = 1'b0;
        end
        SUBU: begin
            res = a - b;
            flag_reg = 1'b0;
        end
        AND: begin
            res = a & b;
            flag_reg = 1'b0;
        end
        OR: begin
            res = a | b;
            flag_reg = 1'b0;
        end
        XOR: begin
            res = a ^ b;
            flag_reg = 1'b0;
        end
        NOR: begin
            res = ~(a | b);
            flag_reg = 1'b0;
        end
        SLT: begin
            if (signed'(a) < signed'(b)) begin
                res = 32'd1;
            end else begin
                res = 32'd0;
            end
            flag_reg = 1'b1;
        end
        SLTU: begin
            if (a < b) begin
                res = 32'd1;
            end else begin
                res = 32'd0;
            end
            flag_reg = 1'b1;
        end
        SLL: begin
            res = a << a[4:0];
            flag_reg = 1'b0;
        end
        SRL: begin
            res = a >> a[4:0];
            flag_reg = 1'b0;
        end
        SRA: begin
            res = signed'(a) >>> a[4:0];
            flag_reg = 1'b0;
        end
        SLLV: begin
            res = a << b[4:0];
            flag_reg = 1'b0;
        end
        SRLV: begin
            res = a >> b[4:0];
            flag_reg = 1'b0;
        end
        SRAV: begin
            res = signed'(a) >>> b[4:0];
            flag_reg = 1'b0;
        end
        LUI: begin
            res = {a[15:0], 16'd0};
            flag_reg = 1'b0;
        end
        default: begin
            res = 32'bz;
            flag_reg = 1'bz;
        end
    endcase
end

assign zero = (res == 32'd0) ? 1'b1 : 1'b0;
assign carry = (res[31] == 1'b1) ? 1'b1 : 1'b0;
assign negative = (res[31] == 1'b1) ? 1'b1 : 1'b0;
assign overflow = ((aluc == ADD || aluc == SUB) && (signed'(a)[31] == signed'(b)[31]) && (signed'(a)[31] != res[31])) ? 1'b1 : 1'b0;

endmodule