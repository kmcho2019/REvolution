`timescale 1ns/1ps
module alu (
    input  [31:0] a,
    input  [31:0] b,
    input  [5:0]  aluc,
    output reg [31:0] r,
    output        zero,
    output        carry,
    output        negative,
    output        overflow,
    output reg    flag
);

    // opcode parameters
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

    // Intermediate signals
    reg [32:0] sum; // 33 bits to detect carry out for addition/subtraction
    reg signed [31:0] a_s, b_s, res_s;
    reg carry_out;
    reg overflow_flag;
    reg [31:0] res;
    reg flag_int;

    // Assign signed versions for arithmetic
    always @* begin
        a_s = $signed(a);
        b_s = $signed(b);
    end

    always @* begin
        // Default assignments
        res = 32'b0;
        sum = 33'b0;
        carry_out = 1'b0;
        overflow_flag = 1'b0;
        flag_int = 1'bz;

        case(aluc)
            ADD: begin
                sum = {1'b0, a} + {1'b0, b};
                res = sum[31:0];
                carry_out = sum[32];
                // Overflow detection for signed addition
                overflow_flag = (~a[31] & ~b[31] & res[31]) | (a[31] & b[31] & ~res[31]);
                flag_int = 1'bz;
            end
            ADDU: begin
                sum = {1'b0, a} + {1'b0, b};
                res = sum[31:0];
                carry_out = sum[32];
                overflow_flag = 1'b0; // unsigned addition no overflow
                flag_int = 1'bz;
            end
            SUB: begin
                sum = {1'b0, a} - {1'b0, b};
                res = sum[31:0];
                carry_out = ~sum[32]; // borrow flag, carry set if no borrow (MIPS style)
                // Overflow detection for signed subtraction: a - b
                overflow_flag = (a[31] & ~b[31] & ~res[31]) | (~a[31] & b[31] & res[31]);
                flag_int = 1'bz;
            end
            SUBU: begin
                sum = {1'b0, a} - {1'b0, b};
                res = sum[31:0];
                carry_out = ~sum[32];
                overflow_flag = 1'b0; // unsigned subtraction no overflow
                flag_int = 1'bz;
            end
            AND: begin
                res = a & b;
                carry_out = 1'b0;
                overflow_flag = 1'b0;
                flag_int = 1'bz;
            end
            OR: begin
                res = a | b;
                carry_out = 1'b0;
                overflow_flag = 1'b0;
                flag_int = 1'bz;
            end
            XOR: begin
                res = a ^ b;
                carry_out = 1'b0;
                overflow_flag = 1'b0;
                flag_int = 1'bz;
            end
            NOR: begin
                res = ~(a | b);
                carry_out = 1'b0;
                overflow_flag = 1'b0;
                flag_int = 1'bz;
            end
            SLT: begin
                // signed compare: if a < b then 1 else 0
                res = ($signed(a) < $signed(b)) ? 32'b1 : 32'b0;
                carry_out = 1'b0;
                overflow_flag = 1'b0;
                flag_int = (aluc == SLT) ? 1'b1 : 1'bz;
            end
            SLTU: begin
                // unsigned compare: if a < b then 1 else 0
                res = (a < b) ? 32'b1 : 32'b0;
                carry_out = 1'b0;
                overflow_flag = 1'b0;
                flag_int = (aluc == SLTU) ? 1'b1 : 1'bz;
            end
            SLL: begin
                res = b << a[4:0];
                carry_out = 1'b0;
                overflow_flag = 1'b0;
                flag_int = 1'bz;
            end
            SRL: begin
                res = b >> a[4:0];
                carry_out = 1'b0;
                overflow_flag = 1'b0;
                flag_int = 1'bz;
            end
            SRA: begin
                res = $signed(b) >>> a[4:0];
                carry_out = 1'b0;
                overflow_flag = 1'b0;
                flag_int = 1'bz;
            end
            SLLV: begin
                res = b << (a[4:0]);
                carry_out = 1'b0;
                overflow_flag = 1'b0;
                flag_int = 1'bz;
            end
            SRLV: begin
                res = b >> (a[4:0]);
                carry_out = 1'b0;
                overflow_flag = 1'b0;
                flag_int = 1'bz;
            end
            SRAV: begin
                res = $signed(b) >>> (a[4:0]);
                carry_out = 1'b0;
                overflow_flag = 1'b0;
                flag_int = 1'bz;
            end
            LUI: begin
                // load upper immediate: upper 16 bits of b, lower 16 zero
                res = {b[15:0], 16'b0};
                carry_out = 1'b0;
                overflow_flag = 1'b0;
                flag_int = 1'bz;
            end
            default: begin
                res = 32'bz; // high impedance for undefined opcodes
                carry_out = 1'b0;
                overflow_flag = 1'b0;
                flag_int = 1'bz;
            end
        endcase
    end

    // Assign output r
    always @* begin
        r = res;
    end

    // Flags
    assign zero = (r == 32'b0);
    assign negative = r[31];
    assign carry = carry_out;
    assign overflow = overflow_flag;

    always @* begin
        flag = flag_int;
    end

endmodule