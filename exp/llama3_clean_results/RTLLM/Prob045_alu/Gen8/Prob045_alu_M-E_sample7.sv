module alu(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output [31:0] r,
    output reg zero,
    output reg carry,
    output reg negative,
    output reg overflow,
    output reg flag
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

// Lookup Table (LUT) for simple logical operations
reg [31:0] lut_result;
always @(*) begin
    case (aluc)
        AND: lut_result = a & b;
        OR: lut_result = a | b;
        XOR: lut_result = a ^ b;
        NOR: lut_result = ~(a | b);
        default: lut_result = 32'bz;
    endcase
end

// Microcode Engine for complex operations
reg [2:0] microcode;
always @(*) begin
    case (aluc)
        ADD: microcode = 3'b000;
        SUB: microcode = 3'b001;
        SLL: microcode = 3'b010;
        SRL: microcode = 3'b011;
        SRA: microcode = 3'b100;
        default: microcode = 3'bzzz;
    endcase
end

// Arithmetic and Shift Logic
reg [31:0] arithmetic_result;
always @(*) begin
    case (microcode)
        3'b000: arithmetic_result = a + b;
        3'b001: arithmetic_result = a - b;
        3'b010: arithmetic_result = a << b[4:0];
        3'b011: arithmetic_result = a >> b[4:0];
        3'b100: arithmetic_result = a >>> b[4:0];
        default: arithmetic_result = 32'bz;
    endcase
end

// Result Selection
reg [31:0] result;
always @(*) begin
    case (aluc)
        AND, OR, XOR, NOR: result = lut_result;
        ADD, SUB, SLL, SRL, SRA: result = arithmetic_result;
        default: result = 32'bz;
    endcase
end

// Status Signals
always @(*) begin
    case (aluc)
        ADD, SUB: begin
            {carry, result} = a + b;
            overflow = (a[31] == b[31] && result[31] != a[31]);
        end
        SLL, SRL, SRA: begin
            carry = 1'b0;
            overflow = 1'b0;
        end
        default: begin
            carry = 1'b0;
            overflow = 1'b0;
        end
    endcase
end

// Assign Outputs
assign r = result;
assign zero = (result == 32'h0);
assign negative = result[31];
assign flag = (aluc == SLT || aluc == SLTU) ? result[0] : 1'b0;

endmodule