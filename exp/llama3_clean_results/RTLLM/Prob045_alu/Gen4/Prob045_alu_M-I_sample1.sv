module alu(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output reg [31:0] r,
    output reg zero,
    output reg carry,
    output reg negative,
    output reg overflow,
    output reg flag,
    input clk
);

// Define operation codes
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

// Internal signals
reg [31:0] operand_a;
reg [31:0] operand_b;
reg [31:0] result;
reg [31:0] temp_result;
reg temp_zero;
reg temp_carry;
reg temp_negative;
reg temp_overflow;
reg temp_flag;

// Operation decoder
always @(aluc) begin
    case (aluc)
        ADD: begin
            operand_a = a;
            operand_b = b;
        end
        ADDU: begin
            operand_a = a;
            operand_b = b;
        end
        SUB: begin
            operand_a = a;
            operand_b = b;
        end
        SUBU: begin
            operand_a = a;
            operand_b = b;
        end
        AND: begin
            operand_a = a;
            operand_b = b;
        end
        OR: begin
            operand_a = a;
            operand_b = b;
        end
        XOR: begin
            operand_a = a;
            operand_b = b;
        end
        NOR: begin
            operand_a = a;
            operand_b = b;
        end
        SLT: begin
            operand_a = a;
            operand_b = b;
        end
        SLTU: begin
            operand_a = a;
            operand_b = b;
        end
        SLL: begin
            operand_a = a;
            operand_b = b;
        end
        SRL: begin
            operand_a = a;
            operand_b = b;
        end
        SRA: begin
            operand_a = a;
            operand_b = b;
        end
        SLLV: begin
            operand_a = a;
            operand_b = b;
        end
        SRLV: begin
            operand_a = a;
            operand_b = b;
        end
        SRAV: begin
            operand_a = a;
            operand_b = b;
        end
        LUI: begin
            operand_a = {16'b0, a[15:0]};
            operand_b = 32'd0;
        end
        default: begin
            operand_a = 32'bx;
            operand_b = 32'bx;
        end
    endcase
end

// Pipelined execution unit
always @(posedge clk) begin
    case (aluc)
        ADD: begin
            temp_result = operand_a + operand_b;
            temp_carry = (temp_result[31] == 1'b1)? 1'b1 : 1'b0;
            temp_overflow = ((operand_a[31] == operand_b[31]) && (operand_a[31]!= temp_result[31]))? 1'b1 : 1'b0;
            temp_negative = (temp_result[31] == 1'b1)? 1'b1 : 1'b0;
            temp_zero = (temp_result == 32'd0)? 1'b1 : 1'b0;
            temp_flag = 1'b0;
        end
        ADDU: begin
            temp_result = operand_a + operand_b;
            temp_carry = (temp_result[31] == 1'b1)? 1'b1 : 1'b0;
            temp_overflow = ((operand_a[31] == operand_b[31]) && (operand_a[31]!= temp_result[31]))? 1'b1 : 1'b0;
            temp_negative = (temp_result[31] == 1'b1)? 1'b1 : 1'b0;
            temp_zero = (temp_result == 32'd0)? 1'b1 : 1'b0;
            temp_flag = 1'b0;
        end
        SUB: begin
            temp_result = operand_a - operand_b;
            temp_carry = (temp_result[31] == 1'b1)? 1'b1 : 1'b0;
            temp_overflow = ((operand_a[31] == operand_b[31]) && (operand_a[31]!= temp_result[31]))? 1'b1 : 1'b0;
            temp_negative = (temp_result[31] == 1'b1)? 1'b1 : 1'b0;
            temp_zero = (temp_result == 32'd0)? 1'b1 : 1'b0;
            temp_flag = 1'b0;
        end
        SUBU: begin
            temp_result = operand_a - operand_b;
            temp_carry = (temp_result[31] == 1'b1)? 1'b1 : 1'b0;
            temp_overflow = ((operand_a[31] == operand_b[31]) && (operand_a[31]!= temp_result[31]))? 1'b1 : 1'b0;
            temp_negative = (temp_result[31] == 1'b1)? 1'b1 : 1'b0;
            temp_zero = (temp_result == 32'd0)? 1'b1 : 1'b0;
            temp_flag = 1'b0;
        end
        AND: begin
            temp_result = operand_a & operand_b;
            temp_carry = 1'b0;
            temp_overflow = 1'b0;
            temp_negative = (temp_result[31] == 1'b1)? 1'b1 : 1'b0;
            temp_zero = (temp_result == 32'd0)? 1'b1 : 1'b0;
            temp_flag = 1'b0;
        end
        OR: begin
            temp_result = operand_a | operand_b;
            temp_carry = 1'b0;
            temp_overflow = 1'b0;
            temp_negative = (temp_result[31] == 1'b1)? 1'b1 : 1'b0;
            temp_zero = (temp_result == 32'd0)? 1'b1 : 1'b0;
            temp_flag = 1'b0;
        end
        XOR: begin
            temp_result = operand_a ^ operand_b;
            temp_carry = 1'b0;
            temp_overflow = 1'b0;
            temp_negative = (temp_result[31] == 1'b1)? 1'b1 : 1'b0;
            temp_zero = (temp_result == 32'd0)? 1'b1 : 1'b0;
            temp_flag = 1'b0;
        end
        NOR: begin
            temp_result = ~(operand_a | operand_b);
            temp_carry = 1'b0;
            temp_overflow = 1'b0;
            temp_negative = (temp_result[31] == 1'b1)? 1'b1 : 1'b0;
            temp_zero = (temp_result == 32'd0)? 1'b1 : 1'b0;
            temp_flag = 1'b0;
        end
        SLT: begin
            temp_result = (operand_a < operand_b)? 32'd1 : 32'd0;
            temp_carry = 1'b0;
            temp_overflow = 1'b0;
            temp_negative = (temp_result[31] == 1'b1)? 1'b1 : 1'b0;
            temp_zero = (temp_result == 32'd0)? 1'b1 : 1'b0;
            temp_flag = (operand_a < operand_b)? 1'b1 : 1'b0;
        end
        SLTU: begin
            temp_result = (operand_a < operand_b)? 32'd1 : 32'd0;
            temp_carry = 1'b0;
            temp_overflow = 1'b0;
            temp_negative = (temp_result[31] == 1'b1)? 1'b1 : 1'b0;
            temp_zero = (temp_result == 32'd0)? 1'b1 : 1'b0;
            temp_flag = (operand_a < operand_b)? 1'b1 : 1'b0;
        end
        SLL: begin
            temp_result = operand_a << operand_b[4:0];
            temp_carry = 1'b0;
            temp_overflow = 1'b0;
            temp_negative = (temp_result[31] == 1'b1)? 1'b1 : 1'b0;
            temp_zero = (temp_result == 32'd0)? 1'b1 : 1'b0;
            temp_flag = 1'b0;
        end
        SRL: begin
            temp_result = operand_a >> operand_b[4:0];
            temp_carry = 1'b0;
            temp_overflow = 1'b0;
            temp_negative = (temp_result[31] == 1'b1)? 1'b1 : 1'b0;
            temp_zero = (temp_result == 32'd0)? 1'b1 : 1'b0;
            temp_flag = 1'b0;
        end
        SRA: begin
            temp_result = operand_a >>> operand_b[4:0];
            temp_carry = 1'b0;
            temp_overflow = 1'b0;
            temp_negative = (temp_result[31] == 1'b1)? 1'b1 : 1'b0;
            temp_zero = (temp_result == 32'd0)? 1'b1 : 1'b0;
            temp_flag = 1'b0;
        end
        SLLV: begin
            temp_result = operand_a << operand_b[4:0];
            temp_carry = 1'b0;
            temp_overflow = 1'b0;
            temp_negative = (temp_result[31] == 1'b1)? 1'b1 : 1'b0;
            temp_zero = (temp_result == 32'd0)? 1'b1 : 1'b0;
            temp_flag = 1'b0;
        end
        SRLV: begin
            temp_result = operand_a >> operand_b[4:0];
            temp_carry = 1'b0;
            temp_overflow = 1'b0;
            temp_negative = (temp_result[31] == 1'b1)? 1'b1 : 1'b0;
            temp_zero = (temp_result == 32'd0)? 1'b1 : 1'b0;
            temp_flag = 1'b0;
        end
        SRAV: begin
            temp_result = operand_a >>> operand_b[4:0];
            temp_carry = 1'b0;
            temp_overflow = 1'b0;
            temp_negative = (temp_result[31] == 1'b1)? 1'b1 : 1'b0;
            temp_zero = (temp_result == 32'd0)? 1'b1 : 1'b0;
            temp_flag = 1'b0;
        end
        LUI: begin
            temp_result = {16'b0, operand_a[15:0]};
            temp_carry = 1'b0;
            temp_overflow = 1'b0;
            temp_negative = (temp_result[31] == 1'b1)? 1'b1 : 1'b0;
            temp_zero = (temp_result == 32'd0)? 1'b1 : 1'b0;
            temp_flag = 1'b0;
        end
        default: begin
            temp_result = 32'bx;
            temp_carry = 1'bx;
            temp_overflow = 1'bx;
            temp_negative = 1'bx;
            temp_zero = 1'bx;
            temp_flag = 1'bx;
        end
    endcase
    r <= temp_result;
    zero <= temp_zero;
    carry <= temp_carry;
    negative <= temp_negative;
    overflow <= temp_overflow;
    flag <= temp_flag;
end

endmodule