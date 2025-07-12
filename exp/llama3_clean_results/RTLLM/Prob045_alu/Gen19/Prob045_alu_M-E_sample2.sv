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

// Internal wires
wire [31:0] alu_result;
wire [31:0] shu_result;
wire [31:0] cu_result;

// Instantiate modules
alu_module alu_inst(
    .a(a),
    .b(b),
    .aluc(aluc),
    .result(alu_result)
);

shu_module shu_inst(
    .a(a),
    .b(b),
    .aluc(aluc),
    .result(shu_result)
);

cu_module cu_inst(
    .a(a),
    .b(b),
    .aluc(aluc),
    .result(cu_result)
);

// Control unit
always @(*) begin
    case (aluc)
        ADD, SUB, ADDU, SUBU, AND, OR, XOR, NOR: begin
            r = alu_result;
            zero = (r == 32'd0);
            negative = (r[31] == 1'b1);
            carry = (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU);
            overflow = (aluc == ADD || aluc == SUB);
            flag = 1'b0;
        end
        SLL, SRL, SRA, SLLV, SRLV, SRAV: begin
            r = shu_result;
            zero = (r == 32'd0);
            negative = (r[31] == 1'b1);
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
        SLT, SLTU: begin
            r = cu_result;
            zero = (r == 32'd0);
            negative = (r[31] == 1'b1);
            carry = 1'b0;
            overflow = 1'b0;
            flag = (aluc == SLT || aluc == SLTU);
        end
        LUI: begin
            r = {b[15:0], 16'd0};
            zero = (r == 32'd0);
            negative = (r[31] == 1'b1);
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
        default: begin
            r = 32'd0;
            zero = 1'b1;
            negative = 1'b0;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
    endcase
end

endmodule

module alu_module(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output reg [31:0] result
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

always @(*) begin
    case (aluc)
        ADD: result = a + b;
        SUB: result = a - b;
        ADDU: result = a + b;
        SUBU: result = a - b;
        AND: result = a & b;
        OR: result = a | b;
        XOR: result = a ^ b;
        NOR: result = ~(a | b);
        default: result = 32'd0;
    endcase
end

endmodule

module shu_module(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output reg [31:0] result
);

// Operation categories
parameter SLL = 6'b000000;
parameter SRL = 6'b000010;
parameter SRA = 6'b000011;
parameter SLLV = 6'b000100;
parameter SRLV = 6'b000110;
parameter SRAV = 6'b000111;

always @(*) begin
    case (aluc)
        SLL: result = a << b[4:0];
        SRL: result = a >> b[4:0];
        SRA: result = a >>> b[4:0];
        SLLV: result = a << b[4:0];
        SRLV: result = a >> b[4:0];
        SRAV: result = a >>> b[4:0];
        default: result = 32'd0;
    endcase
end

endmodule

module cu_module(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output reg [31:0] result
);

// Operation categories
parameter SLT = 6'b101010;
parameter SLTU = 6'b101011;

always @(*) begin
    case (aluc)
        SLT: result = (signed'(a) < signed'(b)) ? 32'd1 : 32'd0;
        SLTU: result = (a < b) ? 32'd1 : 32'd0;
        default: result = 32'd0;
    endcase
end

endmodule