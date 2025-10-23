module alu(
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [5:0]  aluc,
    output reg  [31:0] r,
    output reg         zero,
    output reg         carry,
    output reg         negative,
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
wire signed [31:0] a_signed = $signed(a);
wire signed [31:0] b_signed = $signed(b);

reg [31:0] res;
reg       res_carry;
reg       res_overflow;
reg       res_flag;
reg       res_zero;
reg       res_negative;

reg [4:0] shamt; // shift amount

always @(*) begin
    // Default outputs
    res = 32'b0;
    res_carry = 1'b0;
    res_overflow = 1'b0;
    res_flag = 1'b0;

    case(aluc)
        // Arithmetic signed add
        ADD: begin
            {res_carry, res} = {1'b0, a} + {1'b0, b};
            // Overflow: if signs of inputs are same and sign of result differs
            res_overflow = (~a[31] & ~b[31] & res[31]) | (a[31] & b[31] & ~res[31]);
            res_flag = 1'b0;
        end

        // Arithmetic unsigned add (no overflow)
        ADDU: begin
            {res_carry, res} = {1'b0, a} + {1'b0, b};
            res_overflow = 1'b0;
            res_flag = 1'b0;
        end

        // Arithmetic signed subtract
        SUB: begin
            {res_carry, res} = {1'b0, a} - {1'b0, b};
            // Overflow: if signs of a and b differ and sign of result differs from a
            res_overflow = (a[31] & ~b[31] & ~res[31]) | (~a[31] & b[31] & res[31]);
            res_flag = 1'b0;
        end

        // Arithmetic unsigned subtract (no overflow)
        SUBU: begin
            {res_carry, res} = {1'b0, a} - {1'b0, b};
            res_overflow = 1'b0;
            res_flag = 1'b0;
        end

        // Logical AND
        AND: begin
            res = a & b;
            res_carry = 1'b0;
            res_overflow = 1'b0;
            res_flag = 1'b0;
        end

        // Logical OR
        OR: begin
            res = a | b;
            res_carry = 1'b0;
            res_overflow = 1'b0;
            res_flag = 1'b0;
        end

        // Logical XOR
        XOR: begin
            res = a ^ b;
            res_carry = 1'b0;
            res_overflow = 1'b0;
            res_flag = 1'b0;
        end

        // Logical NOR
        NOR: begin
            res = ~(a | b);
            res_carry = 1'b0;
            res_overflow = 1'b0;
            res_flag = 1'b0;
        end

        // Set less than (signed)
        SLT: begin
            res = (a_signed < b_signed) ? 32'd1 : 32'd0;
            res_carry = 1'b0;
            res_overflow = 1'b0;
            res_flag = (a_signed < b_signed);
        end

        // Set less than unsigned
        SLTU: begin
            res = (a < b) ? 32'd1 : 32'd0;
            res_carry = 1'b0;
            res_overflow = 1'b0;
            res_flag = (a < b);
        end

        // Shift left logical
        SLL: begin
            shamt = a[4:0];
            res = b << shamt;
            res_carry = 1'b0;
            res_overflow = 1'b0;
            res_flag = 1'b0;
        end

        // Shift right logical
        SRL: begin
            shamt = a[4:0];
            res = b >> shamt;
            res_carry = 1'b0;
            res_overflow = 1'b0;
            res_flag = 1'b0;
        end

        // Shift right arithmetic
        SRA: begin
            shamt = a[4:0];
            res = $signed(b_signed) >>> shamt;
            res_carry = 1'b0;
            res_overflow = 1'b0;
            res_flag = 1'b0;
        end

        // Variable shift left logical
        SLLV: begin
            shamt = a[4:0];
            res = b << shamt;
            res_carry = 1'b0;
            res_overflow = 1'b0;
            res_flag = 1'b0;
        end

        // Variable shift right logical
        SRLV: begin
            shamt = a[4:0];
            res = b >> shamt;
            res_carry = 1'b0;
            res_overflow = 1'b0;
            res_flag = 1'b0;
        end

        // Variable shift right arithmetic
        SRAV: begin
            shamt = a[4:0];
            res = $signed(b_signed) >>> shamt;
            res_carry = 1'b0;
            res_overflow = 1'b0;
            res_flag = 1'b0;
        end

        // Load upper immediate (upper 16 bits of a, lower 16 bits zero)
        LUI: begin
            res = {a[31:16], 16'b0};
            res_carry = 1'b0;
            res_overflow = 1'b0;
            res_flag = 1'b0;
        end

        // Default undefined operation: drive result to zero and flags off
        default: begin
            res = 32'b0;
            res_carry = 1'b0;
            res_overflow = 1'b0;
            res_flag = 1'b0;
        end
    endcase

    res_negative = res[31];
    res_zero = (res == 32'b0);

    // Assign output signals
    r = res;
    carry = res_carry;
    overflow = res_overflow;
    negative = res_negative;
    zero = res_zero;
    flag = res_flag;  // Defined zero when no SLT/SLTU to avoid 'z'
end

endmodule