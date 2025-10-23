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

    // Intermediate signals
    wire signed [31:0] a_s = a;
    wire signed [31:0] b_s = b;

    // Extended arithmetic for carry and overflow detection
    wire [32:0] add_ext = {1'b0, a} + {1'b0, b};
    wire [32:0] addu_ext = {1'b0, a} + {1'b0, b};
    wire [32:0] sub_ext = {1'b0, a} - {1'b0, b};
    wire [32:0] subu_ext = {1'b0, a} - {1'b0, b};

    // Logical operations
    wire [31:0] and_res = a & b;
    wire [31:0] or_res = a | b;
    wire [31:0] xor_res = a ^ b;
    wire [31:0] nor_res = ~(a | b);

    // Shift amounts
    wire [4:0] shamt_imm = a[4:0];
    wire [4:0] shamt_var = a[4:0];

    // Shift results
    wire [31:0] sll_res = b << shamt_imm;
    wire [31:0] srl_res = b >> shamt_imm;
    wire [31:0] sra_res = $signed(b) >>> shamt_imm;
    wire [31:0] sllv_res = b << shamt_var;
    wire [31:0] srlv_res = b >> shamt_var;
    wire [31:0] srav_res = $signed(b) >>> shamt_var;

    // LUI result: Load upper immediate with b[15:0] shifted left by 16 bits
    wire [31:0] lui_res = {b[15:0], 16'b0};

    // Flags for slt and sltu
    wire slt_flag = (a_s < b_s);
    wire sltu_flag = (a < b);

    always @(*) begin
        // Default assignments
        r = 32'b0;
        carry = 1'b0;
        overflow = 1'b0;
        negative = 1'b0;
        flag = 1'b0;

        case (aluc)
            ADD: begin
                r = add_ext[31:0];
                carry = add_ext[32];
                // Overflow: if sign of a and b are same but sign of r differs
                overflow = (~a[31] & ~b[31] & r[31]) | (a[31] & b[31] & ~r[31]);
                negative = r[31];
                flag = 1'b0;
            end
            ADDU: begin
                r = addu_ext[31:0];
                carry = addu_ext[32];
                overflow = 1'b0;
                negative = r[31];
                flag = 1'b0;
            end
            SUB: begin
                r = sub_ext[31:0];
                // Borrow detection: carry set if no borrow
                carry = ~sub_ext[32];
                // Overflow for subtraction
                overflow = (a[31] & ~b[31] & ~r[31]) | (~a[31] & b[31] & r[31]);
                negative = r[31];
                flag = 1'b0;
            end
            SUBU: begin
                r = subu_ext[31:0];
                carry = ~subu_ext[32];
                overflow = 1'b0;
                negative = r[31];
                flag = 1'b0;
            end
            AND: begin
                r = and_res;
                carry = 1'b0;
                overflow = 1'b0;
                negative = r[31];
                flag = 1'b0;
            end
            OR: begin
                r = or_res;
                carry = 1'b0;
                overflow = 1'b0;
                negative = r[31];
                flag = 1'b0;
            end
            XOR: begin
                r = xor_res;
                carry = 1'b0;
                overflow = 1'b0;
                negative = r[31];
                flag = 1'b0;
            end
            NOR: begin
                r = nor_res;
                carry = 1'b0;
                overflow = 1'b0;
                negative = r[31];
                flag = 1'b0;
            end
            SLT: begin
                r = 32'b0;
                r[0] = slt_flag ? 1'b1 : 1'b0;
                flag = slt_flag;
                carry = 1'b0;
                overflow = 1'b0;
                negative = r[31];
            end
            SLTU: begin
                r = 32'b0;
                r[0] = sltu_flag ? 1'b1 : 1'b0;
                flag = sltu_flag;
                carry = 1'b0;
                overflow = 1'b0;
                negative = r[31];
            end
            SLL: begin
                r = sll_res;
                carry = 1'b0;
                overflow = 1'b0;
                negative = r[31];
                flag = 1'b0;
            end
            SRL: begin
                r = srl_res;
                carry = 1'b0;
                overflow = 1'b0;
                negative = r[31];
                flag = 1'b0;
            end
            SRA: begin
                r = sra_res;
                carry = 1'b0;
                overflow = 1'b0;
                negative = r[31];
                flag = 1'b0;
            end
            SLLV: begin
                r = sllv_res;
                carry = 1'b0;
                overflow = 1'b0;
                negative = r[31];
                flag = 1'b0;
            end
            SRLV: begin
                r = srlv_res;
                carry = 1'b0;
                overflow = 1'b0;
                negative = r[31];
                flag = 1'b0;
            end
            SRAV: begin
                r = srav_res;
                carry = 1'b0;
                overflow = 1'b0;
                negative = r[31];
                flag = 1'b0;
            end
            LUI: begin
                r = lui_res;
                carry = 1'b0;
                overflow = 1'b0;
                negative = r[31];
                flag = 1'b0;
            end
            default: begin
                // For unrecognized opcodes, output zero and clear flags
                r = 32'b0;
                carry = 1'b0;
                overflow = 1'b0;
                negative = 1'b0;
                flag = 1'b0;
            end
        endcase
    end

    assign zero = (r == 32'b0);

endmodule