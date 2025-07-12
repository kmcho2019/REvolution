module alu (
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

reg [32:0] arith_res; // 33-bit result for arithmetic ops to detect carry out
reg [31:0] shift_res;
reg slt_val, sltu_val;

wire [4:0] shamt_imm = a[4:0];   // For shift by immediate (SLL, SRL, SRA)
wire [4:0] shamt_var = a[4:0];   // For shift by variable (SLLV, SRLV, SRAV)

wire signed [31:0] a_s = $signed(a);
wire signed [31:0] b_s = $signed(b);

always @(*) begin
    // Default assignments: mark outputs as undefined where applicable
    r = 32'bz;
    zero = 1'b0;
    carry = 1'b0;
    negative = 1'b0;
    overflow = 1'b0;
    flag = 1'bz;

    case (aluc)
        ADD: begin
            arith_res = {1'b0, a} + {1'b0, b};
            r = arith_res[31:0];
            carry = arith_res[32];
            // Overflow detection for signed addition
            overflow = (~a[31] & ~b[31] & r[31]) | (a[31] & b[31] & ~r[31]);
            flag = 1'bz;
        end
        ADDU: begin
            arith_res = {1'b0, a} + {1'b0, b};
            r = arith_res[31:0];
            carry = arith_res[32];
            overflow = 1'b0; // No overflow for unsigned add
            flag = 1'bz;
        end
        SUB: begin
            arith_res = {1'b0, a} - {1'b0, b};
            r = arith_res[31:0];
            carry = arith_res[32]; // borrow detection (1 means no borrow for subtraction)
            // Overflow detection for signed subtraction
            overflow = (a[31] & ~b[31] & ~r[31]) | (~a[31] & b[31] & r[31]);
            flag = 1'bz;
        end
        SUBU: begin
            arith_res = {1'b0, a} - {1'b0, b};
            r = arith_res[31:0];
            carry = arith_res[32]; // borrow detection
            overflow = 1'b0; // No overflow for unsigned subtraction
            flag = 1'bz;
        end
        AND: begin
            r = a & b;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'bz;
        end
        OR: begin
            r = a | b;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'bz;
        end
        XOR: begin
            r = a ^ b;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'bz;
        end
        NOR: begin
            r = ~(a | b);
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'bz;
        end
        SLT: begin
            slt_val = (a_s < b_s) ? 1'b1 : 1'b0;
            r = {31'b0, slt_val};
            carry = 1'b0;
            overflow = 1'b0;
            flag = slt_val;
        end
        SLTU: begin
            sltu_val = (a < b) ? 1'b1 : 1'b0;
            r = {31'b0, sltu_val};
            carry = 1'b0;
            overflow = 1'b0;
            flag = sltu_val;
        end
        SLL: begin
            shift_res = b << shamt_imm;
            r = shift_res;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'bz;
        end
        SRL: begin
            shift_res = b >> shamt_imm;
            r = shift_res;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'bz;
        end
        SRA: begin
            shift_res = $signed(b_s) >>> shamt_imm;
            r = shift_res;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'bz;
        end
        SLLV: begin
            shift_res = b << shamt_var;
            r = shift_res;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'bz;
        end
        SRLV: begin
            shift_res = b >> shamt_var;
            r = shift_res;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'bz;
        end
        SRAV: begin
            shift_res = $signed(b_s) >>> shamt_var;
            r = shift_res;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'bz;
        end
        LUI: begin
            // Load Upper Immediate: a[15:0] in upper half, lower 16 bits zero
            r = {a[15:0], 16'b0};
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'bz;
        end
        default: begin
            r = 32'bz;     // Undefined operation result
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'bz;
        end
    endcase

    zero = (r === 32'b0) ? 1'b1 : 1'b0;
    negative = (r[31] === 1'b1) ? 1'b1 : 1'b0;
end

endmodule