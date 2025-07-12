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
reg zero_reg;
reg carry_reg;
reg negative_reg;
reg overflow_reg;
reg flag_reg;

assign r = res;
assign zero = zero_reg;
assign carry = carry_reg;
assign negative = negative_reg;
assign overflow = overflow_reg;
assign flag = flag_reg;

always @(*) begin
    case(aluc)
        ADD: begin
            {carry_reg, res} = a + b;
            overflow_reg = (a[31] == b[31] && b[31]!= res[31]);
        end
        ADDU: begin
            {carry_reg, res} = a + b;
        end
        SUB: begin
            {carry_reg, res} = a - b;
            overflow_reg = (a[31]!= b[31] && b[31] == res[31]);
        end
        SUBU: begin
            {carry_reg, res} = a - b;
        end
        AND: res = a & b;
        OR: res = a | b;
        XOR: res = a ^ b;
        NOR: res = ~(a | b);
        SLT: begin
            flag_reg = (signed'(a) < signed'(b));
            res = 0;
        end
        SLTU: begin
            flag_reg = (a < b);
            res = 0;
        end
        SLL: res = a << b[4:0];
        SRL: res = a >> b[4:0];
        SRA: res = a >>> b[4:0];
        SLLV: res = a << a[4:0];
        SRLV: res = a >> a[4:0];
        SRAV: res = a >>> a[4:0];
        LUI: res = {a[15:0], 16'b0};
        default: begin
            res = 32'bz;
            flag_reg = 1'bz;
        end
    endcase
    
    zero_reg = (res == 0);
    negative_reg = res[31];
end

endmodule