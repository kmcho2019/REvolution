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
            overflow = (a[31] == b[31] && a[31] != result[31]);
        end
        2'b01: begin // SUB
            {carry, result} = a - b;
            overflow = (a[31] != b[31] && a[31] != result[31]);
        end
        2'b10: begin // SLT
            result = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;
            carry = 1'b0;
            overflow = 1'b0;
        end
        2'b11: begin // SLTU
            result = (a < b) ? 32'd1 : 32'd0;
            carry = 1'b0;
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
        2'b11: begin // NOR
            result = ~(a | b);
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

// Load Immediate Module
module load_immediate_module(
    input [15:0] immediate,
    output reg [31:0] result
);

always @(*) begin
    result = {16'b0, immediate};
end

endmodule

// Top-Level ALU Module
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

wire [31:0] arithmetic_result;
wire [31:0] logical_result;
wire [31:0] shift_result;
wire [31:0] load_immediate_result;

arithmetic_module arithmetic_module_inst(
    .a(a),
    .b(b),
    .op(aluc[1:0]),
    .result(arithmetic_result),
    .carry(carry),
    .overflow(overflow)
);

logical_module logical_module_inst(
    .a(a),
    .b(b),
    .op(aluc[1:0]),
    .result(logical_result)
);

shift_module shift_module_inst(
    .a(a),
    .shift_amount(b[4:0]),
    .op(aluc[1:0]),
    .result(shift_result)
);

load_immediate_module load_immediate_module_inst(
    .immediate(a[15:0]),
    .result(load_immediate_result)
);

always @(*) begin
    case (aluc)
        6'b100000: begin // ADD
            r = arithmetic_result;
        end
        6'b100001: begin // ADDU
            r = arithmetic_result;
        end
        6'b100010: begin // SUB
            r = arithmetic_result;
        end
        6'b100011: begin // SUBU
            r = arithmetic_result;
        end
        6'b100100: begin // AND
            r = logical_result;
        end
        6'b100101: begin // OR
            r = logical_result;
        end
        6'b100110: begin // XOR
            r = logical_result;
        end
        6'b100111: begin // NOR
            r = logical_result;
        end
        6'b101010: begin // SLT
            r = arithmetic_result;
            flag = (arithmetic_result == 32'd1);
        end
        6'b101011: begin // SLTU
            r = arithmetic_result;
            flag = (arithmetic_result == 32'd1);
        end
        6'b000000: begin // SLL
            r = shift_result;
        end
        6'b000010: begin // SRL
            r = shift_result;
        end
        6'b000011: begin // SRA
            r = shift_result;
        end
        6'b000100: begin // SLLV
            r = shift_result;
        end
        6'b000110: begin // SRLV
            r = shift_result;
        end
        6'b000111: begin // SRAV
            r = shift_result;
        end
        6'b001111: begin // LUI
            r = load_immediate_result;
        end
        default: begin
            r = 32'bx;
        end
    endcase

    zero = (r == 32'd0);
    negative = r[31];
end

endmodule