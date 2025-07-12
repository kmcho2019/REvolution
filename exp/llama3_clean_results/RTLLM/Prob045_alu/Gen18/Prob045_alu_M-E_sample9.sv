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

// Arithmetic Module
module arithmetic_module(
    input [31:0] a,
    input [31:0] b,
    input [1:0] op,
    output reg [31:0] result,
    output reg carry,
    output reg overflow
);
always @(*) begin
    case (op)
        2'b00: begin // ADD
            {carry, result} = a + b;
            overflow = (a[31] == b[31] && a[31]!= result[31]);
        end
        2'b01: begin // SUB
            {carry, result} = a - b;
            overflow = (a[31]!= b[31] && a[31]!= result[31]);
        end
        default: begin
            result = 32'bx;
            carry = 1'bx;
            overflow = 1'bx;
        end
    endcase
end
endmodule

// Logical Module
module logical_module(
    input [31:0] a,
    input [31:0] b,
    input [1:0] op,
    output reg [31:0] result
);
always @(*) begin
    case (op)
        2'b00: begin // AND
            result = a & b;
        end
        2'b01: begin // OR
            result = a | b;
        end
        2'b10: begin // XOR
            result = a ^ b;
        end
        default: begin
            result = 32'bx;
        end
    endcase
end
endmodule

// Shift Module
module shift_module(
    input [31:0] a,
    input [4:0] shift_amount,
    input [1:0] op,
    output reg [31:0] result
);
always @(*) begin
    case (op)
        2'b00: begin // SLL
            result = a << shift_amount;
        end
        2'b01: begin // SRL
            result = a >> shift_amount;
        end
        2'b10: begin // SRA
            result = $signed(a) >>> shift_amount;
        end
        default: begin
            result = 32'bx;
        end
    endcase
end
endmodule

// Control Module
module control_module(
    input [5:0] aluc,
    output reg [1:0] arith_op,
    output reg [1:0] logical_op,
    output reg [1:0] shift_op,
    output reg [31:0] result
);
always @(*) begin
    case (aluc)
        ADD: begin
            arith_op = 2'b00;
        end
        SUB: begin
            arith_op = 2'b01;
        end
        AND: begin
            logical_op = 2'b00;
        end
        OR: begin
            logical_op = 2'b01;
        end
        XOR: begin
            logical_op = 2'b10;
        end
        SLL: begin
            shift_op = 2'b00;
        end
        SRL: begin
            shift_op = 2'b01;
        end
        SRA: begin
            shift_op = 2'b10;
        end
        default: begin
            arith_op = 2'bx;
            logical_op = 2'bx;
            shift_op = 2'bx;
        end
    endcase
end
endmodule

// Instantiate modules
arithmetic_module am(
   .a(a),
   .b(b),
   .op(aluc[1:0]),
   .result(r),
   .carry(carry),
   .overflow(overflow)
);

logical_module lm(
   .a(a),
   .b(b),
   .op(aluc[1:0]),
   .result(r)
);

shift_module sm(
   .a(a),
   .shift_amount(b[4:0]),
   .op(aluc[1:0]),
   .result(r)
);

control_module cm(
   .aluc(aluc),
   .arith_op(arith_op),
   .logical_op(logical_op),
   .shift_op(shift_op),
   .result(r)
);

// Combine results
always @(*) begin
    case (aluc)
        ADD, SUB: begin
            r = am.result;
            carry = am.carry;
            overflow = am.overflow;
        end
        AND, OR, XOR: begin
            r = lm.result;
            carry = 1'b0;
            overflow = 1'b0;
        end
        SLL, SRL, SRA: begin
            r = sm.result;
            carry = 1'b0;
            overflow = 1'b0;
        end
        default: begin
            r = 32'bx;
            carry = 1'bx;
            overflow = 1'bx;
        end
    endcase
end

// Calculate zero, negative, and flag
always @(*) begin
    zero = (r == 32'd0);
    negative = r[31];
    flag = (aluc == SLT || aluc == SLTU)? (r == 32'd1) : 1'bx;
end

endmodule