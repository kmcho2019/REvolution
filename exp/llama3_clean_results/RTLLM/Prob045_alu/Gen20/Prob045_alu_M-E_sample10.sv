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

reg [31:0] operand_a;
reg [31:0] operand_b;
reg [5:0] op;
reg [31:0] result;
reg [31:0] shifted_result;
reg [31:0] final_result;

// Instruction Decode Stage
always @(*) begin
    case (aluc)
        ADD, ADDU: op = 6'b000000; // Arithmetic operation
        SUB, SUBU: op = 6'b000001; // Arithmetic operation
        AND: op = 6'b000010; // Bitwise AND
        OR: op = 6'b000011; // Bitwise OR
        XOR: op = 6'b000100; // Bitwise XOR
        NOR: op = 6'b000101; // Bitwise NOR
        SLT: op = 6'b000110; // Set Less Than
        SLTU: op = 6'b000111; // Set Less Than Unsigned
        SLL: op = 6'b001000; // Shift Left Logical
        SRL: op = 6'b001001; // Shift Right Logical
        SRA: op = 6'b001010; // Shift Right Arithmetic
        LUI: op = 6'b001011; // Load Upper Immediate
        SLLV: op = 6'b001100; // Shift Left Logical Variable
        SRLV: op = 6'b001101; // Shift Right Logical Variable
        SRAV: op = 6'b001110; // Shift Right Arithmetic Variable
        default: op = 6'b000000; // Default operation
    endcase
end

// Operand Fetch Stage
always @(*) begin
    case (op)
        6'b000000, 6'b000001: begin // Arithmetic operations
            operand_a = a;
            operand_b = b;
        end
        6'b000010, 6'b000011, 6'b000100, 6'b000101: begin // Bitwise operations
            operand_a = a;
            operand_b = b;
        end
        6'b000110, 6'b000111: begin // Set Less Than operations
            operand_a = a;
            operand_b = b;
        end
        6'b001000, 6'b001001, 6'b001010: begin // Shift operations
            operand_a = a;
            operand_b = b[4:0];
        end
        6'b001011: begin // Load Upper Immediate
            operand_a = 32'd0;
            operand_b = b[15:0];
        end
        6'b001100, 6'b001101, 6'b001110: begin // Variable Shift operations
            operand_a = a;
            operand_b = b[4:0];
        end
        default: begin
            operand_a = 32'd0;
            operand_b = 32'd0;
        end
    endcase
end

// Execution Stage
always @(*) begin
    case (op)
        6'b000000: result = operand_a + operand_b; // Addition
        6'b000001: result = operand_a - operand_b; // Subtraction
        6'b000010: result = operand_a & operand_b; // Bitwise AND
        6'b000011: result = operand_a | operand_b; // Bitwise OR
        6'b000100: result = operand_a ^ operand_b; // Bitwise XOR
        6'b000101: result = ~(operand_a | operand_b); // Bitwise NOR
        6'b000110: result = (signed'(operand_a) < signed'(operand_b)) ? 32'd1 : 32'd0; // Set Less Than
        6'b000111: result = (operand_a < operand_b) ? 32'd1 : 32'd0; // Set Less Than Unsigned
        6'b001000: result = operand_a << operand_b; // Shift Left Logical
        6'b001001: result = operand_a >> operand_b; // Shift Right Logical
        6'b001010: result = operand_a >>> operand_b; // Shift Right Arithmetic
        6'b001011: result = {operand_b, 16'd0}; // Load Upper Immediate
        6'b001100: result = operand_a << operand_b; // Shift Left Logical Variable
        6'b001101: result = operand_a >> operand_b; // Shift Right Logical Variable
        6'b001110: result = operand_a >>> operand_b; // Shift Right Arithmetic Variable
        default: result = 32'd0; // Default operation
    endcase
end

// Result Stage
always @(*) begin
    case (op)
        6'b000000, 6'b000001: begin // Arithmetic operations
            final_result = result;
            carry = (operand_a[31] != operand_b[31]) && (operand_a[31] != result[31]);
            overflow = (operand_a[31] == 1'b1) && (operand_b[31] == 1'b1) && (result[31] == 1'b0);
        end
        6'b000010, 6'b000011, 6'b000100, 6'b000101: begin // Bitwise operations
            final_result = result;
            carry = 1'b0;
            overflow = 1'b0;
        end
        6'b000110, 6'b000111: begin // Set Less Than operations
            final_result = result;
            carry = 1'b0;
            overflow = 1'b0;
        end
        6'b001000, 6'b001001, 6'b001010: begin // Shift operations
            final_result = result;
            carry = 1'b0;
            overflow = 1'b0;
        end
        6'b001011: begin // Load Upper Immediate
            final_result = result;
            carry = 1'b0;
            overflow = 1'b0;
        end
        6'b001100, 6'b001101, 6'b001110: begin // Variable Shift operations
            final_result = result;
            carry = 1'b0;
            overflow = 1'b0;
        end
        default: begin
            final_result = 32'd0;
            carry = 1'b0;
            overflow = 1'b0;
        end
    endcase
end

assign r = final_result;
assign zero = (final_result == 32'd0);
assign negative = final_result[31];
assign flag = (op == 6'b000110 || op == 6'b000111) ? final_result[0] : 1'b0;

endmodule