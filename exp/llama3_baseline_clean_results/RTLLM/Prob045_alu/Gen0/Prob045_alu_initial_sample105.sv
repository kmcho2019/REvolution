module alu(
    input  [31:0] a, b,
    input  [5:0] aluc,
    output [31:0] r,
    output       zero, carry, negative, overflow, flag
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
reg        flag_reg;

always @(*) begin
    case (aluc)
        ADD: begin
            res = a + b;
            flag_reg = 0;
        end
        ADDU: begin
            res = a + b;
            flag_reg = 0;
        end
        SUB: begin
            res = a - b;
            flag_reg = 0;
        end
        SUBU: begin
            res = a - b;
            flag_reg = 0;
        end
        AND: begin
            res = a & b;
            flag_reg = 0;
        end
        OR: begin
            res = a | b;
            flag_reg = 0;
        end
        XOR: begin
            res = a ^ b;
            flag_reg = 0;
        end
        NOR: begin
            res = ~(a | b);
            flag_reg = 0;
        end
        SLT: begin
            res = {31'b0, (signed'(a) < signed'(b))};
            flag_reg = (signed'(a) < signed'(b));
        end
        SLTU: begin
            res = {31'b0, (a < b)};
            flag_reg = (a < b);
        end
        SLL: begin
            res = a << b[4:0];
            flag_reg = 0;
        end
        SRL: begin
            res = a >> b[4:0];
            flag_reg = 0;
        end
        SRA: begin
            res = a >>> b[4:0];
            flag_reg = 0;
        end
        SLLV: begin
            res = a << a[4:0];
            flag_reg = 0;
        end
        SRLV: begin
            res = a >> a[4:0];
            flag_reg = 0;
        end
        SRAV: begin
            res = a >>> a[4:0];
            flag_reg = 0;
        end
        LUI: begin
            res = {b[15:0], 16'b0};
            flag_reg = 0;
        end
        default: begin
            res = 32'bz;
            flag_reg = 0;
        end
    endcase
end

assign r = res;
assign zero = (res == 32'b0);
assign carry = (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU) && ((a[31] == b[31] && res[31] != a[31]) || (a[31] != b[31] && !res[31]));
assign negative = res[31];
assign overflow = (aluc == ADD || aluc == SUB) && ((a[31] == b[31] && res[31] != a[31]));
assign flag = flag_reg;

endmodule