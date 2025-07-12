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

// Shift amount from a[4:0]
wire [4:0] shamt = a[4:0];

// Signed versions of inputs
wire signed [31:0] a_s = $signed(a);
wire signed [31:0] b_s = $signed(b);

// ---------- Arithmetic operations shared for ADD/ADDU and SUB/SUBU ----------
// 33-bit extended operands for carry detection
wire [32:0] add_full = {1'b0, a} + {1'b0, b};
wire [32:0] sub_full = {1'b0, a} - {1'b0, b};

// ADD (signed)
wire [31:0] add_r = add_full[31:0];
wire add_carry = add_full[32];
// Overflow detection for signed add: if signs of inputs are same but result sign differs
wire add_overflow = (~(a[31] ^ b[31])) & (a[31] ^ add_r[31]);

// ADDU (unsigned) uses same adder, overflow ignored
wire [31:0] addu_r = add_full[31:0];
wire addu_carry = add_full[32];

// SUB (signed)
wire [31:0] sub_r = sub_full[31:0];
// Carry for SUB defined as NOT borrow; carry=1 means no borrow
wire sub_carry = (a >= b);
wire sub_overflow = ((a[31] ^ b[31]) & (a[31] ^ sub_r[31]));

// SUBU (unsigned) uses same subtractor, overflow ignored
wire [31:0] subu_r = sub_full[31:0];
wire subu_carry = (a >= b);

// ---------- Logical operations ----------
wire [31:0] and_r = a & b;
wire [31:0] or_r  = a | b;
wire [31:0] xor_r = a ^ b;
wire [31:0] nor_r = ~(a | b);

// ---------- Set Less Than ----------
wire slt_flag = (a_s < b_s);
wire [31:0] slt_r = {31'b0, slt_flag};

wire sltu_flag = (a < b);
wire [31:0] sltu_r = {31'b0, sltu_flag};

// ---------- Shift operations ----------
// Logical shifts
wire [31:0] sll_r  = b << shamt;
wire [31:0] srl_r  = b >> shamt;
// Arithmetic shifts (signed)
wire [31:0] sra_r  = $signed(b) >>> shamt;
// Variable shifts by a[4:0]
wire [31:0] sllv_r = b << a[4:0];
wire [31:0] srlv_r = b >> a[4:0];
wire [31:0] srav_r = $signed(b) >>> a[4:0];

// LUI (Load Upper Immediate): puts immediate in upper 16 bits, zero in lower 16 bits
// Here 'a' holds immediate value in lower 16 bits per problem statement
wire [31:0] lui_r = {a[15:0], 16'b0};

// ---------- Always block for output muxing and flag setting ----------
always @(*) begin
    // Default assignments
    r        = 32'b0;
    carry    = 1'b0;
    overflow = 1'b0;
    negative = 1'b0;
    flag     = 1'b0;  // Default to 0 for non-SLT/SLTU (avoid 'z' for synthesis)

    case (aluc)
        ADD: begin
            r = add_r;
            carry = add_carry;
            overflow = add_overflow;
            negative = r[31];
            flag = 1'b0;
        end
        ADDU: begin
            r = addu_r;
            carry = addu_carry;
            overflow = 1'b0;
            negative = r[31];
            flag = 1'b0;
        end
        SUB: begin
            r = sub_r;
            carry = sub_carry;
            overflow = sub_overflow;
            negative = r[31];
            flag = 1'b0;
        end
        SUBU: begin
            r = subu_r;
            carry = subu_carry;
            overflow = 1'b0;
            negative = r[31];
            flag = 1'b0;
        end
        AND: begin
            r = and_r;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            flag = 1'b0;
        end
        OR: begin
            r = or_r;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            flag = 1'b0;
        end
        XOR: begin
            r = xor_r;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            flag = 1'b0;
        end
        NOR: begin
            r = nor_r;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            flag = 1'b0;
        end
        SLT: begin
            r = slt_r;
            carry = 1'b0;
            overflow = 1'b0;
            negative = 1'b0;  // result is 0 or 1 always positive
            flag = slt_flag ? 1'b1 : 1'b0;
        end
        SLTU: begin
            r = sltu_r;
            carry = 1'b0;
            overflow = 1'b0;
            negative = 1'b0;  // result is 0 or 1
            flag = sltu_flag ? 1'b1 : 1'b0;
        end
        SLL: begin
            r = sll_r;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            flag = 1'b0;
        end
        SRL: begin
            r = srl_r;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            flag = 1'b0;
        end
        SRA: begin
            r = sra_r;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            flag = 1'b0;
        end
        SLLV: begin
            r = sllv_r;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            flag = 1'b0;
        end
        SRLV: begin
            r = srlv_r;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            flag = 1'b0;
        end
        SRAV: begin
            r = srav_r;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            flag = 1'b0;
        end
        LUI: begin
            r = lui_r;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            flag = 1'b0;
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

// Combinational zero flag (1 if r is zero)
assign zero = (r == 32'b0);

endmodule