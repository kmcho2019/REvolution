module alu(
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [5:0]  aluc,
    output wire [31:0] r,
    output wire        zero,
    output wire        carry,
    output wire        negative,
    output wire        overflow,
    output wire        flag
);

// Opcodes
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

wire signed [31:0] a_s = a;
wire signed [31:0] b_s = b;
wire [4:0] shamt = a[4:0];

// Arithmetic with extended width to catch carry/borrow
wire [32:0] add_full = {1'b0,a} + {1'b0,b};
wire [32:0] addu_full = {1'b0,a} + {1'b0,b};
wire [32:0] sub_full = {1'b0,a} - {1'b0,b};
wire [32:0] subu_full = {1'b0,a} - {1'b0,b};

// Logical operations
wire [31:0] and_r  = a & b;
wire [31:0] or_r   = a | b;
wire [31:0] xor_r  = a ^ b;
wire [31:0] nor_r  = ~(a | b);

// Set less than
wire slt_flag  = (a_s < b_s);
wire sltu_flag = (a < b);

// Shift operations
wire [31:0] sll_r  = b << shamt;
wire [31:0] srl_r  = b >> shamt;
wire [31:0] sra_r  = $signed(b) >>> shamt;
wire [31:0] sllv_r = b << a[4:0];
wire [31:0] srlv_r = b >> a[4:0];
wire [31:0] srav_r = $signed(b) >>> a[4:0];

// LUI: the original example uses a[15:0] as upper half
wire [31:0] lui_r = {a[15:0], 16'b0};

reg [31:0] r_reg;
reg carry_reg;
reg overflow_reg;
reg flag_reg;

always @* begin
    r_reg = 32'b0;
    carry_reg = 1'b0;
    overflow_reg = 1'b0;
    flag_reg = 1'b0;

    case(aluc)
        ADD: begin
            r_reg = add_full[31:0];
            carry_reg = add_full[32];
            // Overflow if sign(a) == sign(b) && sign(r) != sign(a)
            overflow_reg = (~a[31] & ~b[31] & r_reg[31]) | (a[31] & b[31] & ~r_reg[31]);
        end
        ADDU: begin
            r_reg = addu_full[31:0];
            carry_reg = addu_full[32];
            overflow_reg = 1'b0;
        end
        SUB: begin
            r_reg = sub_full[31:0];
            carry_reg = sub_full[32];
            // Overflow if sign(a) != sign(b) && sign(r) != sign(a)
            overflow_reg = (a[31] & ~b[31] & ~r_reg[31]) | (~a[31] & b[31] & r_reg[31]);
        end
        SUBU: begin
            r_reg = subu_full[31:0];
            carry_reg = subu_full[32];
            overflow_reg = 1'b0;
        end
        AND: r_reg = and_r;
        OR:  r_reg = or_r;
        XOR: r_reg = xor_r;
        NOR: r_reg = nor_r;
        SLT: begin
            flag_reg = slt_flag;
            r_reg = {31'b0, slt_flag};
        end
        SLTU: begin
            flag_reg = sltu_flag;
            r_reg = {31'b0, sltu_flag};
        end
        SLL:  r_reg = sll_r;
        SRL:  r_reg = srl_r;
        SRA:  r_reg = sra_r;
        SLLV: r_reg = sllv_r;
        SRLV: r_reg = srlv_r;
        SRAV: r_reg = srav_r;
        LUI:  r_reg = lui_r;
        default: begin
            r_reg = 32'b0;
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
            flag_reg = 1'b0;
        end
    endcase
end

assign r = r_reg;
assign zero = (r_reg == 32'b0);
assign negative = r_reg[31];
assign carry = carry_reg;
assign overflow = overflow_reg;
assign flag = ((aluc == SLT) || (aluc == SLTU)) ? flag_reg : 1'bz;

endmodule