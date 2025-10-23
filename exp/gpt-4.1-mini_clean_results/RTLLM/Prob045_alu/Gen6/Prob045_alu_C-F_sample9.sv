module alu(
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [5:0]  aluc,
    output reg  [31:0] r,
    output wire        zero,
    output reg         carry,
    output wire        negative,
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

// Signed versions of inputs
wire signed [31:0] a_s = $signed(a);
wire signed [31:0] b_s = $signed(b);

// Shift amount for immediate shifts
wire [4:0] shamt = a[4:0];

// Shared adder/subtractor logic
// For subtraction, invert b and add 1 (two's complement)
// carry_in set for subtract operations
wire is_sub = (aluc == SUB)  || (aluc == SUBU);
wire is_add = (aluc == ADD)  || (aluc == ADDU);

wire [31:0] b_operand = is_sub ? ~b : b;
wire carry_in = is_sub ? 1'b1 : 1'b0;

wire [32:0] addsub_ext = {1'b0, a} + {1'b0, b_operand} + carry_in;
wire [31:0] addsub_result = addsub_ext[31:0];
wire        carry_out = addsub_ext[32];

// Overflow detection for signed add/sub
// For ADD: overflow if inputs same sign but result sign differs
// For SUB: overflow if signs differ between operands, and result sign differs from a
wire overflow_add = (aluc == ADD)  && ((a[31] == b[31]) && (addsub_result[31] != a[31]));
wire overflow_sub = (aluc == SUB)  && ((a[31] != b[31]) && (addsub_result[31] != a[31]));
wire overflow_val = overflow_add | overflow_sub;

// SLT and SLTU flags
wire slt_flag  = (a_s < b_s);
wire sltu_flag = (a < b);

// Bitwise logic results
wire [31:0] and_res = a & b;
wire [31:0] or_res  = a | b;
wire [31:0] xor_res = a ^ b;
wire [31:0] nor_res = ~(a | b);

// Shift operations
wire [31:0] sll_res  = b << shamt;         // SLL uses shamt from a[4:0]
wire [31:0] srl_res  = b >> shamt;
wire [31:0] sra_res  = $signed(b_s) >>> shamt;

wire [31:0] sllv_res = b << a[4:0];        // variable shifts use a[4:0]
wire [31:0] srlv_res = b >> a[4:0];
wire [31:0] srav_res = $signed(b_s) >>> a[4:0];

// LUI operation: upper 16 bits from a[31:16], lower 16 bits zero
wire [31:0] lui_res = {a[31:16], 16'b0};

// zero and negative flags are combinational from r
assign zero     = (r == 32'b0);
assign negative = r[31];

// Combinational logic for ALU operations
always @(*) begin
    // Default outputs
    r        = 32'b0;
    carry    = 1'b0;
    overflow = 1'b0;
    flag     = 1'b0;

    case (aluc)
        ADD: begin
            r = addsub_result;
            carry = 1'b0;          // carry not defined for signed add
            overflow = overflow_val;
        end
        ADDU: begin
            r = addsub_result;
            carry = carry_out;
            overflow = 1'b0;
        end
        SUB: begin
            r = addsub_result;
            carry = 1'b0;          // carry not defined for signed sub
            overflow = overflow_val;
        end
        SUBU: begin
            r = addsub_result;
            // For subtraction carry indicates borrow inverted
            carry = (a >= b) ? 1'b1 : 1'b0;
            overflow = 1'b0;
        end
        AND: begin
            r = and_res;
            carry = 1'b0;
            overflow = 1'b0;
        end
        OR: begin
            r = or_res;
            carry = 1'b0;
            overflow = 1'b0;
        end
        XOR: begin
            r = xor_res;
            carry = 1'b0;
            overflow = 1'b0;
        end
        NOR: begin
            r = nor_res;
            carry = 1'b0;
            overflow = 1'b0;
        end
        SLT: begin
            r = {31'b0, slt_flag};
            flag = slt_flag ? 1'b1 : 1'b0;
            carry = 1'b0;
            overflow = 1'b0;
        end
        SLTU: begin
            r = {31'b0, sltu_flag};
            flag = sltu_flag ? 1'b1 : 1'b0;
            carry = 1'b0;
            overflow = 1'b0;
        end
        SLL: begin
            r = sll_res;
            carry = 1'b0;
            overflow = 1'b0;
        end
        SRL: begin
            r = srl_res;
            carry = 1'b0;
            overflow = 1'b0;
        end
        SRA: begin
            r = sra_res;
            carry = 1'b0;
            overflow = 1'b0;
        end
        SLLV: begin
            r = sllv_res;
            carry = 1'b0;
            overflow = 1'b0;
        end
        SRLV: begin
            r = srlv_res;
            carry = 1'b0;
            overflow = 1'b0;
        end
        SRAV: begin
            r = srav_res;
            carry = 1'b0;
            overflow = 1'b0;
        end
        LUI: begin
            r = lui_res;
            carry = 1'b0;
            overflow = 1'b0;
        end
        default: begin
            r = 32'b0;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
    endcase
end

endmodule