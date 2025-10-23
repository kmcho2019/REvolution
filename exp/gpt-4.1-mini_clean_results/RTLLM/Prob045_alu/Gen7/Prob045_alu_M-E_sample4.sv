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

// Intermediate signals for arithmetic with carry out
reg [32:0] add_res;
reg [32:0] sub_res;

// Signed operands for signed comparisons and arithmetic
wire signed [31:0] a_s = $signed(a);
wire signed [31:0] b_s = $signed(b);

// Shift amounts
wire [4:0] shamt = a[4:0];
wire [4:0] shamt_var = a[4:0]; // variable shifts use a's lower 5 bits

// Compute addition and subtraction once for reuse
always @(*) begin
    add_res = {1'b0, a} + {1'b0, b};
    sub_res = {1'b0, a} - {1'b0, b};
end

// Overflow detection functions for add and sub
function overflow_add;
    input [31:0] op1, op2, res32;
    begin
        // Overflow if op1 and op2 have same sign, but result sign differs
        overflow_add = (~op1[31] & ~op2[31] & res32[31]) | (op1[31] & op2[31] & ~res32[31]);
    end
endfunction

function overflow_sub;
    input [31:0] op1, op2, res32;
    begin
        // Overflow if op1 and op2 have different signs and result sign differs from op1
        overflow_sub = (op1[31] & ~op2[31] & ~res32[31]) | (~op1[31] & op2[31] & res32[31]);
    end
endfunction

// Main combinational block to select output and flags
always @(*) begin
    // Default values
    r = 32'b0;
    zero = 1'b0;
    carry = 1'b0;
    negative = 1'b0;
    overflow = 1'b0;
    flag = 1'bz; // High impedance by default except SLT/SLTU

    case (aluc)
        ADD: begin
            r = add_res[31:0];
            carry = add_res[32];
            overflow = overflow_add(a, b, r);
        end

        ADDU: begin
            r = add_res[31:0];
            carry = add_res[32];
            overflow = 1'b0;
        end

        SUB: begin
            r = sub_res[31:0];
            carry = sub_res[32];
            overflow = overflow_sub(a, b, r);
        end

        SUBU: begin
            r = sub_res[31:0];
            carry = sub_res[32];
            overflow = 1'b0;
        end

        AND: r = a & b;
        OR:  r = a | b;
        XOR: r = a ^ b;
        NOR: r = ~(a | b);

        SLT: begin
            flag = (a_s < b_s) ? 1'b1 : 1'b0;
            r = {31'b0, flag};
        end

        SLTU: begin
            flag = (a < b) ? 1'b1 : 1'b0;
            r = {31'b0, flag};
        end

        SLL:  r = b << shamt;
        SRL:  r = b >> shamt;
        SRA:  r = $signed(b) >>> shamt;
        SLLV: r = b << shamt_var;
        SRLV: r = b >> shamt_var;
        SRAV: r = $signed(b) >>> shamt_var;

        LUI:  r = {a[15:0], 16'b0};

        default: begin
            r = 32'bz; // high impedance for undefined opcode
            flag = 1'bz;
            carry = 1'b0;
            overflow = 1'b0;
        end
    endcase

    zero = (r == 32'b0);
    negative = r[31];
end

endmodule