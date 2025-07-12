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

wire [4:0] shamt = a[4:0];
wire signed [31:0] a_s = $signed(a);
wire signed [31:0] b_s = $signed(b);

// Arithmetic computations with carry and overflow

// ADD
wire [32:0] add_full = {1'b0, a} + {1'b0, b};
wire [31:0] add_r = add_full[31:0];
wire add_carry = add_full[32];
// Overflow when sign of a and b are same but differs from result
wire add_overflow = (~(a[31] ^ b[31])) & (a[31] ^ add_r[31]);

// ADDU (unsigned add) - carry but no overflow
wire [32:0] addu_full = {1'b0, a} + {1'b0, b};
wire [31:0] addu_r = addu_full[31:0];
wire addu_carry = addu_full[32];

// SUB
wire [32:0] sub_full = {1'b0, a} - {1'b0, b};
wire [31:0] sub_r = sub_full[31:0];
wire sub_carry = (a >= b);  // carry = not borrow for subtraction
wire sub_overflow = ((a[31] ^ b[31]) & (a[31] ^ sub_r[31]));

// SUBU (unsigned subtract)
wire [32:0] subu_full = {1'b0, a} - {1'b0, b};
wire [31:0] subu_r = subu_full[31:0];
wire subu_carry = (a >= b);

// Logical operations
wire [31:0] and_r = a & b;
wire [31:0] or_r  = a | b;
wire [31:0] xor_r = a ^ b;
wire [31:0] nor_r = ~(a | b);

// SLT signed less than
wire slt_flag = (a_s < b_s);
wire [31:0] slt_r = {31'd0, slt_flag};

// SLTU unsigned less than
wire sltu_flag = (a < b);
wire [31:0] sltu_r = {31'd0, sltu_flag};

// Shift operations - shift amount from shamt (a[4:0]) or variable shifts using a[4:0]
wire [31:0] sll_r  = b << shamt;
wire [31:0] srl_r  = b >> shamt;
wire [31:0] sra_r  = $signed(b_s) >>> shamt;
wire [31:0] sllv_r = b << a[4:0];
wire [31:0] srlv_r = b >> a[4:0];
wire [31:0] srav_r = $signed(b_s) >>> a[4:0];

// LUI - load upper immediate: per MIPS, upper 16 bits get immediate, low 16 bits zero
// Use b[15:0] as immediate value, result = immediate << 16
wire [31:0] lui_r = {b[15:0], 16'b0};

always @(*) begin
    // Defaults
    r = 32'b0;
    carry = 1'b0;
    overflow = 1'b0;
    negative = 1'b0;
    flag = 1'b0;

    case (aluc)
        ADD: begin
            r = add_r;
            carry = add_carry;
            overflow = add_overflow;
            negative = r[31];
        end
        ADDU: begin
            r = addu_r;
            carry = addu_carry;
            overflow = 1'b0;
            negative = r[31];
        end
        SUB: begin
            r = sub_r;
            carry = sub_carry;
            overflow = sub_overflow;
            negative = r[31];
        end
        SUBU: begin
            r = subu_r;
            carry = subu_carry;
            overflow = 1'b0;
            negative = r[31];
        end
        AND: begin
            r = and_r;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
        end
        OR: begin
            r = or_r;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
        end
        XOR: begin
            r = xor_r;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
        end
        NOR: begin
            r = nor_r;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
        end
        SLT: begin
            r = slt_r;
            carry = 1'b0;
            overflow = 1'b0;
            negative = 1'b0;
            flag = slt_flag;
        end
        SLTU: begin
            r = sltu_r;
            carry = 1'b0;
            overflow = 1'b0;
            negative = 1'b0;
            flag = sltu_flag;
        end
        SLL: begin
            r = sll_r;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
        end
        SRL: begin
            r = srl_r;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
        end
        SRA: begin
            r = sra_r;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
        end
        SLLV: begin
            r = sllv_r;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
        end
        SRLV: begin
            r = srlv_r;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
        end
        SRAV: begin
            r = srav_r;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
        end
        LUI: begin
            r = lui_r;
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

// zero flag combinational: high if r is zero
assign zero = (r == 32'b0);

endmodule