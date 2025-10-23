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

// Signed and unsigned versions of inputs
wire signed [31:0] a_signed = $signed(a);
wire signed [31:0] b_signed = $signed(b);

// Shift amounts from a or a[4:0]
wire [4:0] shamt_imm = a[4:0];
wire [4:0] shamt_var = a[4:0];

// Arithmetic operations intermediate results
reg [32:0] add_ext;
reg [32:0] sub_ext;
reg [31:0] add_res;
reg [31:0] sub_res;
reg        add_carry;
reg        sub_carry;
reg        add_overflow;
reg        sub_overflow;

// Logic operations intermediate results
reg [31:0] logic_res;

// Shift operations intermediate results
reg [31:0] shift_res;

// SLT/SLTU flag and result
reg slt_flag;
reg sltu_flag;
reg [31:0] slt_res;
reg [31:0] sltu_res;

// LUI result
wire [31:0] lui_res = {a[15:0],16'b0};

always @(*) begin
    // Default assignments
    add_ext = 33'b0;
    sub_ext = 33'b0;
    add_carry = 1'b0;
    sub_carry = 1'b0;
    add_overflow = 1'b0;
    sub_overflow = 1'b0;
    add_res = 32'b0;
    sub_res = 32'b0;
    logic_res = 32'b0;
    shift_res = 32'b0;
    slt_flag = 1'b0;
    sltu_flag = 1'b0;
    slt_res = 32'b0;
    sltu_res = 32'b0;
    carry = 1'b0;
    overflow = 1'b0;
    flag = 1'bz;  // default to high-impedance
    negative = 1'b0;
    r = 32'b0;

    // Arithmetic ADD and SUB extended for carry detection
    add_ext = {1'b0, a} + {1'b0, b};
    add_res = add_ext[31:0];
    add_carry = add_ext[32];

    sub_ext = {1'b0, a} - {1'b0, b};
    sub_res = sub_ext[31:0];
    sub_carry = sub_ext[32];

    // Overflow detection for signed addition
    add_overflow = (~a[31] & ~b[31] & add_res[31]) | (a[31] & b[31] & ~add_res[31]);
    // Overflow detection for signed subtraction
    sub_overflow = (a[31] & ~b[31] & ~sub_res[31]) | (~a[31] & b[31] & sub_res[31]);

    // Logic operations
    logic_res = (aluc == AND) ? (a & b) :
                (aluc == OR)  ? (a | b) :
                (aluc == XOR) ? (a ^ b) :
                (aluc == NOR) ? ~(a | b) : 32'b0;

    // Shift operations
    case(aluc)
        SLL:  shift_res = b << shamt_imm;
        SRL:  shift_res = b >> shamt_imm;
        SRA:  shift_res = $signed(b_signed) >>> shamt_imm;
        SLLV: shift_res = b << shamt_var;
        SRLV: shift_res = b >> shamt_var;
        SRAV: shift_res = $signed(b_signed) >>> shamt_var;
        default: shift_res = 32'b0;
    endcase

    // SLT and SLTU
    slt_flag = (a_signed < b_signed) ? 1'b1 : 1'b0;
    slt_res = slt_flag ? 32'b1 : 32'b0;

    sltu_flag = (a < b) ? 1'b1 : 1'b0;
    sltu_res = sltu_flag ? 32'b1 : 32'b0;

    // Now select output and flags according to aluc
    case(aluc)
        ADD: begin
            r = add_res;
            carry = add_carry;
            overflow = add_overflow;
            flag = 1'bz;
        end
        ADDU: begin
            r = add_res;
            carry = add_carry;
            overflow = 1'b0;
            flag = 1'bz;
        end
        SUB: begin
            r = sub_res;
            carry = sub_carry;
            overflow = sub_overflow;
            flag = 1'bz;
        end
        SUBU: begin
            r = sub_res;
            carry = sub_carry;
            overflow = 1'b0;
            flag = 1'bz;
        end
        AND, OR, XOR, NOR: begin
            r = logic_res;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'bz;
        end
        SLT: begin
            r = slt_res;
            carry = 1'b0;
            overflow = 1'b0;
            flag = slt_flag ? 1'b1 : 1'b0;
        end
        SLTU: begin
            r = sltu_res;
            carry = 1'b0;
            overflow = 1'b0;
            flag = sltu_flag ? 1'b1 : 1'b0;
        end
        SLL, SRL, SRA, SLLV, SRLV, SRAV: begin
            r = shift_res;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'bz;
        end
        LUI: begin
            r = lui_res;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'bz;
        end
        default: begin
            r = 32'bz;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'bz;
        end
    endcase

    negative = r[31];
end

assign zero = (r == 32'b0);

endmodule