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

reg [31:0] res;
reg zero_reg, carry_reg, negative_reg, overflow_reg, flag_reg;

always @(*) begin
    case (aluc)
        ADD: begin
            {carry_reg, res} = a + b;
            overflow_reg = (a[31] == b[31]) && (a[31]!= res[31]);
        end
        ADDU: begin
            {carry_reg, res} = a + b;
        end
        SUB: begin
            {carry_reg, res} = a - b;
            overflow_reg = (a[31]!= b[31]) && (a[31]!= res[31]);
        end
        SUBU: begin
            {carry_reg, res} = a - b;
        end
        AND: begin
            res = a & b;
            carry_reg = 0;
            overflow_reg = 0;
        end
        OR: begin
            res = a | b;
            carry_reg = 0;
            overflow_reg = 0;
        end
        XOR: begin
            res = a ^ b;
            carry_reg = 0;
            overflow_reg = 0;
        end
        NOR: begin
            res = ~(a | b);
            carry_reg = 0;
            overflow_reg = 0;
        end
        SLT: begin
            res = (signed'(a) < signed'(b))? 32'd1 : 32'd0;
            carry_reg = 0;
            overflow_reg = 0;
            flag_reg = res[0];
        end
        SLTU: begin
            res = (a < b)? 32'd1 : 32'd0;
            carry_reg = 0;
            overflow_reg = 0;
            flag_reg = res[0];
        end
        SLL: begin
            res = a << b[4:0];
            carry_reg = 0;
            overflow_reg = 0;
        end
        SRL: begin
            res = a >> b[4:0];
            carry_reg = 0;
            overflow_reg = 0;
        end
        SRA: begin
            res = a >>> b[4:0];
            carry_reg = 0;
            overflow_reg = 0;
        end
        SLLV: begin
            res = a << b[4:0];
            carry_reg = 0;
            overflow_reg = 0;
        end
        SRLV: begin
            res = a >> b[4:0];
            carry_reg = 0;
            overflow_reg = 0;
        end
        SRAV: begin
            res = a >>> b[4:0];
            carry_reg = 0;
            overflow_reg = 0;
        end
        LUI: begin
            res = {a[15:0], 16'd0};
            carry_reg = 0;
            overflow_reg = 0;
        end
        default: begin
            res = 32'd0;
            carry_reg = 0;
            overflow_reg = 0;
            flag_reg = 0;
        end
    endcase

    zero_reg = (res == 32'd0);
    negative_reg = res[31];
end

assign r = res;
assign zero = zero_reg;
assign carry = carry_reg;
assign negative = negative_reg;
assign overflow = overflow_reg;
assign flag = flag_reg;

endmodule