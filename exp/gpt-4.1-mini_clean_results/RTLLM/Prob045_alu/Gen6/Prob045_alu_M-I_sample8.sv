module alu(
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [5:0]  aluc,
    output reg  [31:0] r,
    output wire        zero,
    output reg         carry,
    output wire        negative,
    output reg         overflow,
    output reg         flag
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

// Signed versions of inputs
wire signed [31:0] a_s = $signed(a);
wire signed [31:0] b_s = $signed(b);

// Shift amounts for immediate and variable shift
wire [4:0] shamt_imm = a[4:0];
wire [4:0] shamt_var = a[4:0];

// Combinational flags
assign negative = r[31];
assign zero = (r == 32'b0);

always @(*) begin
    // Defaults
    r = 32'b0;
    carry = 1'b0;
    overflow = 1'b0;
    flag = 1'b0;

    case (aluc)
        ADD: begin
            // Signed addition with overflow
            {carry, r} = a + b;
            // Overflow detection for signed add
            overflow = (~a[31] & ~b[31] & r[31]) | (a[31] & b[31] & ~r[31]);
        end
        ADDU: begin
            // Unsigned addition
            {carry, r} = a + b;
            overflow = 1'b0;
        end
        SUB: begin
            // Signed subtraction with overflow
            {carry, r} = a - b;
            // Overflow detection for signed sub
            overflow = (a[31] & ~b[31] & ~r[31]) | (~a[31] & b[31] & r[31]);
        end
        SUBU: begin
            // Unsigned subtraction
            {carry, r} = a - b;
            overflow = 1'b0;
        end
        AND: begin
            r = a & b;
            carry = 1'b0;
            overflow = 1'b0;
        end
        OR: begin
            r = a | b;
            carry = 1'b0;
            overflow = 1'b0;
        end
        XOR: begin
            r = a ^ b;
            carry = 1'b0;
            overflow = 1'b0;
        end
        NOR: begin
            r = ~(a | b);
            carry = 1'b0;
            overflow = 1'b0;
        end
        SLT: begin
            r = (a_s < b_s) ? 32'b1 : 32'b0;
            carry = 1'b0;
            overflow = 1'b0;
            flag = (a_s < b_s) ? 1'b1 : 1'b0;
        end
        SLTU: begin
            r = (a < b) ? 32'b1 : 32'b0;
            carry = 1'b0;
            overflow = 1'b0;
            flag = (a < b) ? 1'b1 : 1'b0;
        end
        SLL: begin
            r = b << shamt_imm;
            carry = 1'b0;
            overflow = 1'b0;
        end
        SRL: begin
            r = b >> shamt_imm;
            carry = 1'b0;
            overflow = 1'b0;
        end
        SRA: begin
            r = $signed(b_s) >>> shamt_imm;
            carry = 1'b0;
            overflow = 1'b0;
        end
        SLLV: begin
            r = b << shamt_var;
            carry = 1'b0;
            overflow = 1'b0;
        end
        SRLV: begin
            r = b >> shamt_var;
            carry = 1'b0;
            overflow = 1'b0;
        end
        SRAV: begin
            r = $signed(b_s) >>> shamt_var;
            carry = 1'b0;
            overflow = 1'b0;
        end
        LUI: begin
            r = {b[15:0], 16'b0};  // Load upper immediate from lower half of b
            carry = 1'b0;
            overflow = 1'b0;
        end
        default: begin
            r = 32'b0;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
    endcase
end

endmodule