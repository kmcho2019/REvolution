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

// Adder/Subtractor
always @(*) begin
    case (aluc)
        ADD: temp = a + b;
        ADDU: temp = a + b;
        SUB: temp = a - b;
        SUBU: temp = a - b;
        default: temp = 32'bx;
    endcase
end

// Bitwise operations
always @(*) begin
    case (aluc)
        AND: result = a & b;
        OR: result = a | b;
        XOR: result = a ^ b;
        NOR: result = ~(a | b);
        default: result = 32'bx;
    endcase
end

// Shift operations
always @(*) begin
    case (aluc)
        SLL: result = a << b[4:0];
        SRL: result = a >> b[4:0];
        SRA: result = a >>> b[4:0];
        SLLV: result = a << a[4:0];
        SRLV: result = a >> a[4:0];
        SRAV: result = a >>> a[4:0];
        default: result = 32'bx;
    endcase
end

// SLT and SLTU operations
always @(*) begin
    case (aluc)
        SLT: result = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;
        SLTU: result = (a < b) ? 32'd1 : 32'd0;
        default: result = 32'bx;
    endcase
end

// LUI operation
always @(*) begin
    case (aluc)
        LUI: result = {16'b0, a[15:0]};
        default: result = 32'bx;
    endcase
end

// Assign outputs
always @(*) begin
    case (aluc)
        ADD: begin
            {carry, r} = temp;
            overflow = (a[31] == b[31] && a[31] != r[31]);
            flag = 1'b0;
        end
        ADDU: begin
            {carry, r} = temp;
            overflow = 1'b0;
            flag = 1'b0;
        end
        SUB: begin
            {carry, r} = temp;
            overflow = (a[31] != b[31] && a[31] != r[31]);
            flag = 1'b0;
        end
        SUBU: begin
            {carry, r} = temp;
            overflow = 1'b0;
            flag = 1'b0;
        end
        AND: begin
            r = result;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
        OR: begin
            r = result;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
        XOR: begin
            r = result;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
        NOR: begin
            r = result;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
        SLL: begin
            r = result;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
        SRL: begin
            r = result;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
        SRA: begin
            r = result;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
        SLLV: begin
            r = result;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
        SRLV: begin
            r = result;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
        SRAV: begin
            r = result;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
        LUI: begin
            r = result;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
        SLT: begin
            r = result;
            flag = $signed(a) < $signed(b);
            carry = 1'b0;
            overflow = 1'b0;
        end
        SLTU: begin
            r = result;
            flag = a < b;
            carry = 1'b0;
            overflow = 1'b0;
        end
        default: begin
            r = 32'bx;
            carry = 1'bx;
            overflow = 1'bx;
            flag = 1'bx;
        end
    endcase

    zero = (r == 32'd0);
    negative = r[31];
end

endmodule