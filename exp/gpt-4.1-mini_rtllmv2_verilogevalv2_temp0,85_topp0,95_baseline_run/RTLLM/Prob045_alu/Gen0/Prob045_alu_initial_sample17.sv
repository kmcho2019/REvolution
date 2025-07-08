module alu (
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
    // Parameters for ALU operations
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

    // Signed versions of inputs for arithmetic and comparison
    wire signed [31:0] a_signed = a;
    wire signed [31:0] b_signed = b;

    // Intermediate register for extended results (33 bits for carry detection)
    reg [32:0] extended_res;

    always @(*) begin
        carry    = 1'b0;
        overflow = 1'b0;
        flag     = 1'bz;
        extended_res = 33'b0;
        case(aluc)
            ADD: begin
                extended_res = {1'b0, a} + {1'b0, b};
                r = extended_res[31:0];
                carry = extended_res[32];
                // Overflow detection for signed add:
                // Overflow if sign of a == sign of b and sign of result != sign of a
                overflow = (~a[31] & ~b[31] & r[31]) | (a[31] & b[31] & ~r[31]);
                flag = 1'bz;
            end
            ADDU: begin
                extended_res = {1'b0, a} + {1'b0, b};
                r = extended_res[31:0];
                carry = extended_res[32];
                overflow = 1'b0;
                flag = 1'bz;
            end
            SUB: begin
                extended_res = {1'b0, a} - {1'b0, b};
                r = extended_res[31:0];
                // Carry = borrow in subtraction: carry out = ~borrow
                carry = ~extended_res[32];
                // Overflow detection for signed subtract:
                // Overflow if sign of a != sign of b and sign of result != sign of a
                overflow = (a[31] & ~b[31] & ~r[31]) | (~a[31] & b[31] & r[31]);
                flag = 1'bz;
            end
            SUBU: begin
                extended_res = {1'b0, a} - {1'b0, b};
                r = extended_res[31:0];
                carry = ~extended_res[32];
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
                // Set flag = 1 if a < b (signed)
                flag = (a_signed < b_signed) ? 1'b1 : 1'b0;
                r = {31'b0, flag};
                carry = 1'b0;
                overflow = 1'b0;
            end
            SLTU: begin
                // Set flag = 1 if a < b (unsigned)
                flag = (a < b) ? 1'b1 : 1'b0;
                r = {31'b0, flag};
                carry = 1'b0;
                overflow = 1'b0;
            end
            SLL: begin
                // Shift b left by a[4:0]
                r = b << a[4:0];
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end
            SRL: begin
                // Logical shift right b by a[4:0]
                r = b >> a[4:0];
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end
            SRA: begin
                // Arithmetic shift right b by a[4:0]
                r = $signed(b) >>> a[4:0];
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end
            SLLV: begin
                // Shift b left by a[4:0]
                r = b << a[4:0];
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end
            SRLV: begin
                // Logical shift right b by a[4:0]
                r = b >> a[4:0];
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end
            SRAV: begin
                // Arithmetic shift right b by a[4:0]
                r = $signed(b) >>> a[4:0];
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end
            LUI: begin
                // Load upper immediate: a[15:0] << 16
                r = {a[15:0], 16'b0};
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