module alu (
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

// Intermediate signals for arithmetic operations
wire signed [31:0] a_s = $signed(a);
wire signed [31:0] b_s = $signed(b);

wire [31:0] sum_add  = a + b;
wire [31:0] diff_sub = a - b;

// Carry out for unsigned addition and subtraction
wire carry_add  = ((a[31:0] + b[31:0]) < a);
wire carry_sub  = (a >= b);

// Overflow detection for signed add and sub
wire overflow_add = (~a[31] & ~b[31] & sum_add[31]) | (a[31] & b[31] & ~sum_add[31]);
wire overflow_sub = (a[31] & ~b[31] & ~diff_sub[31]) | (~a[31] & b[31] & diff_sub[31]);

// Shift amounts
wire [4:0] shamt = a[4:0]; // For immediate shifts
wire [4:0] shamt_var = a[4:0]; // For variable shifts (shift amount in a)

// Shift operations
wire [31:0] sll_res  = b << shamt;
wire [31:0] srl_res  = b >> shamt;
wire [31:0] sra_res  = $signed(b) >>> shamt;
wire [31:0] sllv_res = b << shamt_var;
wire [31:0] srlv_res = b >> shamt_var;
wire [31:0] srav_res = $signed(b) >>> shamt_var;

// Logical operations
wire [31:0] and_res = a & b;
wire [31:0] or_res  = a | b;
wire [31:0] xor_res = a ^ b;
wire [31:0] nor_res = ~(a | b);

// SLT and SLTU flags and results
wire slt_flag  = (a_s < b_s);
wire sltu_flag = (a < b);

// LUI result: lower 16 bits of a shifted to upper 16 bits, lower 16 bits zero
wire [31:0] lui_res = {a[15:0], 16'b0};

always @(*) begin
    // Defaults
    r = 32'b0;
    carry = 1'b0;
    overflow = 1'b0;
    flag = 1'b0;
    negative = 1'b0;
    zero = 1'b0;

    case (aluc)
        ADD: begin
            r = sum_add;
            carry = carry_add;
            overflow = overflow_add;
        end
        ADDU: begin
            r = sum_add;
            carry = carry_add;
            overflow = 1'b0;
        end
        SUB: begin
            r = diff_sub;
            carry = carry_sub;
            overflow = overflow_sub;
        end
        SUBU: begin
            r = diff_sub;
            carry = carry_sub;
            overflow = 1'b0;
        end
        AND: begin
            r = and_res;
        end
        OR: begin
            r = or_res;
        end
        XOR: begin
            r = xor_res;
        end
        NOR: begin
            r = nor_res;
        end
        SLT: begin
            flag = slt_flag ? 1'b1 : 1'b0;
            r = 32'b0;
            r[0] = flag;
        end
        SLTU: begin
            flag = sltu_flag ? 1'b1 : 1'b0;
            r = 32'b0;
            r[0] = flag;
        end
        SLL: begin
            r = sll_res;
        end
        SRL: begin
            r = srl_res;
        end
        SRA: begin
            r = sra_res;
        end
        SLLV: begin
            r = sllv_res;
        end
        SRLV: begin
            r = srlv_res;
        end
        SRAV: begin
            r = srav_res;
        end
        LUI: begin
            r = lui_res;
        end
        default: begin
            r = 32'b0;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
    endcase

    // Set negative and zero flags from result r
    negative = r[31];
    zero = (r == 32'b0);
end

endmodule