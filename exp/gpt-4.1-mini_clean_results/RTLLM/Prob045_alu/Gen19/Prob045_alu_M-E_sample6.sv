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

// Internal wires for arithmetic operations
wire [32:0] add_res;
wire [32:0] sub_res;
wire signed [31:0] a_signed = a;
wire signed [31:0] b_signed = b;

// Addition and subtraction with carry out
assign add_res = {1'b0, a} + {1'b0, b};
assign sub_res = {1'b0, a} - {1'b0, b};

// Overflow detection for signed addition
wire add_overflow = (~a[31] & ~b[31] & add_res[31]) | (a[31] & b[31] & ~add_res[31]);
// Overflow detection for signed subtraction
wire sub_overflow = (a[31] & ~b[31] & ~sub_res[31]) | (~a[31] & b[31] & sub_res[31]);

// Shift amounts
wire [4:0] shamt_imm = a[4:0];
wire [4:0] shamt_var = a[4:0]; // same as shamt_imm but semantically used for variable shifts

// Temporary variables for flag and carry
reg tmp_carry;
reg tmp_overflow;
reg tmp_flag;
reg [31:0] tmp_r;

always @* begin
    // Default assignments
    tmp_r = 32'b0;
    tmp_carry = 1'b0;
    tmp_overflow = 1'b0;
    tmp_flag = 1'b0;

    case(aluc)
        ADD: begin
            tmp_r = add_res[31:0];
            tmp_carry = add_res[32];
            tmp_overflow = add_overflow;
        end
        ADDU: begin
            tmp_r = add_res[31:0];
            tmp_carry = add_res[32];
            tmp_overflow = 1'b0;
        end
        SUB: begin
            tmp_r = sub_res[31:0];
            tmp_carry = sub_res[32];
            tmp_overflow = sub_overflow;
        end
        SUBU: begin
            tmp_r = sub_res[31:0];
            tmp_carry = sub_res[32];
            tmp_overflow = 1'b0;
        end
        AND: begin
            tmp_r = a & b;
        end
        OR: begin
            tmp_r = a | b;
        end
        XOR: begin
            tmp_r = a ^ b;
        end
        NOR: begin
            tmp_r = ~(a | b);
        end
        SLT: begin
            // Set flag if signed a < signed b
            tmp_flag = (a_signed < b_signed);
            tmp_r = {31'b0, tmp_flag};
        end
        SLTU: begin
            // Set flag if unsigned a < unsigned b
            tmp_flag = (a < b);
            tmp_r = {31'b0, tmp_flag};
        end
        SLL: begin
            tmp_r = b << shamt_imm;
        end
        SRL: begin
            tmp_r = b >> shamt_imm;
        end
        SRA: begin
            tmp_r = $signed(b) >>> shamt_imm;
        end
        SLLV: begin
            tmp_r = b << shamt_var;
        end
        SRLV: begin
            tmp_r = b >> shamt_var;
        end
        SRAV: begin
            tmp_r = $signed(b) >>> shamt_var;
        end
        LUI: begin
            // According to description, upper 16 bits of 'a' concatenated with 16 zeros
            // However, normally LUI loads immediate in upper 16 bits, here we follow instruction literally
            tmp_r = {a[31:16], 16'b0};
        end
        default: begin
            tmp_r = 32'b0;
            tmp_carry = 1'b0;
            tmp_overflow = 1'b0;
            tmp_flag = 1'b0;
        end
    endcase
end

// Output assignments
always @* begin
    r        = tmp_r;
    carry    = tmp_carry;
    overflow = tmp_overflow;
    flag     = ((aluc == SLT) || (aluc == SLTU)) ? tmp_flag : 1'b0;
    zero     = (tmp_r == 32'b0);
    negative = tmp_r[31];
end

endmodule