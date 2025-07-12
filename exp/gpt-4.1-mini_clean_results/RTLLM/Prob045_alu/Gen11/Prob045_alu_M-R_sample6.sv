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

wire signed [31:0] a_s = $signed(a);
wire signed [31:0] b_s = $signed(b);

reg [32:0] add_res_33;
reg [32:0] sub_res_33;
reg slt_flag_reg;
reg sltu_flag_reg;
reg carry_reg;
reg overflow_reg;
reg flag_reg;
reg [31:0] res_reg;

wire [4:0] shamt_imm = a[4:0];
wire [4:0] shamt_var = a[4:0];

always @(*) begin
    // Default assignments
    add_res_33 = 33'b0;
    sub_res_33 = 33'b0;
    carry_reg = 1'b0;
    overflow_reg = 1'b0;
    flag_reg = 1'b0;
    res_reg = 32'bz; // default to high impedance

    case (aluc)
        ADD: begin
            add_res_33 = {1'b0, a} + {1'b0, b};
            res_reg = add_res_33[31:0];
            carry_reg = add_res_33[32];
            // Overflow detection for signed addition:
            overflow_reg = (~a[31] & ~b[31] & res_reg[31]) | (a[31] & b[31] & ~res_reg[31]);
            flag_reg = 1'b0;
        end
        ADDU: begin
            add_res_33 = {1'b0, a} + {1'b0, b};
            res_reg = add_res_33[31:0];
            carry_reg = add_res_33[32];
            overflow_reg = 1'b0;
            flag_reg = 1'b0;
        end
        SUB: begin
            sub_res_33 = {1'b0, a} - {1'b0, b};
            res_reg = sub_res_33[31:0];
            carry_reg = sub_res_33[32];
            // Overflow detection for signed subtraction:
            overflow_reg = (a[31] & ~b[31] & ~res_reg[31]) | (~a[31] & b[31] & res_reg[31]);
            flag_reg = 1'b0;
        end
        SUBU: begin
            sub_res_33 = {1'b0, a} - {1'b0, b};
            res_reg = sub_res_33[31:0];
            carry_reg = sub_res_33[32];
            overflow_reg = 1'b0;
            flag_reg = 1'b0;
        end
        AND: begin
            res_reg = a & b;
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
            flag_reg = 1'b0;
        end
        OR: begin
            res_reg = a | b;
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
            flag_reg = 1'b0;
        end
        XOR: begin
            res_reg = a ^ b;
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
            flag_reg = 1'b0;
        end
        NOR: begin
            res_reg = ~(a | b);
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
            flag_reg = 1'b0;
        end
        SLT: begin
            slt_flag_reg = (a_s < b_s);
            res_reg = {31'b0, slt_flag_reg};
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
            flag_reg = slt_flag_reg;
        end
        SLTU: begin
            sltu_flag_reg = (a < b);
            res_reg = {31'b0, sltu_flag_reg};
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
            flag_reg = sltu_flag_reg;
        end
        SLL: begin
            res_reg = b << shamt_imm;
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
            flag_reg = 1'b0;
        end
        SRL: begin
            res_reg = b >> shamt_imm;
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
            flag_reg = 1'b0;
        end
        SRA: begin
            res_reg = $signed(b_s) >>> shamt_imm;
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
            flag_reg = 1'b0;
        end
        SLLV: begin
            res_reg = b << shamt_var;
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
            flag_reg = 1'b0;
        end
        SRLV: begin
            res_reg = b >> shamt_var;
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
            flag_reg = 1'b0;
        end
        SRAV: begin
            res_reg = $signed(b_s) >>> shamt_var;
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
            flag_reg = 1'b0;
        end
        LUI: begin
            res_reg = {a[15:0], 16'b0};
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
            flag_reg = 1'b0;
        end
        default: begin
            res_reg = 32'bz;  // High impedance for undefined operations
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
            flag_reg = 1'bz;
        end
    endcase

    zero = (res_reg == 32'b0);
    negative = res_reg[31];
    carry = carry_reg;
    overflow = overflow_reg;
    flag = flag_reg;
    r = res_reg;
end

endmodule