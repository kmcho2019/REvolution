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

always @(a, b, aluc) begin
    case (aluc)
        ADD: begin
            {carry_reg, result} = a + b;
            flag_reg = 1'b0;
            zero_reg = (result == 32'd0) ? 1'b1 : 1'b0;
            negative_reg = (result[31] == 1'b1) ? 1'b1 : 1'b0;
            overflow_reg = ((a[31] == b[31]) && (a[31] != result[31])) ? 1'b1 : 1'b0;
        end
        ADDU: begin
            {carry_reg, result} = a + b;
            flag_reg = 1'b0;
            zero_reg = (result == 32'd0) ? 1'b1 : 1'b0;
            negative_reg = (result[31] == 1'b1) ? 1'b1 : 1'b0;
            overflow_reg = 1'b0;
        end
        SUB: begin
            {carry_reg, result} = a - b;
            flag_reg = 1'b0;
            zero_reg = (result == 32'd0) ? 1'b1 : 1'b0;
            negative_reg = (result[31] == 1'b1) ? 1'b1 : 1'b0;
            overflow_reg = ((a[31] != b[31]) && (a[31] != result[31])) ? 1'b1 : 1'b0;
        end
        SUBU: begin
            {carry_reg, result} = a - b;
            flag_reg = 1'b0;
            zero_reg = (result == 32'd0) ? 1'b1 : 1'b0;
            negative_reg = (result[31] == 1'b1) ? 1'b1 : 1'b0;
            overflow_reg = 1'b0;
        end
        AND: begin
            result = a & b;
            flag_reg = 1'b0;
            zero_reg = (result == 32'd0) ? 1'b1 : 1'b0;
            negative_reg = (result[31] == 1'b1) ? 1'b1 : 1'b0;
            overflow_reg = 1'b0;
            carry_reg = 1'b0;
        end
        OR: begin
            result = a | b;
            flag_reg = 1'b0;
            zero_reg = (result == 32'd0) ? 1'b1 : 1'b0;
            negative_reg = (result[31] == 1'b1) ? 1'b1 : 1'b0;
            overflow_reg = 1'b0;
            carry_reg = 1'b0;
        end
        XOR: begin
            result = a ^ b;
            flag_reg = 1'b0;
            zero_reg = (result == 32'd0) ? 1'b1 : 1'b0;
            negative_reg = (result[31] == 1'b1) ? 1'b1 : 1'b0;
            overflow_reg = 1'b0;
            carry_reg = 1'b0;
        end
        NOR: begin
            result = ~(a | b);
            flag_reg = 1'b0;
            zero_reg = (result == 32'd0) ? 1'b1 : 1'b0;
            negative_reg = (result[31] == 1'b1) ? 1'b1 : 1'b0;
            overflow_reg = 1'b0;
            carry_reg = 1'b0;
        end
        SLT: begin
            if (a < b) begin
                result = 32'd1;
            end else begin
                result = 32'd0;
            end
            flag_reg = 1'b1;
            zero_reg = (result == 32'd0) ? 1'b1 : 1'b0;
            negative_reg = (result[31] == 1'b1) ? 1'b1 : 1'b0;
            overflow_reg = 1'b0;
            carry_reg = 1'b0;
        end
        SLTU: begin
            if (a < b) begin
                result = 32'd1;
            end else begin
                result = 32'd0;
            end
            flag_reg = 1'b1;
            zero_reg = (result == 32'd0) ? 1'b1 : 1'b0;
            negative_reg = (result[31] == 1'b1) ? 1'b1 : 1'b0;
            overflow_reg = 1'b0;
            carry_reg = 1'b0;
        end
        SLL: begin
            result = a << a[4:0];
            flag_reg = 1'b0;
            zero_reg = (result == 32'd0) ? 1'b1 : 1'b0;
            negative_reg = (result[31] == 1'b1) ? 1'b1 : 1'b0;
            overflow_reg = 1'b0;
            carry_reg = 1'b0;
        end
        SRL: begin
            result = a >> a[4:0];
            flag_reg = 1'b0;
            zero_reg = (result == 32'd0) ? 1'b1 : 1'b0;
            negative_reg = (result[31] == 1'b1) ? 1'b1 : 1'b0;
            overflow_reg = 1'b0;
            carry_reg = 1'b0;
        end
        SRA: begin
            result = a >>> a[4:0];
            flag_reg = 1'b0;
            zero_reg = (result == 32'd0) ? 1'b1 : 1'b0;
            negative_reg = (result[31] == 1'b1) ? 1'b1 : 1'b0;
            overflow_reg = 1'b0;
            carry_reg = 1'b0;
        end
        SLLV: begin
            result = a << b[4:0];
            flag_reg = 1'b0;
            zero_reg = (result == 32'd0) ? 1'b1 : 1'b0;
            negative_reg = (result[31] == 1'b1) ? 1'b1 : 1'b0;
            overflow_reg = 1'b0;
            carry_reg = 1'b0;
        end
        SRLV: begin
            result = a >> b[4:0];
            flag_reg = 1'b0;
            zero_reg = (result == 32'd0) ? 1'b1 : 1'b0;
            negative_reg = (result[31] == 1'b1) ? 1'b1 : 1'b0;
            overflow_reg = 1'b0;
            carry_reg = 1'b0;
        end
        SRAV: begin
            result = a >>> b[4:0];
            flag_reg = 1'b0;
            zero_reg = (result == 32'd0) ? 1'b1 : 1'b0;
            negative_reg = (result[31] == 1'b1) ? 1'b1 : 1'b0;
            overflow_reg = 1'b0;
            carry_reg = 1'b0;
        end
        LUI: begin
            result = {a[15:0], 16'd0};
            flag_reg = 1'b0;
            zero_reg = (result == 32'd0) ? 1'b1 : 1'b0;
            negative_reg = (result[31] == 1'b1) ? 1'b1 : 1'b0;
            overflow_reg = 1'b0;
            carry_reg = 1'b0;
        end
        default: begin
            result = 32'bx;
            flag_reg = 1'bx;
            zero_reg = 1'bx;
            negative_reg = 1'bx;
            overflow_reg = 1'bx;
            carry_reg = 1'bx;
        end
    endcase
end

assign r = result;
assign zero = zero_reg;
assign carry = carry_reg;
assign negative = negative_reg;
assign overflow = overflow_reg;
assign flag = flag_reg;

endmodule