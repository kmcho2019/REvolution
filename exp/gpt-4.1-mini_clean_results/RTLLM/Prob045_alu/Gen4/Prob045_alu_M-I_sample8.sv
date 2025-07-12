module alu(
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [5:0]  aluc,
    output reg  [31:0] r,
    output reg         zero,
    output reg         carry,
    output reg         negative,
    output reg         overflow,
    output wire        flag
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

// Internal signals
wire is_add  = (aluc == ADD);
wire is_addu = (aluc == ADDU);
wire is_sub  = (aluc == SUB);
wire is_subu = (aluc == SUBU);
wire is_and  = (aluc == AND);
wire is_or   = (aluc == OR);
wire is_xor  = (aluc == XOR);
wire is_nor  = (aluc == NOR);
wire is_slt  = (aluc == SLT);
wire is_sltu = (aluc == SLTU);
wire is_sll  = (aluc == SLL);
wire is_srl  = (aluc == SRL);
wire is_sra  = (aluc == SRA);
wire is_sllv = (aluc == SLLV);
wire is_srlv = (aluc == SRLV);
wire is_srav = (aluc == SRAV);
wire is_lui  = (aluc == LUI);

wire signed [31:0] a_s = $signed(a);
wire signed [31:0] b_s = $signed(b);
wire [4:0] shamt = a[4:0];

// Shared adder/subtractor logic
// Subtract if is_sub or is_subu
wire sub_op = is_sub | is_subu;
// For subtraction: b_in = ~b + 1 (2's complement), else b_in = b
wire [31:0] b_operand = sub_op ? ~b : b;
wire carry_in = sub_op ? 1'b1 : 1'b0;

// 33-bit addition to capture carry out
wire [32:0] addsub_res = {1'b0, a} + {1'b0, b_operand} + carry_in;

// Result of add/sub
wire [31:0] addsub_result = addsub_res[31:0];
wire carry_out = addsub_res[32];

// Overflow detection for signed add/sub
wire overflow_add = (is_add) && ((a[31] == b[31]) && (addsub_result[31] != a[31]));
wire overflow_sub = (is_sub) && ((a[31] != b[31]) && (addsub_result[31] != a[31]));
wire ovf = overflow_add | overflow_sub;

// Unsigned comparison for SLTU
wire sltu_flag = (a < b);

// Signed comparison for SLT
wire slt_flag = (a_s < b_s);

// Bitwise operations
wire [31:0] and_res = a & b;
wire [31:0] or_res = a | b;
wire [31:0] xor_res = a ^ b;
wire [31:0] nor_res = ~(a | b);

// Shift operations
wire [31:0] sll_res = b << shamt;
wire [31:0] srl_res = b >> shamt;
wire [31:0] sra_res = $signed(b_s) >>> shamt;

wire [31:0] sllv_res = b << a[4:0];
wire [31:0] srlv_res = b >> a[4:0];
wire [31:0] srav_res = $signed(b_s) >>> a[4:0];

// LUI operation
wire [31:0] lui_res = {a[15:0], 16'b0};

// flag output: only defined for SLT and SLTU, else high impedance 'z'
// Using a tri-state output as per requirement
assign flag = (is_slt)  ? slt_flag :
              (is_sltu) ? sltu_flag :
                          1'bz;

// Combinational result and flags logic
always @(*) begin
    case (1'b1)
        is_add,
        is_addu,
        is_sub,
        is_subu: begin
            r = addsub_result;
            carry = carry_out;
            overflow = ovf;
        end
        is_and:  begin r = and_res;  carry = 1'b0; overflow = 1'b0; end
        is_or:   begin r = or_res;   carry = 1'b0; overflow = 1'b0; end
        is_xor:  begin r = xor_res;  carry = 1'b0; overflow = 1'b0; end
        is_nor:  begin r = nor_res;  carry = 1'b0; overflow = 1'b0; end
        is_slt:  begin r = {31'b0, slt_flag};  carry = 1'b0; overflow = 1'b0; end
        is_sltu: begin r = {31'b0, sltu_flag}; carry = 1'b0; overflow = 1'b0; end
        is_sll:  begin r = sll_res;  carry = 1'b0; overflow = 1'b0; end
        is_srl:  begin r = srl_res;  carry = 1'b0; overflow = 1'b0; end
        is_sra:  begin r = sra_res;  carry = 1'b0; overflow = 1'b0; end
        is_sllv: begin r = sllv_res; carry = 1'b0; overflow = 1'b0; end
        is_srlv: begin r = srlv_res; carry = 1'b0; overflow = 1'b0; end
        is_srav: begin r = srav_res; carry = 1'b0; overflow = 1'b0; end
        is_lui:  begin r = lui_res;  carry = 1'b0; overflow = 1'b0; end
        default: begin r = 32'bz;    carry = 1'b0; overflow = 1'b0; end
    endcase

    // zero flag: high if result is zero (if r is high-Z, zero should be 0)
    zero = (r === 32'b0) ? 1'b1 : 1'b0;

    // negative flag: sign bit of result (safe if r is z to 0)
    negative = (r[31] === 1'b1) ? 1'b1 : 1'b0;
end

endmodule