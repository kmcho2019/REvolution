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

// Internal wires for temporary results
wire [31:0] temp_result;
wire temp_carry;
wire temp_overflow;

// Calculate flags
always @(*) begin
    case (aluc)
        ADD: begin
            {temp_carry, temp_result} = a + b;
            temp_overflow = (a[31] == b[31] && a[31] != temp_result[31]);
        end
        ADDU: begin
            {temp_carry, temp_result} = a + b;
            temp_overflow = 1'b0;
        end
        SUB: begin
            {temp_carry, temp_result} = a - b;
            temp_overflow = (a[31] != b[31] && a[31] != temp_result[31]);
        end
        SUBU: begin
            {temp_carry, temp_result} = a - b;
            temp_overflow = 1'b0;
        end
        AND: begin
            temp_result = a & b;
            temp_carry = 1'b0;
            temp_overflow = 1'b0;
        end
        OR: begin
            temp_result = a | b;
            temp_carry = 1'b0;
            temp_overflow = 1'b0;
        end
        XOR: begin
            temp_result = a ^ b;
            temp_carry = 1'b0;
            temp_overflow = 1'b0;
        end
        NOR: begin
            temp_result = ~(a | b);
            temp_carry = 1'b0;
            temp_overflow = 1'b0;
        end
        SLL: begin
            temp_result = a << b[4:0];
            temp_carry = 1'b0;
            temp_overflow = 1'b0;
        end
        SRL: begin
            temp_result = a >> b[4:0];
            temp_carry = 1'b0;
            temp_overflow = 1'b0;
        end
        SRA: begin
            temp_result = $signed(a) >>> b[4:0];
            temp_carry = 1'b0;
            temp_overflow = 1'b0;
        end
        SLLV: begin
            temp_result = a << a[4:0];
            temp_carry = 1'b0;
            temp_overflow = 1'b0;
        end
        SRLV: begin
            temp_result = a >> a[4:0];
            temp_carry = 1'b0;
            temp_overflow = 1'b0;
        end
        SRAV: begin
            temp_result = $signed(a) >>> a[4:0];
            temp_carry = 1'b0;
            temp_overflow = 1'b0;
        end
        LUI: begin
            temp_result = {16'b0, a[15:0]};
            temp_carry = 1'b0;
            temp_overflow = 1'b0;
        end
        SLT: begin
            temp_result = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;
            flag = ($signed(a) < $signed(b));
            temp_carry = 1'b0;
            temp_overflow = 1'b0;
        end
        SLTU: begin
            temp_result = (a < b) ? 32'd1 : 32'd0;
            flag = (a < b);
            temp_carry = 1'b0;
            temp_overflow = 1'b0;
        end
        default: begin
            temp_result = 32'bx;
            temp_carry = 1'bx;
            temp_overflow = 1'bx;
            flag = 1'bx;
        end
    endcase

    r = temp_result;
    carry = temp_carry;
    overflow = temp_overflow;
    zero = (temp_result == 32'd0);
    negative = temp_result[31];
end

endmodule