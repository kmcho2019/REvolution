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

// Signed versions of inputs for comparison and arithmetic
wire signed [31:0] a_s = $signed(a);
wire signed [31:0] b_s = $signed(b);

// Shared adder-subtractor: select add or subtract based on operation
// 33 bits to capture carry/borrow
wire is_subtract = (aluc == SUB) || (aluc == SUBU);

wire [32:0] add_sub_res = is_subtract ? ({1'b0, a} - {1'b0, b}) : ({1'b0, a} + {1'b0, b});

wire [31:0] add_sub_result = add_sub_res[31:0];
wire carry_out = add_sub_res[32];

// Overflow detection for signed addition and subtraction
wire add_overflow = (~a[31] & ~b[31] & add_sub_result[31]) | (a[31] & b[31] & ~add_sub_result[31]);
wire sub_overflow = (a[31] & ~b[31] & ~add_sub_result[31]) | (~a[31] & b[31] & add_sub_result[31]);

// For carry, treat carry_out as carry for add and borrow inverted for subtract
wire carry_flag = is_subtract ? (a >= b) : carry_out;

// Shifts
wire [4:0] shamt = a[4:0];
wire [4:0] b_shamt = b[4:0];

wire [31:0] sll_b = b << shamt;
wire [31:0] srl_b = b >> shamt;
wire [31:0] sra_b = $signed(b) >>> shamt;

wire [31:0] sllv_b = b << a[4:0];
wire [31:0] srlv_b = b >> a[4:0];
wire [31:0] srav_b = $signed(b) >>> a[4:0];

// Bitwise logic
wire [31:0] and_ab = a & b;
wire [31:0] or_ab  = a | b;
wire [31:0] xor_ab = a ^ b;
wire [31:0] nor_ab = ~(a | b);

// SLT and SLTU comparisons
wire slt_flag  = (a_s < b_s);
wire sltu_flag = (a < b);

// LUI operation
wire [31:0] lui_res = {a[15:0], 16'b0};

always @(*) begin
    // Defaults
    r = 32'b0;
    carry = 1'b0;
    overflow = 1'b0;
    flag = 1'b0;
    negative = 1'b0;

    case (aluc)
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
            r = and_ab;
        end
        OR: begin
            r = or_ab;
        end
        XOR: begin
            r = xor_ab;
        end
        NOR: begin
            r = nor_ab;
        end
        SLT: begin
            flag = slt_flag ? 1'b1 : 1'b0;
            r = {31'b0, flag};
        end
        SLTU: begin
            flag = sltu_flag ? 1'b1 : 1'b0;
            r = {31'b0, flag};
        end
        SLL: begin
            r = sll_b;
        end
        SRL: begin
            r = srl_b;
        end
        SRA: begin
            r = sra_b;
        end
        SLLV: begin
            r = sllv_b;
        end
        SRLV: begin
            r = srlv_b;
        end
        SRAV: begin
            r = srav_b;
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