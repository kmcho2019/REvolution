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

// Signed casts for arithmetic and shifts
wire signed [31:0] a_s = a;
wire signed [31:0] b_s = b;

// Shift amounts
wire [4:0] shamt_fixed = a[4:0]; // for fixed shifts
wire [4:0] shamt_var   = a[4:0]; // for variable shifts (same as fixed here)

// Intermediate wires
reg [31:0] arith_res;
reg       arith_carry;
reg       arith_overflow;

reg [31:0] logic_res;
reg [31:0] shift_res;
reg        slt_flag;
reg        sltu_flag;

// Arithmetic operations
always @(*) begin
    arith_res = 32'b0;
    arith_carry = 1'b0;
    arith_overflow = 1'b0;
    case(aluc)
        ADD: begin
            {arith_carry, arith_res} = a + b;
            // Overflow detection for signed addition
            arith_overflow = (~a[31] & ~b[31] &  arith_res[31]) | (a[31] & b[31] & ~arith_res[31]);
        end
        ADDU: begin
            {arith_carry, arith_res} = a + b;
            arith_overflow = 1'b0;
        end
        SUB: begin
            {arith_carry, arith_res} = a - b;
            // Overflow detection for signed subtraction
            arith_overflow = (a[31] & ~b[31] & ~arith_res[31]) | (~a[31] & b[31] & arith_res[31]);
        end
        SUBU: begin
            {arith_carry, arith_res} = a - b;
            arith_overflow = 1'b0;
        end
        default: begin
            arith_res = 32'b0;
            arith_carry = 1'b0;
            arith_overflow = 1'b0;
        end
    endcase
end

// Logical operations
always @(*) begin
    case(aluc)
        AND: logic_res = a & b;
        OR:  logic_res = a | b;
        XOR: logic_res = a ^ b;
        NOR: logic_res = ~(a | b);
        default: logic_res = 32'b0;
    endcase
end

// Shift operations
always @(*) begin
    case(aluc)
        SLL:  shift_res = b << shamt_fixed;
        SRL:  shift_res = b >> shamt_fixed;
        SRA:  shift_res = b_s >>> shamt_fixed;
        SLLV: shift_res = b << shamt_var;
        SRLV: shift_res = b >> shamt_var;
        SRAV: shift_res = b_s >>> shamt_var;
        default: shift_res = 32'b0;
    endcase
end

// SLT and SLTU flags and results
always @(*) begin
    slt_flag  = 1'b0;
    sltu_flag = 1'b0;
    case(aluc)
        SLT:  slt_flag  = (a_s < b_s);
        SLTU: sltu_flag = (a < b);
    endcase
end

// Final output mux
always @(*) begin
    carry = 1'b0;
    overflow = 1'b0;
    flag = 1'b0;
    case(aluc)
        ADD, ADDU, SUB, SUBU: begin
            r = arith_res;
            carry = arith_carry;
            overflow = arith_overflow;
        end
        AND, OR, XOR, NOR: begin
            r = logic_res;
        end
        SLL, SRL, SRA, SLLV, SRLV, SRAV: begin
            r = shift_res;
        end
        SLT: begin
            r = {31'b0, slt_flag};
            flag = slt_flag;
        end
        SLTU: begin
            r = {31'b0, sltu_flag};
            flag = sltu_flag;
        end
        LUI: begin
            // Load upper immediate: result = b[15:0] << 16
            r = {b[15:0], 16'b0};
        end
        default: begin
            r = 32'b0;
        end
    endcase
end

// Continuous assignments for zero and negative
assign zero = (r == 32'b0);
assign negative = r[31];

endmodule