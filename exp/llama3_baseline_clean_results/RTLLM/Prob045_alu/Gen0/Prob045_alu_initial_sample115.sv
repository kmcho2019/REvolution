module alu(
    input  [31:0] a, 
    input  [31:0] b, 
    input  [5:0]  aluc,
    output [31:0] r,
    output        zero,
    output        carry,
    output        negative,
    output        overflow,
    output        flag
);

parameter ADD  = 6'b100000;
parameter ADDU = 6'b100001;
parameter SUB  = 6'b100010;
parameter SUBU = 6'b100011;
parameter AND  = 6'b100100;
parameter OR   = 6'b100101;
parameter XOR  = 6'b100110;
parameter NOR  = 6'b100111;
parameter SLT  = 6'b101010;
parameter SLTU = 6'b101011;
parameter SLL  = 6'b000000;
parameter SRL  = 6'b000010;
parameter SRA  = 6'b000011;
parameter SLLV = 6'b000100;
parameter SRLV = 6'b000110;
parameter SRAV = 6'b000111;
parameter LUI  = 6'b001111;

reg [31:0] res;
reg         zero_reg, carry_reg, negative_reg, overflow_reg, flag_reg;

always @(a or b or aluc) begin
    case (aluc)
        ADD:  begin
            {carry_reg, res} = a + b;
            zero_reg = (res == 32'b0);
            negative_reg = res[31];
            overflow_reg = (a[31] == b[31] && a[31] != res[31]);
            flag_reg = 0;
        end
        ADDU: begin
            {carry_reg, res} = a + b;
            zero_reg = (res == 32'b0);
            negative_reg = res[31];
            overflow_reg = 0;
            flag_reg = 0;
        end
        SUB:  begin
            {carry_reg, res} = a - b;
            zero_reg = (res == 32'b0);
            negative_reg = res[31];
            overflow_reg = (a[31] != b[31] && a[31] != res[31]);
            flag_reg = 0;
        end
        SUBU: begin
            {carry_reg, res} = a - b;
            zero_reg = (res == 32'b0);
            negative_reg = res[31];
            overflow_reg = 0;
            flag_reg = 0;
        end
        AND:  begin
            res = a & b;
            zero_reg = (res == 32'b0);
            negative_reg = res[31];
            overflow_reg = 0;
            carry_reg = 0;
            flag_reg = 0;
        end
        OR:   begin
            res = a | b;
            zero_reg = (res == 32'b0);
            negative_reg = res[31];
            overflow_reg = 0;
            carry_reg = 0;
            flag_reg = 0;
        end
        XOR:  begin
            res = a ^ b;
            zero_reg = (res == 32'b0);
            negative_reg = res[31];
            overflow_reg = 0;
            carry_reg = 0;
            flag_reg = 0;
        end
        NOR:  begin
            res = ~(a | b);
            zero_reg = (res == 32'b0);
            negative_reg = res[31];
            overflow_reg = 0;
            carry_reg = 0;
            flag_reg = 0;
        end
        SLT:  begin
            res = (a < b) ? 32'b1 : 32'b0;
            zero_reg = (res == 32'b0);
            negative_reg = res[31];
            overflow_reg = 0;
            carry_reg = 0;
            flag_reg = (a < b);
        end
        SLTU: begin
            res = ({32{1'b0}, a} < {32{1'b0}, b}) ? 32'b1 : 32'b0;
            zero_reg = (res == 32'b0);
            negative_reg = res[31];
            overflow_reg = 0;
            carry_reg = 0;
            flag_reg = ({32{1'b0}, a} < {32{1'b0}, b});
        end
        SLL:  begin
            res = a << b[4:0];
            zero_reg = (res == 32'b0);
            negative_reg = res[31];
            overflow_reg = 0;
            carry_reg = 0;
            flag_reg = 0;
        end
        SRL:  begin
            res = a >> b[4:0];
            zero_reg = (res == 32'b0);
            negative_reg = res[31];
            overflow_reg = 0;
            carry_reg = 0;
            flag_reg = 0;
        end
        SRA:  begin
            res = {a[31], a} >>> b[4:0];
            zero_reg = (res == 32'b0);
            negative_reg = res[31];
            overflow_reg = 0;
            carry_reg = 0;
            flag_reg = 0;
        end
        SLLV: begin
            res = a << b;
            zero_reg = (res == 32'b0);
            negative_reg = res[31];
            overflow_reg = 0;
            carry_reg = 0;
            flag_reg = 0;
        end
        SRLV: begin
            res = a >> b;
            zero_reg = (res == 32'b0);
            negative_reg = res[31];
            overflow_reg = 0;
            carry_reg = 0;
            flag_reg = 0;
        end
        SRAV: begin
            res = {a[31], a} >>> b;
            zero_reg = (res == 32'b0);
            negative_reg = res[31];
            overflow_reg = 0;
            carry_reg = 0;
            flag_reg = 0;
        end
        LUI:  begin
            res = {b[15:0], 16'b0};
            zero_reg = (res == 32'b0);
            negative_reg = res[31];
            overflow_reg = 0;
            carry_reg = 0;
            flag_reg = 0;
        end
        default: begin
            res = 32'bz;
            zero_reg = 0;
            negative_reg = 0;
            overflow_reg = 0;
            carry_reg = 0;
            flag_reg = 0;
        end
    endcase
end

assign r = res;
assign zero = zero_reg;
assign carry = carry_reg;
assign negative = negative_reg;
assign overflow = overflow_reg;
assign flag = flag_reg;

endmodule