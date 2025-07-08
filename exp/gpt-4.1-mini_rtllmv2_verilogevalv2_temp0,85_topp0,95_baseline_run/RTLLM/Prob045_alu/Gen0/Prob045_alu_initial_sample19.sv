module alu(
    input  [31:0] a,
    input  [31:0] b,
    input  [5:0]  aluc,
    output reg [31:0] r,
    output zero,
    output reg carry,
    output negative,
    output reg overflow,
    output reg flag
);
    // Opcodes
    parameter ADD   = 6'b100000;
    parameter ADDU  = 6'b100001;
    parameter SUB   = 6'b100010;
    parameter SUBU  = 6'b100011;
    parameter AND   = 6'b100100;
    parameter OR    = 6'b100101;
    parameter XOR   = 6'b100110;
    parameter NOR   = 6'b100111;
    parameter SLT   = 6'b101010;
    parameter SLTU  = 6'b101011;
    parameter SLL   = 6'b000000;
    parameter SRL   = 6'b000010;
    parameter SRA   = 6'b000011;
    parameter SLLV  = 6'b000100;
    parameter SRLV  = 6'b000110;
    parameter SRAV  = 6'b000111;
    parameter LUI   = 6'b001111;

    reg [32:0] res; // 33 bits to capture carry out for add/sub

    wire signed [31:0] sa = a;
    wire signed [31:0] sb = b;

    wire [4:0] shamt_imm = a[4:0];
    wire [4:0] shamt_var = b[4:0];

    always @(*) begin
        carry = 1'b0;
        overflow = 1'b0;
        flag = 1'bz;
        res = 33'bz;
        r = 32'bz;
        case(aluc)
            ADD: begin
                res = {1'b0, a} + {1'b0, b};
                r = res[31:0];
                carry = res[32];
                // signed overflow detection
                overflow = (~a[31] & ~b[31] & r[31]) | (a[31] & b[31] & ~r[31]);
            end
            ADDU: begin
                res = {1'b0, a} + {1'b0, b};
                r = res[31:0];
                carry = res[32];
                overflow = 1'b0;
            end
            SUB: begin
                res = {1'b0, a} - {1'b0, b};
                r = res[31:0];
                carry = res[32]; // in subtraction carry = borrow flag, so res[32] = 1 means no borrow if 1 or borrow if 0? In MIPS carry used for unsigned. For subtraction carry is borrow inverted.
                // signed overflow detection for subtraction
                overflow = (a[31] & ~b[31] & ~r[31]) | (~a[31] & b[31] & r[31]);
            end
            SUBU: begin
                res = {1'b0, a} - {1'b0, b};
                r = res[31:0];
                carry = res[32];
                overflow = 1'b0;
            end
            AND: begin
                r = a & b;
            end
            OR: begin
                r = a | b;
            end
            XOR: begin
                r = a ^ b;
            end
            NOR: begin
                r = ~(a | b);
            end
            SLT: begin
                r = (sa < sb) ? 32'd1 : 32'd0;
                flag = r[0];
            end
            SLTU: begin
                r = (a < b) ? 32'd1 : 32'd0;
                flag = r[0];
            end
            SLL: begin
                r = b << shamt_imm;
            end
            SRL: begin
                r = b >> shamt_imm;
            end
            SRA: begin
                r = $signed(b) >>> shamt_imm;
            end
            SLLV: begin
                r = b << shamt_var;
            end
            SRLV: begin
                r = b >> shamt_var;
            end
            SRAV: begin
                r = $signed(b) >>> shamt_var;
            end
            LUI: begin
                r = {b[15:0],16'b0};
            end
            default: begin
                r = 32'bz;
                carry = 1'bz;
                overflow = 1'bz;
                flag = 1'bz;
            end
        endcase
    end

    assign zero = (r == 32'b0) ? 1'b1 : 1'b0;
    assign negative = r[31];

endmodule