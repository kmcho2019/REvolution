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
reg zero_reg;
reg carry_reg;
reg negative_reg;
reg overflow_reg;
reg flag_reg;

always @(*) begin
    case (aluc)
        ADD: begin
            {carry_reg, result} = {a[31], a} + {b[31], b};
            overflow_reg = (a[31] == b[31] && result[31] != a[31]);
        end
        ADDU: begin
            {carry_reg, result} = a + b;
            overflow_reg = 1'b0; // No overflow in unsigned addition
        end
        SUB: begin
            {carry_reg, result} = {a[31], a} - {b[31], b};
            overflow_reg = (a[31] != b[31] && result[31] != a[31]);
        end
        SUBU: begin
            {carry_reg, result} = a - b;
            overflow_reg = 1'b0; // No overflow in unsigned subtraction
        end
        AND: result = a & b;
        OR: result = a | b;
        XOR: result = a ^ b;
        NOR: result = ~(a | b);
        SLT: result = (signed'(a) < signed'(b)) ? 32'h1 : 32'h0;
        SLTU: result = (a < b) ? 32'h1 : 32'h0;
        SLL: result = a << b[4:0];
        SRL: result = a >> b[4:0];
        SRA: result = a >>> b[4:0];
        SLLV: result = a << a[4:0];
        SRLV: result = a >> a[4:0];
        SRAV: result = a >>> a[4:0];
        LUI: result = {16'd0, b[15:0]};
        default: result = 32'bz;
    endcase
    zero_reg = (result == 32'h0);
    negative_reg = result[31];
    flag_reg = (aluc == SLT || aluc == SLTU) ? result[0] : 1'b0;
end

assign r = result;
assign zero = zero_reg;
assign carry = carry_reg;
assign negative = negative_reg;
assign overflow = overflow_reg;
assign flag = flag_reg;

endmodule