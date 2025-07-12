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

// Internal wires and helper functions
wire [4:0] shamt_imm = b[4:0]; // Shift amount for immediate shift ops (SLL, SRL, SRA)
wire [4:0] shamt_var = a[4:0]; // Shift amount for variable shift ops (SLLV, SRLV, SRAV)

function [32:0] add33;
    input [31:0] x;
    input [31:0] y;
    begin
        add33 = {1'b0, x} + {1'b0, y};
    end
endfunction

function [32:0] sub33;
    input [31:0] x;
    input [31:0] y;
    begin
        sub33 = {1'b0, x} - {1'b0, y};
    end
endfunction

function is_overflow_add;
    input [31:0] x;
    input [31:0] y;
    input [31:0] res32;
    begin
        // Overflow when operands have same sign but result has different sign
        is_overflow_add = (~x[31] & ~y[31] & res32[31]) | (x[31] & y[31] & ~res32[31]);
    end
endfunction

function is_overflow_sub;
    input [31:0] x;
    input [31:0] y;
    input [31:0] res32;
    begin
        // Overflow when signs differ: x pos, y neg, result neg OR x neg, y pos, result pos
        is_overflow_sub = (x[31] & ~y[31] & ~res32[31]) | (~x[31] & y[31] & res32[31]);
    end
endfunction

wire signed [31:0] a_signed = a;
wire signed [31:0] b_signed = b;

reg [32:0] arith_res; // 33-bit for carry out
reg [31:0] res_val;
reg flg;

always @(*) begin
    // Default outputs
    r = 32'b0;
    carry = 1'b0;
    overflow = 1'b0;
    flag = 1'b0;

    case (aluc)
        ADD: begin
            arith_res = add33(a, b);
            r = arith_res[31:0];
            carry = arith_res[32];
            overflow = is_overflow_add(a, b, r);
            flag = 1'b0;
        end
        ADDU: begin
            arith_res = add33(a, b);
            r = arith_res[31:0];
            carry = arith_res[32];
            overflow = 1'b0;
            flag = 1'b0;
        end
        SUB: begin
            arith_res = sub33(a, b);
            r = arith_res[31:0];
            carry = arith_res[32];
            overflow = is_overflow_sub(a, b, r);
            flag = 1'b0;
        end
        SUBU: begin
            arith_res = sub33(a, b);
            r = arith_res[31:0];
            carry = arith_res[32];
            overflow = 1'b0;
            flag = 1'b0;
        end
        AND: begin
            r = a & b;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
        OR: begin
            r = a | b;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
        XOR: begin
            r = a ^ b;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
        NOR: begin
            r = ~(a | b);
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
        SLT: begin
            flg = (a_signed < b_signed);
            r = {31'b0, flg};
            carry = 1'b0;
            overflow = 1'b0;
            flag = flg;
        end
        SLTU: begin
            flg = (a < b);
            r = {31'b0, flg};
            carry = 1'b0;
            overflow = 1'b0;
            flag = flg;
        end
        SLL: begin
            r = b << shamt_imm;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
        SRL: begin
            r = b >> shamt_imm;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
        SRA: begin
            r = $signed(b) >>> shamt_imm;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
        SLLV: begin
            r = b << shamt_var;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
        SRLV: begin
            r = b >> shamt_var;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
        SRAV: begin
            r = $signed(b) >>> shamt_var;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
        LUI: begin
            // Load upper immediate: b is the immediate, shift left 16 bits
            r = b << 16;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
        default: begin
            r = 32'b0;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
    endcase
end

assign zero = (r == 32'b0);
assign negative = r[31];

endmodule