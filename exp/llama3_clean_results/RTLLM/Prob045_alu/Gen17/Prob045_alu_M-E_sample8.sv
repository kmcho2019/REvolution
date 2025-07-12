module alu(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output reg [31:0] r,
    output reg zero,
    output reg carry,
    output reg negative,
    output reg overflow,
    output reg flag
);

// Operation categories
parameter ADD = 6'b100000;
parameter SUB = 6'b100010;
parameter ADDU = 6'b100001;
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
parameter LUI = 6'b001111;
parameter SLLV = 6'b000100;
parameter SRLV = 6'b000110;
parameter SRAV = 6'b000111;

// Arithmetic operations
reg [31:0] arithmetic_result;
reg arithmetic_carry;
reg arithmetic_overflow;

// Logical operations
reg [31:0] logical_result;

// Shift operations
reg [31:0] shift_result;

// Miscellaneous operations
reg [31:0] miscellaneous_result;
reg miscellaneous_flag;

// Arithmetic unit
arithmetic_unit au(
    .a(a),
    .b(b),
    .aluc(aluc),
    .result(arithmetic_result),
    .carry(arithmetic_carry),
    .overflow(arithmetic_overflow)
);

// Logical unit
logical_unit lu(
    .a(a),
    .b(b),
    .aluc(aluc),
    .result(logical_result)
);

// Shift unit
shift_unit su(
    .a(a),
    .b(b),
    .aluc(aluc),
    .result(shift_result)
);

// Miscellaneous unit
miscellaneous_unit mu(
    .a(a),
    .b(b),
    .aluc(aluc),
    .result(miscellaneous_result),
    .flag(miscellaneous_flag)
);

// Controller
always @(*) begin
    case (aluc)
        ADD: begin
            r = arithmetic_result;
            carry = arithmetic_carry;
            overflow = arithmetic_overflow;
            zero = (r == 32'd0);
            negative = (r[31] == 1'b1);
            flag = 1'b0;
        end
        ADDU: begin
            r = a + b;
            carry = (a[31] != b[31]) && (a[31] != r[31]);
            overflow = (a[31] != b[31]) && (a[31] != r[31]);
            zero = (r == 32'd0);
            negative = (r[31] == 1'b1);
            flag = 1'b0;
        end
        SUB: begin
            r = a - b;
            carry = (a[31] == b[31]) && (a[31] != r[31]);
            overflow = (a[31] == b[31]) && (a[31] != r[31]);
            zero = (r == 32'd0);
            negative = (r[31] == 1'b1);
            flag = 1'b0;
        end
        SUBU: begin
            r = a - b;
            carry = (a[31] == b[31]) && (a[31] != r[31]);
            overflow = (a[31] == b[31]) && (a[31] != r[31]);
            zero = (r == 32'd0);
            negative = (r[31] == 1'b1);
            flag = 1'b0;
        end
        AND: begin
            r = logical_result;
            carry = 1'b0;
            overflow = 1'b0;
            zero = (r == 32'd0);
            negative = (r[31] == 1'b1);
            flag = 1'b0;
        end
        OR: begin
            r = logical_result;
            carry = 1'b0;
            overflow = 1'b0;
            zero = (r == 32'd0);
            negative = (r[31] == 1'b1);
            flag = 1'b0;
        end
        XOR: begin
            r = logical_result;
            carry = 1'b0;
            overflow = 1'b0;
            zero = (r == 32'd0);
            negative = (r[31] == 1'b1);
            flag = 1'b0;
        end
        NOR: begin
            r = logical_result;
            carry = 1'b0;
            overflow = 1'b0;
            zero = (r == 32'd0);
            negative = (r[31] == 1'b1);
            flag = 1'b0;
        end
        SLT: begin
            r = miscellaneous_result;
            carry = 1'b0;
            overflow = 1'b0;
            zero = (r == 32'd0);
            negative = (r[31] == 1'b1);
            flag = miscellaneous_flag;
        end
        SLTU: begin
            r = miscellaneous_result;
            carry = 1'b0;
            overflow = 1'b0;
            zero = (r == 32'd0);
            negative = (r[31] == 1'b1);
            flag = miscellaneous_flag;
        end
        SLL: begin
            r = shift_result;
            carry = 1'b0;
            overflow = 1'b0;
            zero = (r == 32'd0);
            negative = (r[31] == 1'b1);
            flag = 1'b0;
        end
        SRL: begin
            r = shift_result;
            carry = 1'b0;
            overflow = 1'b0;
            zero = (r == 32'd0);
            negative = (r[31] == 1'b1);
            flag = 1'b0;
        end
        SRA: begin
            r = shift_result;
            carry = 1'b0;
            overflow = 1'b0;
            zero = (r == 32'd0);
            negative = (r[31] == 1'b1);
            flag = 1'b0;
        end
        LUI: begin
            r = {a[15:0], 16'd0};
            carry = 1'b0;
            overflow = 1'b0;
            zero = (r == 32'd0);
            negative = (r[31] == 1'b1);
            flag = 1'b0;
        end
        SLLV: begin
            r = a << b[4:0];
            carry = 1'b0;
            overflow = 1'b0;
            zero = (r == 32'd0);
            negative = (r[31] == 1'b1);
            flag = 1'b0;
        end
        SRLV: begin
            r = a >> b[4:0];
            carry = 1'b0;
            overflow = 1'b0;
            zero = (r == 32'd0);
            negative = (r[31] == 1'b1);
            flag = 1'b0;
        end
        SRAV: begin
            r = a >>> b[4:0];
            carry = 1'b0;
            overflow = 1'b0;
            zero = (r == 32'd0);
            negative = (r[31] == 1'b1);
            flag = 1'b0;
        end
        default: begin
            r = 32'd0;
            carry = 1'b0;
            overflow = 1'b0;
            zero = 1'b1;
            negative = 1'b0;
            flag = 1'b0;
        end
    endcase
end

endmodule

module arithmetic_unit(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output reg [31:0] result,
    output reg carry,
    output reg overflow
);

always @(*) begin
    case (aluc)
        ADD: begin
            result = a + b;
            carry = (a[31] != b[31]) && (a[31] != result[31]);
            overflow = (a[31] != b[31]) && (a[31] != result[31]);
        end
        SUB: begin
            result = a - b;
            carry = (a[31] == b[31]) && (a[31] != result[31]);
            overflow = (a[31] == b[31]) && (a[31] != result[31]);
        end
        default: begin
            result = 32'd0;
            carry = 1'b0;
            overflow = 1'b0;
        end
    endcase
end

endmodule

module logical_unit(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output reg [31:0] result
);

always @(*) begin
    case (aluc)
        AND: result = a & b;
        OR: result = a | b;
        XOR: result = a ^ b;
        NOR: result = ~(a | b);
        default: result = 32'd0;
    endcase
end

endmodule

module shift_unit(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output reg [31:0] result
);

always @(*) begin
    case (aluc)
        SLL: result = a << b[4:0];
        SRL: result = a >> b[4:0];
        SRA: result = a >>> b[4:0];
        default: result = 32'd0;
    endcase
end

endmodule

module miscellaneous_unit(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output reg [31:0] result,
    output reg flag
);

always @(*) begin
    case (aluc)
        SLT: begin
            result = (signed'(a) < signed'(b))? 32'd1 : 32'd0;
            flag = (signed'(a) < signed'(b));
        end
        SLTU: begin
            result = (a < b)? 32'd1 : 32'd0;
            flag = (a < b);
        end
        default: begin
            result = 32'd0;
            flag = 1'b0;
        end
    endcase
end

endmodule