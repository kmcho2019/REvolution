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

// Opcodes
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

wire signed [31:0] a_s = a;
wire signed [31:0] b_s = b;
wire [4:0] shamt = a[4:0];

// Internal signals for arithmetic carry and overflow
reg carry_add, carry_sub;
reg overflow_add, overflow_sub;
reg [32:0] sum_add, diff_sub;

always @* begin
    // Defaults
    r = 32'b0;
    carry = 1'b0;
    overflow = 1'b0;
    flag = 1'bz;  // high impedance except for SLT/SLTU
    zero = 1'b0;
    negative = 1'b0;

    // Precompute sums and diffs for arithmetic ops
    sum_add  = {1'b0, a} + {1'b0, b};
    diff_sub = {1'b0, a} - {1'b0, b};

    carry_add = sum_add[32];
    carry_sub = diff_sub[32];

    // Overflow detection for signed add
    overflow_add = (~a[31] & ~b[31] & sum_add[31]) | (a[31] & b[31] & ~sum_add[31]);
    // Overflow detection for signed sub
    overflow_sub = (a[31] & ~b[31] & ~diff_sub[31]) | (~a[31] & b[31] & diff_sub[31]);

    case (aluc)
        ADD: begin
            r = sum_add[31:0];
            carry = carry_add;
            overflow = overflow_add;
        end
        ADDU: begin
            r = sum_add[31:0];
            carry = carry_add;
            overflow = 1'b0;
        end
        SUB: begin
            r = diff_sub[31:0];
            carry = carry_sub;
            overflow = overflow_sub;
        end
        SUBU: begin
            r = diff_sub[31:0];
            carry = carry_sub;
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
            flag = (a_s < b_s) ? 1'b1 : 1'b0;
            r = {31'b0, flag};
            carry = 1'b0;
            overflow = 1'b0;
        end
        SLTU: begin
            flag = (a < b) ? 1'b1 : 1'b0;
            r = {31'b0, flag};
            carry = 1'b0;
            overflow = 1'b0;
        end
        SLL:  r = b << shamt;
        SRL:  r = b >> shamt;
        SRA:  r = b_s >>> shamt;
        SLLV: r = b << a[4:0];
        SRLV: r = b >> a[4:0];
        SRAV: r = b_s >>> a[4:0];
        LUI:  r = {a[15:0], 16'b0}; // as per problem statement (not standard MIPS)
        default: begin
            r = 32'b0;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'bz;
        end
    endcase

    zero = (r == 32'b0);
    negative = r[31];
end

endmodule