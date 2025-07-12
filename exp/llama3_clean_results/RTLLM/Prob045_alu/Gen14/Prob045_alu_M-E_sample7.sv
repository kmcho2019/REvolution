module alu (
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [5:0] aluc,
    output reg  [31:0] r,
    output reg        zero,
    output reg        carry,
    output reg        negative,
    output reg        overflow,
    output reg        flag
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

wire [31:0] add_sub_r;
wire        add_sub_carry;
wire        add_sub_overflow;

wire [31:0] logic_r;

wire [31:0] shift_r;

// Arithmetic Operations Module
module arithmetic (
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [1:0] op, // 0: add, 1: sub, 2: addu, 3: subu
    output wire [31:0] r,
    output wire        carry,
    output wire        overflow
);

always @(a, b, op) begin
    case (op)
        2'b00: begin
            {carry, r} = a + b;
            overflow = (a[31] != b[31] && r[31] != a[31]);
        end
        2'b01: begin
            {carry, r} = a - b;
            overflow = (a[31] != b[31] && r[31] != a[31]);
        end
        2'b10: begin
            r = a + b;
            carry = (a + b > 32'hffffffff);
            overflow = 1'b0;
        end
        2'b11: begin
            r = a - b;
            carry = (a - b < 0);
            overflow = 1'b0;
        end
        default: begin
            r = 32'bz;
            carry = 1'b0;
            overflow = 1'b0;
        end
    endcase
end

endmodule

// Logical Operations Module
module logic (
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [1:0] op, // 0: and, 1: or, 2: xor, 3: nor
    output wire [31:0] r
);

always @(a, b, op) begin
    case (op)
        2'b00: r = a & b;
        2'b01: r = a | b;
        2'b10: r = a ^ b;
        2'b11: r = ~(a | b);
        default: r = 32'bz;
    endcase
end

endmodule

// Shift Operations Module
module shift (
    input  wire [31:0] a,
    input  wire [4:0] shift,
    input  wire [1:0] op, // 0: sll, 1: srl, 2: sra
    output wire [31:0] r
);

always @(a, shift, op) begin
    case (op)
        2'b00: r = a << shift;
        2'b01: r = a >> shift;
        2'b10: r = $signed(a) >>> shift; // Use $signed for arithmetic shift
        default: r = 32'bz;
    endcase
end

endmodule

// Flag Generation Module
module flag_gen (
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [5:0] aluc,
    output wire        zero,
    output wire        negative,
    output wire        overflow,
    output wire        flag
);

always @(a, b, aluc) begin
    case (aluc)
        SLT: begin
            zero = (a < b) ? 1'b0 : 1'b1;
            negative = (a < b) ? 1'b1 : 1'b0;
            overflow = 1'b0;
            flag = (a < b) ? 1'b1 : 1'b0;
        end
        SLTU: begin
            zero = (a < b) ? 1'b0 : 1'b1;
            negative = (a < b) ? 1'b1 : 1'b0;
            overflow = 1'b0;
            flag = (a < b) ? 1'b1 : 1'b0;
        end
        default: begin
            zero = (a == 0) ? 1'b1 : 1'b0;
            negative = a[31];
            overflow = 1'b0;
            flag = 1'b0;
        end
    endcase
end

endmodule

// Multiplexer for selecting operation result
always @(a, b, aluc) begin
    case (aluc)
        ADD, ADDU: begin
            r = add_sub_r;
            carry = add_sub_carry;
            overflow = add_sub_overflow;
        end
        SUB, SUBU: begin
            r = add_sub_r;
            carry = add_sub_carry;
            overflow = add_sub_overflow;
        end
        AND: r = logic_r;
        OR: r = logic_r;
        XOR: r = logic_r;
        NOR: r = logic_r;
        SLL, SRL, SRA: r = shift_r;
        SLLV, SRLV, SRAV: r = shift_r;
        LUI: r = {a[15:0], 16'h0};
        default: r = 32'bz;
    endcase
    carry = 1'b0; // Reset carry for non-add/sub operations
    overflow = 1'b0; // Reset overflow for non-add/sub operations
end

// Instantiate sub-modules
arithmetic u_arithmetic (
    .a(a),
    .b(b),
    .op({aluc[4], aluc[3]}),
    .r(add_sub_r),
    .carry(add_sub_carry),
    .overflow(add_sub_overflow)
);

logic u_logic (
    .a(a),
    .b(b),
    .op({aluc[4], aluc[3]}),
    .r(logic_r)
);

shift u_shift (
    .a(a),
    .shift(b[4:0]),
    .op({aluc[1], aluc[0]}),
    .r(shift_r)
);

flag_gen u_flag_gen (
    .a(a),
    .b(b),
    .aluc(aluc),
    .zero(zero),
    .negative(negative),
    .overflow(overflow),
    .flag(flag)
);

endmodule