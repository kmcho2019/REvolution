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

// Opcode parameters as per MIPS ISA
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

// Internal signals for arithmetic operations
wire signed [31:0] a_s = $signed(a);
wire signed [31:0] b_s = $signed(b);

// 33-bit add/sub for carry detection
wire [32:0] add_res = {1'b0, a} + {1'b0, b};
wire [32:0] sub_res = {1'b0, a} - {1'b0, b};

// Overflow detection for signed add
wire add_overflow = (~a[31] & ~b[31] & add_res[31]) | (a[31] & b[31] & ~add_res[31]);
// Overflow detection for signed sub
wire sub_overflow = (a[31] & ~b[31] & ~sub_res[31]) | (~a[31] & b[31] & sub_res[31]);

// Shift amounts extracted accordingly
wire [4:0] shamt = a[4:0];
wire [4:0] b_shamt = b[4:0];

// Precomputed shifts
wire [31:0] sll_b = b << shamt;
wire [31:0] srl_b = b >> shamt;
wire [31:0] sra_b = $signed(b) >>> shamt;

wire [31:0] sllv_b = b << a[4:0];
wire [31:0] srlv_b = b >> a[4:0];
wire [31:0] srav_b = $signed(b) >>> a[4:0];

// Precomputed bitwise logic
wire [31:0] and_ab = a & b;
wire [31:0] or_ab  = a | b;
wire [31:0] xor_ab = a ^ b;
wire [31:0] nor_ab = ~(a | b);

// Precomputed comparisons for SLT/SLTU
wire slt_flag  = (a_s < b_s);
wire sltu_flag = (a < b);

// LUI operation: shift lower 16 bits of a by 16 bits left
wire [31:0] lui_res = {a[15:0], 16'b0};

always @(*) begin
    // Defaults
    r = 32'b0;
    carry = 1'b0;
    overflow = 1'b0;
    flag = 1'b0;
    negative = 1'b0;

    if (aluc == ADD) begin
        r = add_res[31:0];
        carry = add_res[32];
        overflow = add_overflow;
        flag = 1'b0;
    end
    else if (aluc == ADDU) begin
        r = add_res[31:0];
        carry = add_res[32];
        overflow = 1'b0;
        flag = 1'b0;
    end
    else if (aluc == SUB) begin
        r = sub_res[31:0];
        carry = (a >= b) ? 1'b1 : 1'b0; // borrow inverted = carry
        overflow = sub_overflow;
        flag = 1'b0;
    end
    else if (aluc == SUBU) begin
        r = sub_res[31:0];
        carry = (a >= b) ? 1'b1 : 1'b0;
        overflow = 1'b0;
        flag = 1'b0;
    end
    else if (aluc == AND) begin
        r = and_ab;
        carry = 1'b0;
        overflow = 1'b0;
        flag = 1'b0;
    end
    else if (aluc == OR) begin
        r = or_ab;
        carry = 1'b0;
        overflow = 1'b0;
        flag = 1'b0;
    end
    else if (aluc == XOR) begin
        r = xor_ab;
        carry = 1'b0;
        overflow = 1'b0;
        flag = 1'b0;
    end
    else if (aluc == NOR) begin
        r = nor_ab;
        carry = 1'b0;
        overflow = 1'b0;
        flag = 1'b0;
    end
    else if (aluc == SLT) begin
        flag = slt_flag ? 1'b1 : 1'b0;
        r = {31'b0, flag};
        carry = 1'b0;
        overflow = 1'b0;
    end
    else if (aluc == SLTU) begin
        flag = sltu_flag ? 1'b1 : 1'b0;
        r = {31'b0, flag};
        carry = 1'b0;
        overflow = 1'b0;
    end
    else if (aluc == SLL) begin
        r = sll_b;
        carry = 1'b0;
        overflow = 1'b0;
        flag = 1'b0;
    end
    else if (aluc == SRL) begin
        r = srl_b;
        carry = 1'b0;
        overflow = 1'b0;
        flag = 1'b0;
    end
    else if (aluc == SRA) begin
        r = sra_b;
        carry = 1'b0;
        overflow = 1'b0;
        flag = 1'b0;
    end
    else if (aluc == SLLV) begin
        r = sllv_b;
        carry = 1'b0;
        overflow = 1'b0;
        flag = 1'b0;
    end
    else if (aluc == SRLV) begin
        r = srlv_b;
        carry = 1'b0;
        overflow = 1'b0;
        flag = 1'b0;
    end
    else if (aluc == SRAV) begin
        r = srav_b;
        carry = 1'b0;
        overflow = 1'b0;
        flag = 1'b0;
    end
    else if (aluc == LUI) begin
        r = lui_res;
        carry = 1'b0;
        overflow = 1'b0;
        flag = 1'b0;
    end
    else begin
        // Undefined operation: zero output and clear flags
        r = 32'b0;
        carry = 1'b0;
        overflow = 1'b0;
        flag = 1'b0;
    end

    negative = r[31];
end

assign zero = (r == 32'b0);

endmodule