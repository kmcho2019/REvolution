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

// Arithmetic Module
module arithmetic_module(
    input [31:0] a,
    input [31:0] b,
    input [1:0] op,
    output [31:0] result,
    output carry,
    output overflow
);

    reg [32:0] temp;

    always @(*) begin
        case (op)
            2'b00: begin // ADD
                {carry, result} = a + b;
                overflow = (a[31] == b[31] && result[31]!= a[31]);
            end
            2'b01: begin // SUB
                {carry, result} = a - b;
                overflow = (a[31]!= b[31] && result[31]!= a[31]);
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
    input [1:0] op,
    output [31:0] result
);

    always @(*) begin
        case (op)
            2'b00: result = a & b; // AND
            2'b01: result = a | b; // OR
            2'b10: result = a ^ b; // XOR
            2'b11: result = ~(a | b); // NOR
            default: result = 32'bz;
        endcase
    end

endmodule

// Shift Module
module shift_module(
    input [31:0] a,
    input [4:0] shift,
    input [1:0] op,
    output [31:0] result
);

    always @(*) begin
        case (op)
            2'b00: result = a << shift; // SLL
            2'b01: result = a >> shift; // SRL
            2'b10: result = a >>> shift; // SRA
            default: result = 32'bz;
        endcase
    end

endmodule

// Control Unit
module control_unit(
    input [5:0] aluc,
    output [1:0] arithmetic_op,
    output [1:0] logical_op,
    output [1:0] shift_op,
    output [4:0] shift_amount
);

    always @(*) begin
        case (aluc)
            ADD, ADDU: arithmetic_op = 2'b00;
            SUB, SUBU: arithmetic_op = 2'b01;
            AND: logical_op = 2'b00;
            OR: logical_op = 2'b01;
            XOR: logical_op = 2'b10;
            NOR: logical_op = 2'b11;
            SLL: shift_op = 2'b00;
            SRL: shift_op = 2'b01;
            SRA: shift_op = 2'b10;
            SLT, SLTU: begin
                arithmetic_op = 2'b01;
                logical_op = 2'b00;
            end
            default: begin
                arithmetic_op = 2'b00;
                logical_op = 2'b00;
                shift_op = 2'b00;
            end
        endcase
        shift_amount = aluc[4:0];
    end

endmodule

// Flag Generation
module flag_generation(
    input [31:0] result,
    input carry,
    input overflow,
    output zero,
    output negative,
    output flag
);

    always @(*) begin
        zero = (result == 32'h0);
        negative = result[31];
        flag = (result[0] == 1'b1);
    end

endmodule

// Main ALU Logic
reg [31:0] arithmetic_result;
reg [31:0] logical_result;
reg [31:0] shift_result;
reg [1:0] arithmetic_op;
reg [1:0] logical_op;
reg [1:0] shift_op;
reg [4:0] shift_amount;
reg carry;
reg overflow;
reg zero;
reg negative;
reg flag;

arithmetic_module arithmetic_module_inst(
   .a(a),
   .b(b),
   .op(arithmetic_op),
   .result(arithmetic_result),
   .carry(carry),
   .overflow(overflow)
);

logical_module logical_module_inst(
   .a(a),
   .b(b),
   .op(logical_op),
   .result(logical_result)
);

shift_module shift_module_inst(
   .a(a),
   .shift(shift_amount),
   .op(shift_op),
   .result(shift_result)
);

control_unit control_unit_inst(
   .aluc(aluc),
   .arithmetic_op(arithmetic_op),
   .logical_op(logical_op),
   .shift_op(shift_op),
   .shift_amount(shift_amount)
);

flag_generation flag_generation_inst(
   .result(arithmetic_result),
   .carry(carry),
   .overflow(overflow),
   .zero(zero),
   .negative(negative),
   .flag(flag)
);

always @(*) begin
    case (aluc)
        ADD, ADDU, SUB, SUBU: r = arithmetic_result;
        AND, OR, XOR, NOR: r = logical_result;
        SLL, SRL, SRA: r = shift_result;
        SLT, SLTU: r = (arithmetic_result[0] == 1'b1)? 32'h1 : 32'h0;
        default: r = 32'bz;
    endcase
end

assign r = r;
assign zero = zero;
assign carry = carry;
assign negative = negative;
assign overflow = overflow;
assign flag = flag;

endmodule