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

// Signed inputs for arithmetic and comparisons
wire signed [31:0] a_s = $signed(a);
wire signed [31:0] b_s = $signed(b);

// Determine if operation is subtract type
wire is_subtract = (aluc == SUB) || (aluc == SUBU);

// 33-bit addition/subtraction for carry detection
wire [32:0] add_sub_result_33 = is_subtract ? ({1'b0, a} - {1'b0, b}) : ({1'b0, a} + {1'b0, b});
wire [31:0] add_sub_result = add_sub_result_33[31:0];
wire carry_out = add_sub_result_33[32];

// Overflow detection only for signed add/sub
wire add_overflow = (~a[31] & ~b[31] & add_sub_result[31]) | (a[31] & b[31] & ~add_sub_result[31]);
wire sub_overflow = (a[31] & ~b[31] & ~add_sub_result[31]) | (~a[31] & b[31] & add_sub_result[31]);

// Calculate carry flag: For ADD/ADDU, carry_out indicates carry out.
// For SUB/SUBU, carry = 1 means no borrow (a >= b), 0 means borrow.
wire carry_flag = (aluc == ADD || aluc == ADDU) ? carry_out :
                  (aluc == SUB || aluc == SUBU) ? (a >= b) : 1'b0;

// Precompute logic operations
wire [31:0] and_res = a & b;
wire [31:0] or_res  = a | b;
wire [31:0] xor_res = a ^ b;
wire [31:0] nor_res = ~(a | b);

// SLT and SLTU flags (only valid for these ops)
wire slt_flag  = (a_s < b_s);
wire sltu_flag = (a < b);

// Shift amount selection
wire [4:0] shamt_imm = a[4:0]; // For shifts with immediate shift amount in 'a'
wire [4:0] shamt_reg = b[4:0]; // For variable shift amount from 'b'

reg [31:0] shift_out;

// Implement shared barrel shifter for all shift types
always @(*) begin
    case (aluc)
        SLL:  shift_out = b << shamt_imm;
        SRL:  shift_out = b >> shamt_imm;
        SRA:  shift_out = $signed(b) >>> shamt_imm;
        SLLV: shift_out = b << shamt_reg;
        SRLV: shift_out = b >> shamt_reg;
        SRAV: shift_out = $signed(b) >>> shamt_reg;
        default: shift_out = 32'b0;
    endcase
end

// LUI operation: load upper immediate (from a[15:0]) shifted to upper half
wire [31:0] lui_res = {a[15:0], 16'b0};

always @(*) begin
    // Default values
    r = 32'b0;
    carry = 1'b0;
    overflow = 1'b0;
    flag = 1'b0;
    negative = 1'b0;

    case(aluc)
        ADD: begin
            r = add_sub_result;
            carry = carry_flag;
            overflow = add_overflow;
        end
        ADDU: begin
            r = add_sub_result;
            carry = carry_flag;
            overflow = 1'b0;
        end
        SUB: begin
            r = add_sub_result;
            carry = carry_flag;
            overflow = sub_overflow;
        end
        SUBU: begin
            r = add_sub_result;
            carry = carry_flag;
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
            flag = slt_flag;
            r = {31'b0, slt_flag};
        end
        SLTU: begin
            flag = sltu_flag;
            r = {31'b0, sltu_flag};
        end
        SLL, SRL, SRA, SLLV, SRLV, SRAV: begin
            r = shift_out;
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

    negative = r[31];
end

assign zero = (r == 32'b0);

endmodule