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

wire [31:0] result;
wire zero_result;
wire carry_result;
wire negative_result;
wire overflow_result;
wire flag_result;

assign r = result;
assign zero = zero_result;
assign carry = carry_result;
assign negative = negative_result;
assign overflow = overflow_result;
assign flag = flag_result;

always @(*) begin
    case (aluc)
        ADD, ADDU: begin
            {carry_result, result} = a + b;
            overflow_result = (a[31] == b[31] && result[31]!= a[31]);
            zero_result = (result == 32'h0);
            negative_result = result[31];
            flag_result = 1'b0;
        end
        SUB, SUBU: begin
            {carry_result, result} = a - b;
            overflow_result = (a[31]!= b[31] && result[31]!= a[31]);
            zero_result = (result == 32'h0);
            negative_result = result[31];
            flag_result = 1'b0;
        end
        AND: begin
            result = a & b;
            carry_result = 1'b0;
            overflow_result = 1'b0;
            zero_result = (result == 32'h0);
            negative_result = result[31];
            flag_result = 1'b0;
        end
        OR: begin
            result = a | b;
            carry_result = 1'b0;
            overflow_result = 1'b0;
            zero_result = (result == 32'h0);
            negative_result = result[31];
            flag_result = 1'b0;
        end
        XOR: begin
            result = a ^ b;
            carry_result = 1'b0;
            overflow_result = 1'b0;
            zero_result = (result == 32'h0);
            negative_result = result[31];
            flag_result = 1'b0;
        end
        NOR: begin
            result = ~(a | b);
            carry_result = 1'b0;
            overflow_result = 1'b0;
            zero_result = (result == 32'h0);
            negative_result = result[31];
            flag_result = 1'b0;
        end
        SLT: begin
            result = (signed'(a) < signed'(b))? 32'h1 : 32'h0;
            flag_result = result[0];
            carry_result = 1'b0;
            overflow_result = 1'b0;
            zero_result = (result == 32'h0);
            negative_result = result[31];
        end
        SLTU: begin
            result = (a < b)? 32'h1 : 32'h0;
            flag_result = result[0];
            carry_result = 1'b0;
            overflow_result = 1'b0;
            zero_result = (result == 32'h0);
            negative_result = result[31];
        end
        SLL: begin
            result = a << b[4:0];
            carry_result = 1'b0;
            overflow_result = 1'b0;
            zero_result = (result == 32'h0);
            negative_result = result[31];
            flag_result = 1'b0;
        end
        SRL: begin
            result = a >> b[4:0];
            carry_result = 1'b0;
            overflow_result = 1'b0;
            zero_result = (result == 32'h0);
            negative_result = result[31];
            flag_result = 1'b0;
        end
        SRA: begin
            result = a >>> b[4:0];
            carry_result = 1'b0;
            overflow_result = 1'b0;
            zero_result = (result == 32'h0);
            negative_result = result[31];
            flag_result = 1'b0;
        end
        SLLV: begin
            result = a << a[4:0];
            carry_result = 1'b0;
            overflow_result = 1'b0;
            zero_result = (result == 32'h0);
            negative_result = result[31];
            flag_result = 1'b0;
        end
        SRLV: begin
            result = a >> a[4:0];
            carry_result = 1'b0;
            overflow_result = 1'b0;
            zero_result = (result == 32'h0);
            negative_result = result[31];
            flag_result = 1'b0;
        end
        SRAV: begin
            result = a >>> a[4:0];
            carry_result = 1'b0;
            overflow_result = 1'b0;
            zero_result = (result == 32'h0);
            negative_result = result[31];
            flag_result = 1'b0;
        end
        LUI: begin
            result = {16'd0, a[15:0]};
            carry_result = 1'b0;
            overflow_result = 1'b0;
            zero_result = (result == 32'h0);
            negative_result = result[31];
            flag_result = 1'b0;
        end
        default: begin
            result = 32'h0;
            carry_result = 1'b0;
            overflow_result = 1'b0;
            zero_result = 1'b1;
            negative_result = 1'b0;
            flag_result = 1'b0;
        end
    endcase
end

endmodule