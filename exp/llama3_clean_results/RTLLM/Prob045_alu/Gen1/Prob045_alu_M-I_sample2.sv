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
reg zero_reg, carry_reg, negative_reg, overflow_reg, flag_reg;

// Common logic for zero, negative, and overflow detection
function [31:0] calculate_flags(input [31:0] result, input signed [31:0] a, input signed [31:0] b);
    calculate_flags[31] = (result == 32'd0);
    calculate_flags[30] = (result[31] == 1'b1);
    calculate_flags[29] = (a[31] == b[31] && b[31] != result[31]);
    calculate_flags[28] = (a[31] != b[31] && b[31] == result[31]);
endfunction

// Area-efficient implementation for shift operations using multiplexers
function [31:0] barrel_shifter(input [31:0] a, input [4:0] shift_amount, input [1:0] operation);
    case (operation)
        2'b00: barrel_shifter = a << shift_amount;
        2'b01: barrel_shifter = a >> shift_amount;
        2'b10: barrel_shifter = a >>> shift_amount;
        default: barrel_shifter = 32'd0;
    endcase
endfunction

always @(*) begin
    case(aluc)
        ADD, ADDU: begin
            res = a + b;
            {carry_reg, res} = a + b;
            {zero_reg, negative_reg, overflow_reg} = calculate_flags(res, a, b);
            flag_reg = 1'b0;
        end
        SUB, SUBU: begin
            res = a - b;
            {carry_reg, res} = a - b;
            {zero_reg, negative_reg, overflow_reg} = calculate_flags(res, a, b);
            flag_reg = 1'b0;
        end
        AND: begin
            res = a & b;
            zero_reg = (res == 32'd0);
            negative_reg = (res[31] == 1'b1);
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
            flag_reg = 1'b0;
        end
        OR: begin
            res = a | b;
            zero_reg = (res == 32'd0);
            negative_reg = (res[31] == 1'b1);
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
            flag_reg = 1'b0;
        end
        XOR: begin
            res = a ^ b;
            zero_reg = (res == 32'd0);
            negative_reg = (res[31] == 1'b1);
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
            flag_reg = 1'b0;
        end
        NOR: begin
            res = ~(a | b);
            zero_reg = (res == 32'd0);
            negative_reg = (res[31] == 1'b1);
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
            flag_reg = 1'b0;
        end
        SLT: begin
            res = (a < b)? 32'd1 : 32'd0;
            zero_reg = (res == 32'd0);
            negative_reg = (res[31] == 1'b1);
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
            flag_reg = (a < b)? 1'b1 : 1'b0;
        end
        SLTU: begin
            res = (a < b)? 32'd1 : 32'd0;
            zero_reg = (res == 32'd0);
            negative_reg = (res[31] == 1'b1);
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
            flag_reg = (a < b)? 1'b1 : 1'b0;
        end
        SLL, SLLV: begin
            res = barrel_shifter(a, b[4:0], 2'b00);
            zero_reg = (res == 32'd0);
            negative_reg = (res[31] == 1'b1);
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
            flag_reg = 1'b0;
        end
        SRL, SRLV: begin
            res = barrel_shifter(a, b[4:0], 2'b01);
            zero_reg = (res == 32'd0);
            negative_reg = (res[31] == 1'b1);
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
            flag_reg = 1'b0;
        end
        SRA, SRAV: begin
            res = barrel_shifter(a, b[4:0], 2'b10);
            zero_reg = (res == 32'd0);
            negative_reg = (res[31] == 1'b1);
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
            flag_reg = 1'b0;
        end
        LUI: begin
            res = {a[15:0], 16'd0};
            zero_reg = (res == 32'd0);
            negative_reg = (res[31] == 1'b1);
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
            flag_reg = 1'b0;
        end
        default: begin
            res = 32'bz;
            zero_reg = 1'bz;
            carry_reg = 1'bz;
            negative_reg = 1'bz;
            overflow_reg = 1'bz;
            flag_reg = 1'bz;
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