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
parameter ARITHMETIC = 2'b00;
parameter LOGICAL = 2'b01;
parameter SHIFT = 2'b10;
parameter MISCELLANEOUS = 2'b11;

// Arithmetic operations
parameter ADD = 6'b100000;
parameter SUB = 6'b100010;
parameter ADDU = 6'b100001;
parameter SUBU = 6'b100011;

// Logical operations
parameter AND = 6'b100100;
parameter OR = 6'b100101;
parameter XOR = 6'b100110;
parameter NOR = 6'b100111;

// Shift operations
parameter SLL = 6'b000000;
parameter SRL = 6'b000010;
parameter SRA = 6'b000011;
parameter SLLV = 6'b000100;
parameter SRLV = 6'b000110;
parameter SRAV = 6'b000111;

// Miscellaneous operations
parameter SLT = 6'b101010;
parameter SLTU = 6'b101011;
parameter LUI = 6'b001111;

// Category decoders
wire [1:0] category;
assign category = aluc[5:4];

// Arithmetic module
wire [31:0] arithmetic_result;
wire arithmetic_carry;
wire arithmetic_overflow;
arithmetic_module arithmetic_inst (
    .a(a),
    .b(b),
    .op(aluc[3:0]),
    .result(arithmetic_result),
    .carry(arithmetic_carry),
    .overflow(arithmetic_overflow)
);

// Logical module
wire [31:0] logical_result;
logical_module logical_inst (
    .a(a),
    .b(b),
    .op(aluc[3:0]),
    .result(logical_result)
);

// Shift module
wire [31:0] shift_result;
shift_module shift_inst (
    .a(a),
    .b(b),
    .op(aluc[3:0]),
    .result(shift_result)
);

// Miscellaneous module
wire [31:0] miscellaneous_result;
wire miscellaneous_flag;
miscellaneous_module miscellaneous_inst (
    .a(a),
    .b(b),
    .op(aluc[3:0]),
    .result(miscellaneous_result),
    .flag(miscellaneous_flag)
);

// Output multiplexer
always @(*) begin
    case (aluc[5:0])
        ADD, ADDU: begin
            r = arithmetic_result;
            carry = arithmetic_carry;
            overflow = arithmetic_overflow;
        end
        SUB, SUBU: begin
            r = arithmetic_result;
            carry = arithmetic_carry;
            overflow = arithmetic_overflow;
        end
        AND, OR, XOR, NOR: begin
            r = logical_result;
            carry = 1'b0;
            overflow = 1'b0;
        end
        SLL, SRL, SRA, SLLV, SRLV, SRAV: begin
            r = shift_result;
            carry = 1'b0;
            overflow = 1'b0;
        end
        SLT, SLTU: begin
            r = miscellaneous_result;
            flag = miscellaneous_flag;
            carry = 1'b0;
            overflow = 1'b0;
        end
        LUI: begin
            r = {a[15:0], 16'd0};
            flag = 1'b0;
            carry = 1'b0;
            overflow = 1'b0;
        end
        default: begin
            r = 32'bx;
            carry = 1'bx;
            overflow = 1'bx;
            flag = 1'bx;
        end
    endcase
end

// Output flags
assign zero = (r == 32'd0);
assign negative = (r[31] == 1'b1);

endmodule

module arithmetic_module(
    input [31:0] a,
    input [31:0] b,
    input [3:0] op,
    output reg [31:0] result,
    output reg carry,
    output reg overflow
);

// Arithmetic operations
parameter ADD = 4'b0000;
parameter SUB = 4'b0010;
parameter ADDU = 4'b0001;
parameter SUBU = 4'b0011;

// Arithmetic logic
always @(*) begin
    case (op)
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
        ADDU: begin
            result = a + b;
            carry = (a[31] != b[31]) && (a[31] != result[31]);
            overflow = 1'b0;
        end
        SUBU: begin
            result = a - b;
            carry = (a[31] == b[31]) && (a[31] != result[31]);
            overflow = 1'b0;
        end
        default: begin
            result = 32'bx;
            carry = 1'bx;
            overflow = 1'bx;
        end
    endcase
end

endmodule

module logical_module(
    input [31:0] a,
    input [31:0] b,
    input [3:0] op,
    output reg [31:0] result
);

// Logical operations
parameter AND = 4'b0000;
parameter OR = 4'b0001;
parameter XOR = 4'b0010;
parameter NOR = 4'b0011;

// Logical logic
always @(*) begin
    case (op)
        AND: result = a & b;
        OR: result = a | b;
        XOR: result = a ^ b;
        NOR: result = ~(a | b);
        default: result = 32'bx;
    endcase
end

endmodule

module shift_module(
    input [31:0] a,
    input [31:0] b,
    input [3:0] op,
    output reg [31:0] result
);

// Shift operations
parameter SLL = 4'b0000;
parameter SRL = 4'b0001;
parameter SRA = 4'b0010;
parameter SLLV = 4'b0011;
parameter SRLV = 4'b0100;
parameter SRAV = 4'b0101;

// Shift logic
always @(*) begin
    case (op)
        SLL: result = a << b[4:0];
        SRL: result = a >> b[4:0];
        SRA: result = a >>> b[4:0];
        SLLV: result = a << b;
        SRLV: result = a >> b;
        SRAV: result = a >>> b;
        default: result = 32'bx;
    endcase
end

endmodule

module miscellaneous_module(
    input [31:0] a,
    input [31:0] b,
    input [3:0] op,
    output reg [31:0] result,
    output reg flag
);

// Miscellaneous operations
parameter SLT = 4'b0000;
parameter SLTU = 4'b0001;
parameter LUI = 4'b0010;

// Miscellaneous logic
always @(*) begin
    case (op)
        SLT: begin
            result = (signed'(a) < signed'(b)) ? 32'd1 : 32'd0;
            flag = (signed'(a) < signed'(b));
        end
        SLTU: begin
            result = (a < b) ? 32'd1 : 32'd0;
            flag = (a < b);
        end
        LUI: begin
            result = {a[15:0], 16'd0};
            flag = 1'b0;
        end
        default: begin
            result = 32'bx;
            flag = 1'bx;
        end
    endcase
end

endmodule