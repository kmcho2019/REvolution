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

    // Define operation parameters
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

    // Internal signed versions for signed operations
    wire signed [31:0] a_signed = a;
    wire signed [31:0] b_signed = b;

    reg [32:0] sum; // for carry detection in add/sub
    reg [31:0] shift_result;
    reg flag_slt;
    reg flag_sltu;

    always @(*) begin
        carry = 1'b0;
        overflow = 1'b0;
        flag = 1'bz;
        r = 32'bz;

        case(aluc)
            ADD: begin
                sum = {a[31], a} + {b[31], b};
                r = sum[31:0];
                carry = sum[32];
                // overflow detection for signed addition
                overflow = (~a_signed[31] & ~b_signed[31] & r[31]) | (a_signed[31] & b_signed[31] & ~r[31]);
                flag = 1'bz;
            end
            ADDU: begin
                sum = {1'b0, a} + {1'b0, b};
                r = sum[31:0];
                carry = sum[32];
                overflow = 1'b0;
                flag = 1'bz;
            end
            SUB: begin
                sum = {a[31], a} - {b[31], b};
                r = sum[31:0];
                carry = (a >= b) ? 1'b0 : 1'b1; // borrow indication reversed for carry signal convention
                // overflow detection for signed subtraction
                overflow = (a_signed[31] & ~b_signed[31] & ~r[31]) | (~a_signed[31] & b_signed[31] & r[31]);
                flag = 1'bz;
            end
            SUBU: begin
                sum = {1'b0, a} - {1'b0, b};
                r = sum[31:0];
                carry = (a >= b) ? 1'b0 : 1'b1; // borrow indication
                overflow = 1'b0;
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
                // signed comparison
                flag_slt = (a_signed < b_signed);
                r = {31'b0, flag_slt};
                carry = 1'b0;
                overflow = 1'b0;
                flag = flag_slt;
            end
            SLTU: begin
                // unsigned comparison
                flag_sltu = (a < b);
                r = {31'b0, flag_sltu};
                carry = 1'b0;
                overflow = 1'b0;
                flag = flag_sltu;
            end
            SLL: begin
                shift_result = b << a[4:0];
                r = shift_result;
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end
            SRL: begin
                shift_result = b >> a[4:0];
                r = shift_result;
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end
            SRA: begin
                r = $signed(b) >>> a[4:0];
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end
            SLLV: begin
                shift_result = b << (a[4:0]);
                r = shift_result;
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end
            SRLV: begin
                shift_result = b >> (a[4:0]);
                r = shift_result;
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end
            SRAV: begin
                r = $signed(b) >>> (a[4:0]);
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end
            LUI: begin
                r = {b[15:0],16'b0}; // b is used for immediate value in LUI, per MIPS ISA convention
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end
            default: begin
                r = 32'bz;
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end
        endcase
    end

    assign zero = (r == 32'b0);
    assign negative = r[31];

endmodule