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

// Signed versions of a and b for signed operations
wire signed [31:0] a_signed = a;
wire signed [31:0] b_signed = b;

// Temporary result with carry-out bit for addition/subtraction
reg [32:0] add_sub_res;

always @(*) begin
    carry = 1'b0;
    overflow = 1'b0;
    flag = 1'bz; // default to high-impedance
    case (aluc)
        ADD: begin
            // Signed addition with overflow detection and carry-out detection on unsigned addition
            add_sub_res = {1'b0, a} + {1'b0, b};
            r = add_sub_res[31:0];
            carry = add_sub_res[32];
            // Overflow detection: if sign of a == sign of b and sign of result != sign of a
            overflow = ((a[31] == b[31]) && (r[31] != a[31])) ? 1'b1 : 1'b0;
        end
        ADDU: begin
            // Unsigned addition, carry from MSB
            add_sub_res = {1'b0, a} + {1'b0, b};
            r = add_sub_res[31:0];
            carry = add_sub_res[32];
            overflow = 1'b0; // no overflow in unsigned addition
        end
        SUB: begin
            // Signed subtraction a - b
            add_sub_res = {1'b0, a} - {1'b0, b};
            r = add_sub_res[31:0];
            // Carry in subtraction can be interpreted as borrow: set carry=~borrow
            // borrow = (a < b) unsigned, carry = no borrow
            carry = (a >= b) ? 1'b1 : 1'b0;
            // Overflow detection for subtraction: if sign of a != sign of b and sign of result != sign of a
            overflow = ((a[31] != b[31]) && (r[31] != a[31])) ? 1'b1 : 1'b0;
        end
        SUBU: begin
            // Unsigned subtraction
            add_sub_res = {1'b0, a} - {1'b0, b};
            r = add_sub_res[31:0];
            carry = (a >= b) ? 1'b1 : 1'b0; // carry means no borrow here
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
            // Set on less than (signed)
            flag = (a_signed < b_signed) ? 1'b1 : 1'b0;
            r = {31'b0, flag};
        end
        SLTU: begin
            // Set on less than unsigned
            flag = (a < b) ? 1'b1 : 1'b0;
            r = {31'b0, flag};
        end
        SLL: begin
            // Shift b left logical by a[4:0]
            r = b << a[4:0];
        end
        SRL: begin
            // Shift b right logical by a[4:0]
            r = b >> a[4:0];
        end
        SRA: begin
            // Shift b right arithmetic by a[4:0]
            r = $signed(b) >>> a[4:0];
        end
        SLLV: begin
            // Shift b left logical by a[4:0]
            r = b << (a[4:0]);
        end
        SRLV: begin
            // Shift b right logical by a[4:0]
            r = b >> (a[4:0]);
        end
        SRAV: begin
            // Shift b right arithmetic by a[4:0]
            r = $signed(b) >>> (a[4:0]);
        end
        LUI: begin
            // Load upper immediate: b's lower 16 bits go to upper 16 bits of r, lower 16 bits are 0
            r = {b[15:0],16'b0};
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