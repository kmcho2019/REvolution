module alu(
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [5:0]  aluc,
    output reg  [31:0] r,
    output wire        zero,
    output reg         carry,
    output reg         negative,
    output reg         overflow,
    output reg         flag
);

// Define opcodes as parameters
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

// Pre-cast signed operands once
wire signed [31:0] a_s = $signed(a);
wire signed [31:0] b_s = $signed(b);

// Shift amount (from a[4:0]) for fixed shifts
wire [4:0] shamt = a[4:0];

always @(*) begin
    // Default assignments
    r = 32'b0;
    carry = 1'b0;
    overflow = 1'b0;
    flag = 1'b0;
    negative = 1'b0;

    case (aluc)
        ADD: begin
            {carry, r} = {1'b0, a} + {1'b0, b};
            // Overflow if sign of a == sign of b and sign of result != sign of a
            overflow = (a[31] == b[31]) && (r[31] != a[31]);
        end
        ADDU: begin
            {carry, r} = {1'b0, a} + {1'b0, b};
            overflow = 1'b0;
        end
        SUB: begin
            {carry, r} = {1'b0, a} - {1'b0, b};
            // Overflow if sign of a != sign of b and sign of result != sign of a
            overflow = (a[31] != b[31]) && (r[31] != a[31]);
        end
        SUBU: begin
            {carry, r} = {1'b0, a} - {1'b0, b};
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
            // Signed less-than
            flag = (a_s < b_s) ? 1'b1 : 1'b0;
            r = {31'b0, flag};
            carry = 1'b0;
            overflow = 1'b0;
        end
        SLTU: begin
            // Unsigned less-than
            flag = (a < b) ? 1'b1 : 1'b0;
            r = {31'b0, flag};
            carry = 1'b0;
            overflow = 1'b0;
        end
        SLL: begin
            // Shift b left by immediate shamt from a[4:0]
            r = b << shamt;
        end
        SRL: begin
            r = b >> shamt;
        end
        SRA: begin
            r = $signed(b_s) >>> shamt;
        end
        SLLV: begin
            // Variable shift by a[4:0]
            r = b << a[4:0];
        end
        SRLV: begin
            r = b >> a[4:0];
        end
        SRAV: begin
            r = $signed(b_s) >>> a[4:0];
        end
        LUI: begin
            // Load upper immediate: a[15:0] in upper half, lower half zero
            r = {a[15:0], 16'b0};
        end
        default: begin
            // For unsupported opcodes, outputs remain defaults (zeros)
        end
    endcase

    // negative flag from MSB of result
    negative = r[31];
end

// zero flag high if result is zero
assign zero = (r == 32'b0);

endmodule