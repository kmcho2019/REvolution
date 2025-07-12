module alu(
    input  [31:0] a,
    input  [31:0] b,
    input  [5:0]  aluc,
    output reg [31:0] r,
    output zero,
    output reg carry,
    output negative,
    output reg overflow,
    output reg flag
);

// Opcode parameters
parameter ADD  = 6'b100000;
parameter ADDU = 6'b100001;
parameter SUB  = 6'b100010;
parameter SUBU = 6'b100011;
parameter AND  = 6'b100100;
parameter OR   = 6'b100101;
parameter XOR  = 6'b100110;
parameter NOR  = 6'b100111;
parameter SLT  = 6'b101010;
parameter SLTU = 6'b101011;
parameter SLL  = 6'b000000;
parameter SRL  = 6'b000010;
parameter SRA  = 6'b000011;
parameter SLLV = 6'b000100;
parameter SRLV = 6'b000110;
parameter SRAV = 6'b000111;
parameter LUI  = 6'b001111;

// Signed versions for signed operations
wire signed [31:0] a_signed = a;
wire signed [31:0] b_signed = b;

// Shift amounts extracted
wire [4:0] shamt = a[4:0]; // Used for both immediate and variable shifts as per problem statement

always @(*) begin
    // Default outputs
    r = 32'b0;
    carry = 1'b0;
    overflow = 1'b0;
    flag = 1'b0;

    case (aluc)
        ADD: begin
            // Signed addition
            {carry, r} = {1'b0, a_signed} + {1'b0, b_signed};
            // Overflow detection for signed addition
            // Overflow if signs of a and b are same and sign of result differs
            overflow = (~a_signed[31] & ~b_signed[31] & r[31]) | (a_signed[31] & b_signed[31] & ~r[31]);
        end
        ADDU: begin
            // Unsigned addition
            {carry, r} = a + b;
            overflow = 1'b0; // No overflow in unsigned addition
        end
        SUB: begin
            // Signed subtraction: a - b
            {carry, r} = {1'b0, a_signed} - {1'b0, b_signed};
            // Carry in subtraction is 'borrow not', i.e., carry=1 if no borrow
            carry = (a >= b) ? 1'b1 : 1'b0;
            // Overflow detection for signed subtraction
            // Overflow if signs of a and b differ and sign of result differs from sign of a
            overflow = (a_signed[31] ^ b_signed[31]) & (r[31] ^ a_signed[31]);
        end
        SUBU: begin
            // Unsigned subtraction: a - b
            {carry, r} = {1'b0, a} - {1'b0, b};
            carry = (a >= b) ? 1'b1 : 1'b0; // carry means no borrow
            overflow = 1'b0;
        end
        AND: begin
            r = a & b;
        end
        OR: begin
            r = a | b;
        end
        XOR: begin
            r = a ^ b;
        end
        NOR: begin
            r = ~(a | b);
        end
        SLT: begin
            // Set flag and result[0] to 1 if a < b signed
            flag = (a_signed < b_signed) ? 1'b1 : 1'b0;
            r = 32'b0;
            r[0] = flag;
        end
        SLTU: begin
            // Set flag and result[0] to 1 if a < b unsigned
            flag = (a < b) ? 1'b1 : 1'b0;
            r = 32'b0;
            r[0] = flag;
        end
        SLL: begin
            r = b << shamt;
        end
        SRL: begin
            r = b >> shamt;
        end
        SRA: begin
            r = $signed(b) >>> shamt;
        end
        SLLV: begin
            r = b << shamt;
        end
        SRLV: begin
            r = b >> shamt;
        end
        SRAV: begin
            r = $signed(b) >>> shamt;
        end
        LUI: begin
            r = {b[15:0], 16'b0};
        end
        default: begin
            r = 32'b0;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
    endcase
end

assign zero = (r == 32'b0);
assign negative = r[31];

endmodule