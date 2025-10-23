module alu(
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [5:0]  aluc,
    output reg  [31:0] r,
    output reg         zero,
    output reg         carry,
    output reg         negative,
    output reg         overflow,
    output reg         flag
);

// Opcodes
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

// Internal function: arithmetic add/subtract
function [33:0] arithmetic_alu; 
    input [31:0] op_a;
    input [31:0] op_b;
    input        subtract; // 1 for subtraction, 0 for addition
    reg [32:0] sum;
    begin
        if (subtract)
            sum = {1'b0, op_a} + {1'b0, ~op_b} + 1'b1;
        else
            sum = {1'b0, op_a} + {1'b0, op_b};
        arithmetic_alu = {sum[32], sum}; // carry out + 33 bits (carry + 32 bits)
    end
endfunction

// Internal variables
reg [33:0] arith_res;     // 33 bits + carry out
reg [31:0] log_res;
reg [31:0] shift_res;
reg        slt_flag_val, sltu_flag_val;

wire [4:0] shamt_fixed = a[4:0];      // For fixed shift instructions, shift amount from a[4:0]
wire [4:0] shamt_var = a[4:0];        // For variable shift instructions, shift amount from a[4:0]

wire signed [31:0] a_signed = $signed(a);
wire signed [31:0] b_signed = $signed(b);

always @(*) begin
    // Default outputs
    r        = 32'b0;
    zero     = 1'b0;
    carry    = 1'b0;
    negative = 1'b0;
    overflow = 1'b0;
    flag     = 1'bz;

    arith_res = 34'b0;
    log_res = 32'b0;
    shift_res = 32'b0;
    slt_flag_val = 1'b0;
    sltu_flag_val = 1'b0;

    case (aluc)
        ADD: begin
            // Signed addition
            arith_res = arithmetic_alu(a, b, 1'b0);
            r = arith_res[31:0];
            carry = arith_res[33]; // carry out bit 33
            // Overflow: if signs of a and b same, but sign of result differs
            overflow = (~(a[31] ^ b[31])) & (a[31] ^ r[31]);
            negative = r[31];
            zero = (r == 32'b0);
            flag = 1'b0;
        end
        ADDU: begin
            // Unsigned addition, carry meaningful, overflow not
            arith_res = arithmetic_alu(a, b, 1'b0);
            r = arith_res[31:0];
            carry = arith_res[33];
            overflow = 1'b0;
            negative = r[31];
            zero = (r == 32'b0);
            flag = 1'b0;
        end
        SUB: begin
            // Signed subtraction
            arith_res = arithmetic_alu(a, b, 1'b1);
            r = arith_res[31:0];
            // For subtraction carry means borrow flag: carry=1 means no borrow
            carry = arith_res[33];
            overflow = ((a[31] ^ b[31]) & (a[31] ^ r[31]));
            negative = r[31];
            zero = (r == 32'b0);
            flag = 1'b0;
        end
        SUBU: begin
            // Unsigned subtraction
            arith_res = arithmetic_alu(a, b, 1'b1);
            r = arith_res[31:0];
            carry = arith_res[33];
            overflow = 1'b0;
            negative = r[31];
            zero = (r == 32'b0);
            flag = 1'b0;
        end
        AND: begin
            log_res = a & b;
            r = log_res;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            zero = (r == 32'b0);
            flag = 1'b0;
        end
        OR: begin
            log_res = a | b;
            r = log_res;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            zero = (r == 32'b0);
            flag = 1'b0;
        end
        XOR: begin
            log_res = a ^ b;
            r = log_res;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            zero = (r == 32'b0);
            flag = 1'b0;
        end
        NOR: begin
            log_res = ~(a | b);
            r = log_res;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            zero = (r == 32'b0);
            flag = 1'b0;
        end
        SLT: begin
            slt_flag_val = (a_signed < b_signed) ? 1'b1 : 1'b0;
            r = {31'b0, slt_flag_val};
            carry = 1'b0;
            overflow = 1'b0;
            negative = 1'b0;
            zero = (r == 32'b0);
            flag = slt_flag_val;
        end
        SLTU: begin
            sltu_flag_val = (a < b) ? 1'b1 : 1'b0;
            r = {31'b0, sltu_flag_val};
            carry = 1'b0;
            overflow = 1'b0;
            negative = 1'b0;
            zero = (r == 32'b0);
            flag = sltu_flag_val;
        end
        SLL: begin
            // Shift left logical by fixed amount in a[4:0], operand is b
            shift_res = b << shamt_fixed;
            r = shift_res;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            zero = (r == 32'b0);
            flag = 1'b0;
        end
        SRL: begin
            // Shift right logical by fixed amount in a[4:0], operand is b
            shift_res = b >> shamt_fixed;
            r = shift_res;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            zero = (r == 32'b0);
            flag = 1'b0;
        end
        SRA: begin
            // Shift right arithmetic by fixed amount in a[4:0], operand is b
            shift_res = $signed(b) >>> shamt_fixed;
            r = shift_res;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            zero = (r == 32'b0);
            flag = 1'b0;
        end
        SLLV: begin
            // Shift left logical by variable amount in a[4:0], operand is b
            shift_res = b << shamt_var;
            r = shift_res;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            zero = (r == 32'b0);
            flag = 1'b0;
        end
        SRLV: begin
            // Shift right logical by variable amount in a[4:0], operand is b
            shift_res = b >> shamt_var;
            r = shift_res;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            zero = (r == 32'b0);
            flag = 1'b0;
        end
        SRAV: begin
            // Shift right arithmetic by variable amount in a[4:0], operand is b
            shift_res = $signed(b) >>> shamt_var;
            r = shift_res;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            zero = (r == 32'b0);
            flag = 1'b0;
        end
        LUI: begin
            // Load upper immediate: shift a[15:0] left 16 bits
            r = {a[15:0], 16'b0};
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            zero = (r == 32'b0);
            flag = 1'b0;
        end
        default: begin
            // Default output on undefined opcode
            r = 32'b0;
            carry = 1'b0;
            overflow = 1'b0;
            negative = 1'b0;
            zero = 1'b1;
            flag = 1'bz;
        end
    endcase
end

endmodule