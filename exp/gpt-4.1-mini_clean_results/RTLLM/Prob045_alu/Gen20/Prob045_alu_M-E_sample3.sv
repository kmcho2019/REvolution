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

wire [4:0] shamt = a[4:0];
wire signed [31:0] a_s = a;
wire signed [31:0] b_s = b;

// Arithmetic operations (with carry out and overflow)
reg [32:0] sum_add;
reg [32:0] sum_sub;

always @(*) begin
    // Precompute add and sub results with carry
    sum_add = {1'b0, a} + {1'b0, b};
    sum_sub = {1'b0, a} - {1'b0, b};
end

// Logical operations
wire [31:0] and_r = a & b;
wire [31:0] or_r  = a | b;
wire [31:0] xor_r = a ^ b;
wire [31:0] nor_r = ~(a | b);

// Shift operations
wire [31:0] sll_r  = b << shamt;
wire [31:0] srl_r  = b >> shamt;
wire [31:0] sra_r  = $signed(b) >>> shamt;

wire [31:0] sllv_r = b << a[4:0];
wire [31:0] srlv_r = b >> a[4:0];
wire [31:0] srav_r = $signed(b) >>> a[4:0];

// SLT flags
wire slt_flag  = (a_s < b_s);
wire sltu_flag = (a < b);

// LUI operation
wire [31:0] lui_r = {a[15:0], 16'b0};

reg [31:0] next_r;
reg next_carry;
reg next_overflow;
reg next_flag;

always @(*) begin
    next_r = 32'b0;
    next_carry = 1'b0;
    next_overflow = 1'b0;
    next_flag = 1'bz;

    case (aluc)
        ADD: begin
            next_r = sum_add[31:0];
            next_carry = sum_add[32];
            // overflow if sign(a)==sign(b) and sign(result)!=sign(a)
            next_overflow = (~a[31] & ~b[31] & next_r[31]) | (a[31] & b[31] & ~next_r[31]);
            next_flag = 1'bz;
        end
        ADDU: begin
            next_r = sum_add[31:0];
            next_carry = sum_add[32];
            next_overflow = 1'b0;
            next_flag = 1'bz;
        end
        SUB: begin
            next_r = sum_sub[31:0];
            // carry meaning borrow: in subtraction, carry out = ~borrow
            next_carry = sum_sub[32];
            // overflow if sign(a)!=sign(b) and sign(result)!=sign(a)
            next_overflow = (a[31] & ~b[31] & ~next_r[31]) | (~a[31] & b[31] & next_r[31]);
            next_flag = 1'bz;
        end
        SUBU: begin
            next_r = sum_sub[31:0];
            next_carry = sum_sub[32];
            next_overflow = 1'b0;
            next_flag = 1'bz;
        end
        AND: begin
            next_r = and_r;
            next_carry = 1'b0;
            next_overflow = 1'b0;
            next_flag = 1'bz;
        end
        OR: begin
            next_r = or_r;
            next_carry = 1'b0;
            next_overflow = 1'b0;
            next_flag = 1'bz;
        end
        XOR: begin
            next_r = xor_r;
            next_carry = 1'b0;
            next_overflow = 1'b0;
            next_flag = 1'bz;
        end
        NOR: begin
            next_r = nor_r;
            next_carry = 1'b0;
            next_overflow = 1'b0;
            next_flag = 1'bz;
        end
        SLT: begin
            next_flag = slt_flag ? 1'b1 : 1'b0;
            next_r = {31'b0, next_flag};
            next_carry = 1'b0;
            next_overflow = 1'b0;
        end
        SLTU: begin
            next_flag = sltu_flag ? 1'b1 : 1'b0;
            next_r = {31'b0, next_flag};
            next_carry = 1'b0;
            next_overflow = 1'b0;
        end
        SLL: begin
            next_r = sll_r;
            next_carry = 1'b0;
            next_overflow = 1'b0;
            next_flag = 1'bz;
        end
        SRL: begin
            next_r = srl_r;
            next_carry = 1'b0;
            next_overflow = 1'b0;
            next_flag = 1'bz;
        end
        SRA: begin
            next_r = sra_r;
            next_carry = 1'b0;
            next_overflow = 1'b0;
            next_flag = 1'bz;
        end
        SLLV: begin
            next_r = sllv_r;
            next_carry = 1'b0;
            next_overflow = 1'b0;
            next_flag = 1'bz;
        end
        SRLV: begin
            next_r = srlv_r;
            next_carry = 1'b0;
            next_overflow = 1'b0;
            next_flag = 1'bz;
        end
        SRAV: begin
            next_r = srav_r;
            next_carry = 1'b0;
            next_overflow = 1'b0;
            next_flag = 1'bz;
        end
        LUI: begin
            next_r = lui_r;
            next_carry = 1'b0;
            next_overflow = 1'b0;
            next_flag = 1'bz;
        end
        default: begin
            // Maintain previous values to avoid glitches on unknown opcode
            next_r = r;
            next_carry = carry;
            next_overflow = overflow;
            next_flag = flag; // keep flag unchanged, no change or 'z'
        end
    endcase
end

always @( * ) begin
    r = next_r;
    carry = next_carry;
    overflow = next_overflow;
    flag = next_flag;
    zero = (next_r == 32'b0);
    negative = next_r[31];
end

endmodule