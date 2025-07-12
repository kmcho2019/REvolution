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

// Shared shift logic
reg [31:0] shift_result;

always @(*) begin
    case (aluc)
        // Arithmetic operations
        ADD: begin
            // Add two signed numbers
            {carry, r} = a + b;
            overflow = (a[31] == b[31] && a[31] != r[31]);
        end
        ADDU: begin
            // Add two unsigned numbers
            {carry, r} = a + b;
            overflow = 1'b0;
        end
        SUB: begin
            // Subtract two signed numbers
            {carry, r} = a - b;
            overflow = (a[31] != b[31] && a[31] != r[31]);
        end
        SUBU: begin
            // Subtract two unsigned numbers
            {carry, r} = a - b;
            overflow = 1'b0;
        end
        
        // Bitwise operations
        AND: begin
            // Bitwise AND
            r = a & b;
            carry = 1'b0;
            overflow = 1'b0;
        end
        OR: begin
            // Bitwise OR
            r = a | b;
            carry = 1'b0;
            overflow = 1'b0;
        end
        XOR: begin
            // Bitwise XOR
            r = a ^ b;
            carry = 1'b0;
            overflow = 1'b0;
        end
        NOR: begin
            // Bitwise NOR
            r = ~(a | b);
            carry = 1'b0;
            overflow = 1'b0;
        end
        
        // Shift operations
        SLL: begin
            // Shift left logical
            r = a << b[4:0];
            carry = 1'b0;
            overflow = 1'b0;
        end
        SRL: begin
            // Shift right logical
            r = a >> b[4:0];
            carry = 1'b0;
            overflow = 1'b0;
        end
        SRA: begin
            // Shift right arithmetic
            r = $signed(a) >>> b[4:0];
            carry = 1'b0;
            overflow = 1'b0;
        end
        SLLV: begin
            // Shift left logical variable
            r = a << a[4:0];
            carry = 1'b0;
            overflow = 1'b0;
        end
        SRLV: begin
            // Shift right logical variable
            r = a >> a[4:0];
            carry = 1'b0;
            overflow = 1'b0;
        end
        SRAV: begin
            // Shift right arithmetic variable
            r = $signed(a) >>> a[4:0];
            carry = 1'b0;
            overflow = 1'b0;
        end
        
        // Load upper immediate
        LUI: begin
            r = {16'b0, a[15:0]};
            carry = 1'b0;
            overflow = 1'b0;
        end
        
        // Set less than
        SLT: begin
            r = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;
            flag = ($signed(a) < $signed(b));
            carry = 1'b0;
            overflow = 1'b0;
        end
        
        // Set less than unsigned
        SLTU: begin
            r = (a < b) ? 32'd1 : 32'd0;
            flag = (a < b);
            carry = 1'b0;
            overflow = 1'b0;
        end
        
        // Unknown operation
        default: begin
            r = 32'bx;
            carry = 1'bx;
            overflow = 1'bx;
            flag = 1'bx;
        end
    endcase

    // Calculate flags
    zero = (r == 32'd0);
    negative = r[31];
end

endmodule