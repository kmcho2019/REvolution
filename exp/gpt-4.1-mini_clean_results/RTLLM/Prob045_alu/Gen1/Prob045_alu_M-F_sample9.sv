module alu(
    input  [31:0] a,
    input  [31:0] b,
    input  [5:0]  aluc,
    output reg [31:0] r,
    output zero,
    output reg carry,
    output reg negative,
    output reg overflow,
    output reg flag
);

// Opcode parameters
parameter ADD   = 6'b100000;
parameter ADDU  = 6'b100001;
parameter SUB   = 6'b100010;
parameter SUBU  = 6'b100011;
parameter AND   = 6'b100100;
parameter OR    = 6'b100101;
parameter XOR   = 6'b100110;
parameter NOR   = 6'b100111;
parameter SLT   = 6'b101010;
parameter SLTU  = 6'b101011;
parameter SLL   = 6'b000000;
parameter SRL   = 6'b000010;
parameter SRA   = 6'b000011;
parameter SLLV  = 6'b000100;
parameter SRLV  = 6'b000110;
parameter SRAV  = 6'b000111;
parameter LUI   = 6'b001111;

// Signed versions of inputs for arithmetic and comparison
wire signed [31:0] a_s = a;
wire signed [31:0] b_s = b;

// Internal signals for addition/subtraction with carry out
reg [32:0] sum_ext;
reg [32:0] diff_ext;

always @(*) begin
    // Default outputs for status signals
    carry    = 1'b0;
    overflow = 1'b0;
    flag     = 1'b0;        // Explicitly 0 when not SLT/SLTU to avoid high-Z
    negative = 1'b0;
    r        = 32'b0;

    case(aluc)
        ADD: begin
            sum_ext = {a[31], a} + {b[31], b};
            r = sum_ext[31:0];
            carry = sum_ext[32]; // carry out for unsigned addition
            // Overflow detection for signed addition:
            // overflow if signs of inputs are same and sign of result differs
            overflow = (~a[31] & ~b[31] & r[31]) | (a[31] & b[31] & ~r[31]);
            negative = r[31];
        end
        ADDU: begin
            sum_ext = {1'b0, a} + {1'b0, b};
            r = sum_ext[31:0];
            carry = sum_ext[32];
            overflow = 1'b0; // no overflow for unsigned add
            negative = r[31];
        end
        SUB: begin
            diff_ext = {a[31], a} - {b[31], b};
            r = diff_ext[31:0];
            carry = diff_ext[32]; // borrow flag, if 1 means no borrow (carry from subtraction)
            // Overflow detection for signed subtraction:
            // overflow if signs of a and b differ and sign of result differs from sign of a
            overflow = (a[31] & ~b[31] & ~r[31]) | (~a[31] & b[31] & r[31]);
            negative = r[31];
        end
        SUBU: begin
            diff_ext = {1'b0, a} - {1'b0, b};
            r = diff_ext[31:0];
            carry = diff_ext[32]; // borrow flag as above
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
            r = (a_s < b_s) ? 32'd1 : 32'd0;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            flag = r[0];          // flag = 1 if less than, else 0
        end
        SLTU: begin
            // unsigned comparison
            r = (a < b) ? 32'd1 : 32'd0;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            flag = r[0];          // flag = 1 if less than, else 0
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
            r = b << a[4:0];
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
        end
        SRLV: begin
            r = b >> a[4:0];
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
        end
        SRAV: begin
            r = $signed(b) >>> a[4:0];
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
        end
        LUI: begin
            // Load upper immediate: place b[15:0] in upper 16 bits, lower 16 bits zero
            r = {b[15:0], 16'b0};
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
        end
        default: begin
            r = 32'b0;
            carry = 1'b0;
            overflow = 1'b0;
            negative = 1'b0;
            flag = 1'b0;
        end
    endcase
end

assign zero = (r == 32'b0);

endmodule