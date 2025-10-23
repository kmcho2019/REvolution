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

// Internal wires for all possible operations
wire [31:0] add_r, addu_r, sub_r, subu_r;
wire        add_carry, addu_carry, sub_carry, subu_carry;
wire        add_overflow, sub_overflow;
wire [31:0] and_r, or_r, xor_r, nor_r;
wire        slt_flag;
wire        sltu_flag;
wire [31:0] sll_r, srl_r, sra_r, sllv_r, srlv_r, srav_r;
wire [31:0] lui_r;

wire [4:0] shamt = a[4:0];

wire signed [31:0] a_s = $signed(a);
wire signed [31:0] b_s = $signed(b);

// Arithmetic: ADD
wire [32:0] add_full = {1'b0, a} + {1'b0, b};
assign add_r = add_full[31:0];
assign add_carry = add_full[32];
// Overflow detection for signed add: if signs of inputs same and result sign differs
assign add_overflow = (~(a[31] ^ b[31])) & (a[31] ^ add_r[31]);

// Arithmetic: ADDU (unsigned addition)
wire [32:0] addu_full = {1'b0, a} + {1'b0, b};
assign addu_r = addu_full[31:0];
assign addu_carry = addu_full[32];

// Arithmetic: SUB
wire [32:0] sub_full = {1'b0, a} - {1'b0, b};
assign sub_r = sub_full[31:0];
// Borrow: if a >= b, carry=1; else carry=0
assign sub_carry = (a >= b);
// Overflow detection for signed subtract: if signs differ between inputs and result sign differs from a
assign sub_overflow = ((a[31] ^ b[31]) & (a[31] ^ sub_r[31]));

// Arithmetic: SUBU (unsigned subtract)
wire [32:0] subu_full = {1'b0, a} - {1'b0, b};
assign subu_r = subu_full[31:0];
assign subu_carry = (a >= b);

// Logical operations
assign and_r = a & b;
assign or_r  = a | b;
assign xor_r = a ^ b;
assign nor_r = ~(a | b);

// SLT: signed less than
assign slt_flag = (a_s < b_s);
wire [31:0] slt_r = {31'd0, slt_flag};

// SLTU: unsigned less than
assign sltu_flag = (a < b);
wire [31:0] sltu_r = {31'd0, sltu_flag};

// Shift operations
assign sll_r  = b << shamt;
assign srh_r  = b >> shamt; // shift right logic by shamt
assign srl_r  = b >> shamt;
assign sra_r  = $signed(b) >>> shamt;
assign sllv_r = b << (a[4:0]);
assign srlv_r = b >> (a[4:0]);
assign srav_r = $signed(b) >>> (a[4:0]);

// LUI
assign lui_r = {a[15:0], 16'd0};

// Result multiplexer and flag assignments
always @(*) begin
    // Default values
    r        = 32'b0;
    carry    = 1'b0;
    overflow = 1'b0;
    negative = 1'b0;
    flag     = 1'b0; // Default flag low for no SLT/SLTU

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
            negative = 1'b0;
            flag = slt_flag ? 1'b1 : 1'b0;
        end
        SLTU: begin
            r = sltu_r;
            carry = 1'b0;
            overflow = 1'b0;
            negative = 1'b0;
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

// zero flag combinational
assign zero = (r == 32'b0);

endmodule