module alu(
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [5:0]  aluc,
    output reg  [31:0] r,
    output wire        zero,
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

    wire [4:0] shamt_imm = a[4:0];
    wire [4:0] shamt_var = a[4:0];

    // Intermediate addition/subtraction with carry-out and overflow detection
    wire [32:0] add_res = {1'b0, a} + {1'b0, b};
    wire [32:0] sub_res = {1'b0, a} - {1'b0, b};

    wire add_carry_out = add_res[32];
    wire sub_carry_out = sub_res[32];

    // Overflow detection for signed addition
    wire add_overflow = (~a[31] & ~b[31] & add_res[31]) | (a[31] & b[31] & ~add_res[31]);
    // Overflow detection for signed subtraction
    wire sub_overflow = (a[31] & ~b[31] & ~sub_res[31]) | (~a[31] & b[31] & sub_res[31]);

    // Signed comparison for SLT
    wire slt_flag = ($signed(a) < $signed(b));
    // Unsigned comparison for SLTU
    wire sltu_flag = (a < b);

    // Compute shift results
    wire [31:0] sll  = b << shamt_imm;
    wire [31:0] srl  = b >> shamt_imm;
    wire [31:0] sra  = $signed(b) >>> shamt_imm;

    wire [31:0] sllv = b << shamt_var;
    wire [31:0] srlv = b >> shamt_var;
    wire [31:0] srav = $signed(b) >>> shamt_var;

    // LUI places lower 16 bits of b in upper half, lower 16 bits zero
    wire [31:0] lui_result = {b[15:0], 16'b0};

    // Main combinational logic
    always @(*) begin
        // Default outputs to high impedance for invalid opcodes
        r = 32'hzzzz_zzzz;
        carry = 1'bz;
        overflow = 1'bz;
        negative = 1'bz;
        flag = 1'bz;

        case (aluc)
            ADD: begin
                r = add_res[31:0];
                carry = add_carry_out;
                overflow = add_overflow;
                negative = r[31];
                flag = 1'bz;
            end
            ADDU: begin
                r = add_res[31:0];
                carry = add_carry_out;
                overflow = 1'b0;
                negative = r[31];
                flag = 1'bz;
            end
            SUB: begin
                r = sub_res[31:0];
                carry = sub_carry_out;
                overflow = sub_overflow;
                negative = r[31];
                flag = 1'bz;
            end
            SUBU: begin
                r = sub_res[31:0];
                carry = sub_carry_out;
                overflow = 1'b0;
                negative = r[31];
                flag = 1'bz;
            end
            AND: begin
                r = a & b;
                carry = 1'b0;
                overflow = 1'b0;
                negative = r[31];
                flag = 1'bz;
            end
            OR: begin
                r = a | b;
                carry = 1'b0;
                overflow = 1'b0;
                negative = r[31];
                flag = 1'bz;
            end
            XOR: begin
                r = a ^ b;
                carry = 1'b0;
                overflow = 1'b0;
                negative = r[31];
                flag = 1'bz;
            end
            NOR: begin
                r = ~(a | b);
                carry = 1'b0;
                overflow = 1'b0;
                negative = r[31];
                flag = 1'bz;
            end
            SLT: begin
                r = slt_flag ? 32'd1 : 32'd0;
                flag = slt_flag ? 1'b1 : 1'b0;
                carry = 1'b0;
                overflow = 1'b0;
                negative = r[31];
            end
            SLTU: begin
                r = sltu_flag ? 32'd1 : 32'd0;
                flag = sltu_flag ? 1'b1 : 1'b0;
                carry = 1'b0;
                overflow = 1'b0;
                negative = r[31];
            end
            SLL: begin
                r = sll;
                carry = 1'b0;
                overflow = 1'b0;
                negative = r[31];
                flag = 1'bz;
            end
            SRL: begin
                r = srl;
                carry = 1'b0;
                overflow = 1'b0;
                negative = r[31];
                flag = 1'bz;
            end
            SRA: begin
                r = sra;
                carry = 1'b0;
                overflow = 1'b0;
                negative = r[31];
                flag = 1'bz;
            end
            SLLV: begin
                r = sllv;
                carry = 1'b0;
                overflow = 1'b0;
                negative = r[31];
                flag = 1'bz;
            end
            SRLV: begin
                r = srlv;
                carry = 1'b0;
                overflow = 1'b0;
                negative = r[31];
                flag = 1'bz;
            end
            SRAV: begin
                r = srav;
                carry = 1'b0;
                overflow = 1'b0;
                negative = r[31];
                flag = 1'bz;
            end
            LUI: begin
                r = lui_result;
                carry = 1'b0;
                overflow = 1'b0;
                negative = r[31];
                flag = 1'bz;
            end
            default: begin
                r = 32'hzzzz_zzzz;
                carry = 1'bz;
                overflow = 1'bz;
                negative = 1'bz;
                flag = 1'bz;
            end
        endcase
    end

    assign zero = (r === 32'd0);

endmodule