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

// Signed inputs for arithmetic and comparisons
wire signed [31:0] a_s = $signed(a);
wire signed [31:0] b_s = $signed(b);

// Shift amounts (both immediate and variable)
wire [4:0] shamt_imm = a[4:0];
wire [4:0] shamt_var = a[4:0]; // For SLLV, SRLV, SRAV use a[4:0]

// Shared adder-subtractor 33-bit for ADD/ADDU/SUB/SUBU
wire is_sub = (aluc == SUB) || (aluc == SUBU);

wire [32:0] addsub_res = is_sub ? ({1'b0, a} - {1'b0, b}) : ({1'b0, a} + {1'b0, b});
wire [31:0] addsub_res_32 = addsub_res[31:0];
wire carry_out = addsub_res[32];

// Overflow detection (only for signed ADD and SUB)
wire add_overflow = (~a[31] & ~b[31] & addsub_res_32[31]) | (a[31] & b[31] & ~addsub_res_32[31]);
wire sub_overflow = (a[31] & ~b[31] & ~addsub_res_32[31]) | (~a[31] & b[31] & addsub_res_32[31]);

// Compute carry flag: for subtraction carry means no borrow: a >= b, for add carry is carry_out
wire carry_flag = is_sub ? (a >= b) : carry_out;

// Logic operations
wire [31:0] and_res = a & b;
wire [31:0] or_res  = a | b;
wire [31:0] xor_res = a ^ b;
wire [31:0] nor_res = ~(a | b);

// Shift operations
wire [31:0] sll_res  = b << shamt_imm;
wire [31:0] srl_res  = b >> shamt_imm;
wire [31:0] sra_res  = $signed(b_s) >>> shamt_imm;
wire [31:0] sllv_res = b << shamt_var;
wire [31:0] srlv_res = b >> shamt_var;
wire [31:0] srav_res = $signed(b_s) >>> shamt_var;

// Set less than (signed and unsigned)
wire slt_flag_val  = (a_s < b_s);
wire sltu_flag_val = (a < b);

// LUI: Load upper immediate (a[15:0] shifted left 16 bits)
wire [31:0] lui_res = {a[15:0], 16'b0};

always @(*) begin
    // Default assignments
    r = 32'b0;
    carry = 1'b0;
    overflow = 1'b0;
    flag = 1'b0;
    negative = 1'b0;

    case (aluc)
        ADD: begin
            r = addsub_res_32;
            carry = carry_flag;
            overflow = add_overflow;
        end
        ADDU: begin
            r = addsub_res_32;
            carry = carry_flag;
            overflow = 1'b0;
        end
        SUB: begin
            r = addsub_res_32;
            carry = carry_flag;
            overflow = sub_overflow;
        end
        SUBU: begin
            r = addsub_res_32;
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
            flag = slt_flag_val ? 1'b1 : 1'b0;
            r = {31'b0, flag};
        end
        SLTU: begin
            flag = sltu_flag_val ? 1'b1 : 1'b0;
            r = {31'b0, flag};
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

    negative = r[31];
end

assign zero = (r == 32'b0);

endmodule