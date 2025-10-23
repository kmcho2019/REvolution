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

// Define parameters for operations
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

// Instantiate arithmetic module
wire [31:0] arithmetic_result;
wire arithmetic_carry;
wire arithmetic_overflow;
arithmetic_module am(
    .a(a),
    .b(b),
    .aluc(aluc),
    .result(arithmetic_result),
    .carry(arithmetic_carry),
    .overflow(arithmetic_overflow)
);

// Instantiate logical module
wire [31:0] logical_result;
logical_module lm(
    .a(a),
    .b(b),
    .aluc(aluc),
    .result(logical_result)
);

// Instantiate shift and compare module
wire [31:0] shift_compare_result;
wire shift_compare_flag;
shift_compare_module scm(
    .a(a),
    .b(b),
    .aluc(aluc),
    .result(shift_compare_result),
    .flag(shift_compare_flag)
);

// Logic to select the appropriate module's result
always @(*) begin
    case (aluc)
        ADD, ADDU, SUB, SUBU: begin
            r = arithmetic_result;
            carry = arithmetic_carry;
            overflow = arithmetic_overflow;
        end
        AND, OR, XOR, NOR: begin
            r = logical_result;
            carry = 1'b0;
            overflow = 1'b0;
        end
        SLT, SLTU, SLL, SRL, SRA, SLLV, SRLV, SRAV: begin
            r = shift_compare_result;
            flag = shift_compare_flag;
            carry = 1'b0;
            overflow = 1'b0;
        end
        LUI: begin
            r = {16'd0, a[15:0]};
            carry = 1'b0;
            overflow = 1'b0;
        end
        default: begin
            r = 32'bz;
            carry = 1'b0;
            overflow = 1'b0;
        end
    endcase
end

// Assign zero, negative, and flag outputs
assign zero = (r == 32'h0);
assign negative = r[31];
assign flag = (aluc == SLT || aluc == SLTU)? shift_compare_flag : 1'b0;

endmodule

// Arithmetic Module
module arithmetic_module(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output [31:0] result,
    output carry,
    output overflow
);

// Perform arithmetic operations
always @(*) begin
    case (aluc)
        ADD: begin
            {carry, result} = a + b;
            overflow = (a[31] == b[31] && result[31]!= a[31]);
        end
        ADDU: begin
            {carry, result} = a + b;
            overflow = 1'b0;
        end
        SUB: begin
            {carry, result} = a - b;
            overflow = (a[31]!= b[31] && result[31]!= a[31]);
        end
        SUBU: begin
            {carry, result} = a - b;
            overflow = 1'b0;
        end
        default: begin
            result = 32'bz;
            carry = 1'b0;
            overflow = 1'b0;
        end
    endcase
end

endmodule

// Logical Module
module logical_module(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output [31:0] result
);

// Perform logical operations
always @(*) begin
    case (aluc)
        AND: result = a & b;
        OR: result = a | b;
        XOR: result = a ^ b;
        NOR: result = ~(a | b);
        default: result = 32'bz;
    endcase
end

endmodule

// Shift and Compare Module
module shift_compare_module(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output [31:0] result,
    output flag
);

// Perform shift and compare operations
always @(*) begin
    case (aluc)
        SLT: result = (signed'(a) < signed'(b))? 32'h1 : 32'h0;
        SLTU: result = (a < b)? 32'h1 : 32'h0;
        SLL: result = a << b[4:0];
        SRL: result = a >> b[4:0];
        SRA: result = a >>> b[4:0];
        SLLV: result = a << a[4:0];
        SRLV: result = a >> a[4:0];
        SRAV: result = a >>> a[4:0];
        default: begin
            result = 32'bz;
            flag = 1'b0;
        end
    endcase
    flag = (aluc == SLT || aluc == SLTU)? result[0] : 1'b0;
end

endmodule