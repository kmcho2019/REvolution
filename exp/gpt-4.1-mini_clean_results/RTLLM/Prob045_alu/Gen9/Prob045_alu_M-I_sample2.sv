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

// Internal signals for signed interpretation
wire signed [31:0] a_s = $signed(a);
wire signed [31:0] b_s = $signed(b);

// Shift amount from a[4:0]
wire [4:0] shamt_imm = a[4:0];
wire [4:0] shamt_var = a[4:0]; // For variable shifts, a encodes shift amount

// Shared 33-bit adder/subtractor input and output
reg [32:0] adder_in_a, adder_in_b;
wire [32:0] adder_sum;

// Internal flags for arithmetic
reg add_sub_carry;
reg add_sub_overflow;

// Instantiate a 33-bit adder/subtractor
// Adder inputs are assigned dynamically depending on operation
assign adder_sum = adder_in_a + adder_in_b;

// Main combinational ALU logic
always @(*) begin
    // Default assignments
    r = 32'b0;
    carry = 1'b0;
    negative = 1'b0;
    overflow = 1'b0;
    flag = 1'b0;

    // Setup adder inputs default to zero
    adder_in_a = 33'b0;
    adder_in_b = 33'b0;

    case (aluc)
        // ADD and ADDU share addition hardware, same operands
        ADD, ADDU: begin
            adder_in_a = {1'b0, a};
            adder_in_b = {1'b0, b};
            r = adder_sum[31:0];
            carry = adder_sum[32];

            // Overflow only for ADD (signed)
            if (aluc == ADD) begin
                // Overflow occurs if sign of a and b are same but sign of r differs
                overflow = (~a[31] & ~b[31] & r[31]) | (a[31] & b[31] & ~r[31]);
            end else begin
                overflow = 1'b0;
            end
        end

        // SUB and SUBU share subtract hardware: a - b = a + (~b + 1)
        SUB, SUBU: begin
            adder_in_a = {1'b0, a};
            // Two's complement: invert b and add 1
            adder_in_b = {1'b0, ~b} + 33'b1;
            r = adder_sum[31:0];
            carry = adder_sum[32]; // Carry out for subtraction: borrow indicator in MIPS is carry==0 means borrow

            // Overflow only for SUB (signed)
            if (aluc == SUB) begin
                // Overflow occurs if signs of a and b differ and sign of r differs from a
                overflow = (a[31] & ~b[31] & ~r[31]) | (~a[31] & b[31] & r[31]);
            end else begin
                overflow = 1'b0;
            end
        end

        // Logical operations
        AND: r = a & b;
        OR:  r = a | b;
        XOR: r = a ^ b;
        NOR: r = ~(a | b);

        // Set less than (signed)
        SLT: begin
            r = 32'b0;
            flag = (a_s < b_s) ? 1'b1 : 1'b0;
            r[0] = flag;
        end

        // Set less than unsigned
        SLTU: begin
            r = 32'b0;
            flag = (a < b) ? 1'b1 : 1'b0;
            r[0] = flag;
        end

        // Shift left logical variable (shift amount in a[4:0])
        SLLV: r = b << shamt_var;
        // Shift right logical variable
        SRLV: r = b >> shamt_var;
        // Shift right arithmetic variable
        SRAV: r = $signed(b_s) >>> shamt_var;

        // Shift left logical immediate (shift amount in a[4:0])
        SLL: r = b << shamt_imm;
        // Shift right logical immediate
        SRL: r = b >> shamt_imm;
        // Shift right arithmetic immediate
        SRA: r = $signed(b_s) >>> shamt_imm;

        // Load upper immediate: MIPS LUI convention, immediate comes from b[15:0]
        LUI: r = {b[15:0], 16'b0};

        default: begin
            r = 32'b0;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
    endcase

    // Set negative flag from MSB of result
    negative = r[31];
end

// Zero flag is combinational, based on r output
assign zero = (r == 32'b0);

endmodule