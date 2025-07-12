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

// Operation codes
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

// OP_DEC module
wire [5:0] op_code;
assign op_code = aluc;

// ALU_CORE module
reg [31:0] alu_result;
always @(*) begin
    case (op_code)
        ADD: alu_result = a + b;
        SUB: alu_result = a - b;
        ADDU: alu_result = a + b;
        SUBU: alu_result = a - b;
        AND: alu_result = a & b;
        OR: alu_result = a | b;
        XOR: alu_result = a ^ b;
        NOR: alu_result = ~(a | b);
        SLT: alu_result = (signed'(a) < signed'(b)) ? 32'd1 : 32'd0;
        SLTU: alu_result = (a < b) ? 32'd1 : 32'd0;
        SLL: alu_result = a << b[4:0];
        SRL: alu_result = a >> b[4:0];
        SRA: alu_result = a >>> b[4:0];
        SLLV: alu_result = a << a[4:0];
        SRLV: alu_result = a >> a[4:0];
        SRAV: alu_result = a >>> a[4:0];
        LUI: alu_result = {a[15:0], 16'd0};
        default: alu_result = 32'bx;
    endcase
end

// FLAG_GEN module
always @(*) begin
    case (op_code)
        ADD, SUB, ADDU, SUBU: begin
            zero = (alu_result == 32'd0);
            carry = (a[31] != b[31]) && (a[31] != alu_result[31]);
            negative = alu_result[31];
            overflow = (a[31] != b[31]) && (a[31] != alu_result[31]);
        end
        AND, OR, XOR, NOR: begin
            zero = (alu_result == 32'd0);
            carry = 1'b0;
            negative = alu_result[31];
            overflow = 1'b0;
        end
        SLT, SLTU: begin
            zero = (alu_result == 32'd0);
            carry = 1'b0;
            negative = alu_result[31];
            overflow = 1'b0;
            flag = (signed'(a) < signed'(b)) || (a < b);
        end
        default: begin
            zero = 1'bx;
            carry = 1'bx;
            negative = 1'bx;
            overflow = 1'bx;
            flag = 1'bx;
        end
    endcase
end

// Assign output
assign r = alu_result;

endmodule