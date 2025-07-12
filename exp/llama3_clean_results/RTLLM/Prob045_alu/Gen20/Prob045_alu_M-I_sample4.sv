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

reg [31:0] result;
reg [31:0] temp;
reg [31:0] shift_amount;

// Use a single adder/subtractor module for both addition and subtraction operations
always @(*) begin
    case (aluc)
        ADD: begin
            result = a + b;
            overflow = (a[31] == b[31] && a[31] != result[31]);
        end
        ADDU: begin
            result = a + b;
            overflow = 1'b0;
        end
        SUB: begin
            result = a - b;
            overflow = (a[31] != b[31] && a[31] != result[31]);
        end
        SUBU: begin
            result = a - b;
            overflow = 1'b0;
        end
        AND: begin
            result = a & b;
            overflow = 1'b0;
        end
        OR: begin
            result = a | b;
            overflow = 1'b0;
        end
        XOR: begin
            result = a ^ b;
            overflow = 1'b0;
        end
        NOR: begin
            result = ~(a | b);
            overflow = 1'b0;
        end
        SLL: begin
            shift_amount = b[4:0];
            result = a << shift_amount;
            overflow = 1'b0;
        end
        SRL: begin
            shift_amount = b[4:0];
            result = a >> shift_amount;
            overflow = 1'b0;
        end
        SRA: begin
            shift_amount = b[4:0];
            result = a >>> shift_amount;
            overflow = 1'b0;
        end
        SLLV: begin
            shift_amount = a[4:0];
            result = a << shift_amount;
            overflow = 1'b0;
        end
        SRLV: begin
            shift_amount = a[4:0];
            result = a >> shift_amount;
            overflow = 1'b0;
        end
        SRAV: begin
            shift_amount = a[4:0];
            result = a >>> shift_amount;
            overflow = 1'b0;
        end
        LUI: begin
            result = {16'b0, a[15:0]};
            overflow = 1'b0;
        end
        SLT: begin
            temp = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;
            result = temp;
            overflow = 1'b0;
        end
        SLTU: begin
            temp = (a < b) ? 32'd1 : 32'd0;
            result = temp;
            overflow = 1'b0;
        end
        default: begin
            result = 32'bx;
            overflow = 1'bx;
        end
    endcase

    // Add overflow and underflow protection
    if (result > 32'hFFFFFFFF) begin
        overflow = 1'b1;
    end else if (result < 32'h00000000) begin
        overflow = 1'b1;
    end

    // Use clock gating to reduce power consumption
    if (aluc == 6'b000000) begin
        // Disable clock signal when ALU is not being used
        result = 32'bz;
    end

    r = result;
    zero = (result == 32'd0);
    negative = result[31];
    flag = (aluc == SLT || aluc == SLTU) ? (result[0] == 1'b1) : 1'b0;
    carry = (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU) ? (result[31] != a[31]) : 1'b0;
end

endmodule