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
    // Parameters for operation codes
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

    // Internal signals for arithmetic computations
    reg [32:0] sum;      // 33-bit sum for carry detection
    reg [32:0] diff;     // 33-bit diff for carry detection
    wire [4:0] shamt;    // shift amount for variable shifts

    assign shamt = a[4:0];

    // zero flag: 1 if r == 0 else 0
    assign zero = (r == 32'b0);

    always @(*) begin
        // Default assignments
        r = 32'bz;
        carry = 1'b0;
        negative = 1'b0;
        overflow = 1'b0;
        flag = 1'bz;

        case(aluc)
            ADD: begin
                // signed addition with overflow detection
                sum = {1'b0, a} + {1'b0, b};
                r = sum[31:0];
                carry = sum[32]; // carry out of bit 31
                negative = r[31];
                // overflow for addition: if sign of a == sign of b but sign of result differs
                overflow = (~a[31] & ~b[31] & r[31]) | (a[31] & b[31] & ~r[31]);
                flag = 1'bz;
            end
            ADDU: begin
                sum = {1'b0, a} + {1'b0, b};
                r = sum[31:0];
                carry = sum[32];
                negative = r[31];
                overflow = 1'b0; // unsigned addition no overflow
                flag = 1'bz;
            end
            SUB: begin
                // signed subtraction: a - b = a + (~b + 1)
                diff = {1'b0, a} - {1'b0, b};
                r = diff[31:0];
                carry = ~diff[32]; 
                // carry in subtraction: borrow = ~carry_out, carry = ~borrow. Here we keep carry as ~diff[32]
                negative = r[31];
                // overflow for subtraction: if a sign != b sign and sign of result != sign of a
                overflow = (a[31] & ~b[31] & ~r[31]) | (~a[31] & b[31] & r[31]);
                flag = 1'bz;
            end
            SUBU: begin
                diff = {1'b0, a} - {1'b0, b};
                r = diff[31:0];
                carry = ~diff[32];
                negative = r[31];
                overflow = 1'b0;
                flag = 1'bz;
            end
            AND: begin
                r = a & b;
                carry = 1'b0;
                negative = r[31];
                overflow = 1'b0;
                flag = 1'bz;
            end
            OR: begin
                r = a | b;
                carry = 1'b0;
                negative = r[31];
                overflow = 1'b0;
                flag = 1'bz;
            end
            XOR: begin
                r = a ^ b;
                carry = 1'b0;
                negative = r[31];
                overflow = 1'b0;
                flag = 1'bz;
            end
            NOR: begin
                r = ~(a | b);
                carry = 1'b0;
                negative = r[31];
                overflow = 1'b0;
                flag = 1'bz;
            end
            SLT: begin
                // set on less than (signed)
                flag = ($signed(a) < $signed(b)) ? 1'b1 : 1'b0;
                r = 32'b0;  // Result zero as per convention
                carry = 1'b0;
                negative = 1'b0;
                overflow = 1'b0;
            end
            SLTU: begin
                // set on less than unsigned
                flag = (a < b) ? 1'b1 : 1'b0;
                r = 32'b0;  // Result zero as per convention
                carry = 1'b0;
                negative = 1'b0;
                overflow = 1'b0;
            end
            SLL: begin
                r = b << a[4:0];
                carry = 1'b0;
                negative = r[31];
                overflow = 1'b0;
                flag = 1'bz;
            end
            SRL: begin
                r = b >> a[4:0];
                carry = 1'b0;
                negative = r[31];
                overflow = 1'b0;
                flag = 1'bz;
            end
            SRA: begin
                r = $signed(b) >>> a[4:0];
                carry = 1'b0;
                negative = r[31];
                overflow = 1'b0;
                flag = 1'bz;
            end
            SLLV: begin
                r = b << shamt;
                carry = 1'b0;
                negative = r[31];
                overflow = 1'b0;
                flag = 1'bz;
            end
            SRLV: begin
                r = b >> shamt;
                carry = 1'b0;
                negative = r[31];
                overflow = 1'b0;
                flag = 1'bz;
            end
            SRAV: begin
                r = $signed(b) >>> shamt;
                carry = 1'b0;
                negative = r[31];
                overflow = 1'b0;
                flag = 1'bz;
            end
            LUI: begin
                // Load upper immediate: loads immediate from lower 16 bits of b shifted to upper half
                r = {b[15:0], 16'b0};
                carry = 1'b0;
                negative = r[31];
                overflow = 1'b0;
                flag = 1'bz;
            end
            default: begin
                r = 32'bz;
                carry = 1'b0;
                negative = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end
        endcase
    end
endmodule