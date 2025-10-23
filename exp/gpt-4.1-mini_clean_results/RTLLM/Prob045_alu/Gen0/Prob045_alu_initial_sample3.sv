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

    wire signed [31:0] a_signed = a;
    wire signed [31:0] b_signed = b;
    reg  [32:0]        sum;       // For carry detection (1 extra bit)
    reg  [32:0]        diff;      // For carry detection on subtraction

    always @* begin
        carry    = 1'b0;
        overflow = 1'b0;
        flag     = 1'bz;  // default high impedance
        r        = 32'bz;

        case (aluc)
            ADD: begin
                sum = {1'b0, a} + {1'b0, b};
                r = sum[31:0];
                carry = sum[32];
                // Overflow detection for signed add:
                // If a and b have same sign and result has different sign -> overflow
                overflow = (~a[31] & ~b[31] & r[31]) | (a[31] & b[31] & ~r[31]);
                negative = r[31];
            end
            ADDU: begin
                sum = {1'b0, a} + {1'b0, b};
                r = sum[31:0];
                carry = sum[32];
                overflow = 1'b0;
                negative = r[31];
            end
            SUB: begin
                diff = {1'b0, a} - {1'b0, b};
                r = diff[31:0];
                carry = ~diff[32]; // borrow: if diff[32] = 0 means no borrow => carry=1; MIPS usually carry is ~borrow
                // Overflow detection for signed subtract:
                // If a and b have different signs and result sign differs from a's sign, overflow
                overflow = (a[31] & ~b[31] & ~r[31]) | (~a[31] & b[31] & r[31]);
                negative = r[31];
            end
            SUBU: begin
                diff = {1'b0, a} - {1'b0, b};
                r = diff[31:0];
                carry = ~diff[32];
                overflow = 1'b0;
                negative = r[31];
            end
            AND: begin
                r = a & b;
                carry = 1'b0;
                overflow = 1'b0;
                negative = r[31];
            end
            OR: begin
                r = a | b;
                carry = 1'b0;
                overflow = 1'b0;
                negative = r[31];
            end
            XOR: begin
                r = a ^ b;
                carry = 1'b0;
                overflow = 1'b0;
                negative = r[31];
            end
            NOR: begin
                r = ~(a | b);
                carry = 1'b0;
                overflow = 1'b0;
                negative = r[31];
            end
            SLT: begin
                // signed comparison
                flag = (a_signed < b_signed) ? 1'b1 : 1'b0;
                r = {31'b0, flag};
                carry = 1'b0;
                overflow = 1'b0;
                negative = r[31];
            end
            SLTU: begin
                // unsigned comparison
                flag = (a < b) ? 1'b1 : 1'b0;
                r = {31'b0, flag};
                carry = 1'b0;
                overflow = 1'b0;
                negative = r[31];
            end
            SLL: begin
                r = b << a[4:0];
                carry = 1'b0;
                overflow = 1'b0;
                negative = r[31];
            end
            SRL: begin
                r = b >> a[4:0];
                carry = 1'b0;
                overflow = 1'b0;
                negative = r[31];
            end
            SRA: begin
                r = $signed(b) >>> a[4:0];
                carry = 1'b0;
                overflow = 1'b0;
                negative = r[31];
            end
            SLLV: begin
                r = b << (a[4:0]);
                carry = 1'b0;
                overflow = 1'b0;
                negative = r[31];
            end
            SRLV: begin
                r = b >> (a[4:0]);
                carry = 1'b0;
                overflow = 1'b0;
                negative = r[31];
            end
            SRAV: begin
                r = $signed(b) >>> (a[4:0]);
                carry = 1'b0;
                overflow = 1'b0;
                negative = r[31];
            end
            LUI: begin
                r = {b[15:0], 16'b0};
                carry = 1'b0;
                overflow = 1'b0;
                negative = r[31];
            end
            default: begin
                r = 32'bz;
                carry = 1'b0;
                overflow = 1'b0;
                negative = 1'b0;
                flag = 1'bz;
            end
        endcase
    end

    assign zero = (r == 32'b0);

endmodule