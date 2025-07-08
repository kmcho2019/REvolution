module alu (
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

    // Operation codes
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

    wire [31:0] b_inv = ~b + 1'b1; // For subtraction

    wire [32:0] add_result;
    wire [32:0] sub_result;

    reg [31:0] b_shift;
    reg [4:0] shift_amt;

    // signed versions for overflow detection and SLT
    wire signed [31:0] a_signed = a;
    wire signed [31:0] b_signed = b;

    // For addition and subtraction with carry
    wire [32:0] add_ext = {1'b0, a} + {1'b0, b};
    wire [32:0] sub_ext = {1'b0, a} + {1'b0, (~b + 1'b1)};

    // Helper wires for SLT and SLTU
    wire slt_flag = (a_signed < b_signed) ? 1'b1 : 1'b0;
    wire sltu_flag = (a < b) ? 1'b1 : 1'b0;

    always @(*) begin
        // Default outputs
        r = 32'bz;
        carry = 1'b0;
        overflow = 1'b0;
        flag = 1'bz;

        case (aluc)
            ADD: begin
                {carry, r} = a + b;
                // Detect overflow for signed addition:
                // If sign(a)==sign(b) and sign(r)!=sign(a), overflow
                overflow = (~a[31] & ~b[31] & r[31]) | (a[31] & b[31] & ~r[31]);
                flag = 1'bz;
            end

            ADDU: begin
                {carry, r} = a + b;
                overflow = 1'b0;
                flag = 1'bz;
            end

            SUB: begin
                {carry, r} = a - b;
                // Detect overflow for signed subtraction:
                // If sign(a)!=sign(b) and sign(r)!=sign(a), overflow
                overflow = (~a[31] & b[31] & r[31]) | (a[31] & ~b[31] & ~r[31]);
                flag = 1'bz;
            end

            SUBU: begin
                {carry, r} = a - b;
                overflow = 1'b0;
                flag = 1'bz;
            end

            AND: begin
                r = a & b;
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end

            OR: begin
                r = a | b;
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end

            XOR: begin
                r = a ^ b;
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end

            NOR: begin
                r = ~(a | b);
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end

            SLT: begin
                r = 32'b0;
                r[0] = slt_flag;
                carry = 1'b0;
                overflow = 1'b0;
                flag = slt_flag;
            end

            SLTU: begin
                r = 32'b0;
                r[0] = sltu_flag;
                carry = 1'b0;
                overflow = 1'b0;
                flag = sltu_flag;
            end

            SLL: begin
                r = b << a[4:0];
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end

            SRL: begin
                r = b >> a[4:0];
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end

            SRA: begin
                r = $signed(b) >>> a[4:0];
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end

            SLLV: begin
                r = b << (a[4:0]);
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end

            SRLV: begin
                r = b >> (a[4:0]);
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end

            SRAV: begin
                r = $signed(b) >>> (a[4:0]);
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end

            LUI: begin
                r = {b[15:0], 16'b0};
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end

            default: begin
                r = 32'bz;
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end
        endcase
    end

    assign zero = (r == 32'b0) ? 1'b1 : 1'b0;
    assign negative = r[31];

endmodule