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

// Define opcodes
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
wire [4:0] shamt = a[4:0];

// Arithmetic operations
wire [32:0] add_full = {1'b0, a} + {1'b0, b};
wire [32:0] addu_full = {1'b0, a} + {1'b0, b};
wire [32:0] sub_full = {1'b0, a} - {1'b0, b};
wire [32:0] subu_full = {1'b0, a} - {1'b0, b};

// Overflow detection for signed add
wire add_overflow = (~a[31] & ~b[31] & add_full[31]) | (a[31] & b[31] & ~add_full[31]);
// Overflow detection for signed sub
wire sub_overflow = (a[31] & ~b[31] & ~sub_full[31]) | (~a[31] & b[31] & sub_full[31]);

// Shift operations
wire [31:0] sll  = b << shamt;
wire [31:0] srl  = b >> shamt;
wire [31:0] sra  = $signed(b_s) >>> shamt;
wire [31:0] sllv = b << a[4:0];
wire [31:0] srlv = b >> a[4:0];
wire [31:0] srav = $signed(b_s) >>> a[4:0];

// Logical operations
wire [31:0] and_r = a & b;
wire [31:0] or_r  = a | b;
wire [31:0] xor_r = a ^ b;
wire [31:0] nor_r = ~(a | b);

// Comparison operations
wire slt_flag  = (a_s < b_s) ? 1'b1 : 1'b0;
wire sltu_flag = (a < b) ? 1'b1 : 1'b0;

// LUI operation: load upper immediate (commonly upper 16 bits of immediate shifted)
wire [31:0] lui_r = {a[15:0], 16'b0};

// Result selection
reg [31:0] res;
reg carry_r;
reg overflow_r;

always @(*) begin
    res = 32'b0;
    carry_r = 1'b0;
    overflow_r = 1'b0;
    case (aluc)
        ADD: begin
            res = add_full[31:0];
            carry_r = add_full[32];
            overflow_r = add_overflow;
        end
        ADDU: begin
            res = addu_full[31:0];
            carry_r = addu_full[32];
            overflow_r = 1'b0;
        end
        SUB: begin
            res = sub_full[31:0];
            carry_r = sub_full[32];
            overflow_r = sub_overflow;
        end
        SUBU: begin
            res = subu_full[31:0];
            carry_r = subu_full[32];
            overflow_r = 1'b0;
        end
        AND:  res = and_r;
        OR:   res = or_r;
        XOR:  res = xor_r;
        NOR:  res = nor_r;
        SLT:  res = {31'b0, slt_flag};
        SLTU: res = {31'b0, sltu_flag};
        SLL:  res = sll;
        SRL:  res = srl;
        SRA:  res = sra;
        SLLV: res = sllv;
        SRLV: res = srlv;
        SRAV: res = srav;
        LUI:  res = lui_r;
        default: begin
            res = 32'b0;
            carry_r = 1'b0;
            overflow_r = 1'b0;
        end
    endcase
end

// Outputs from assigned registers/wires
assign r = res;
assign zero = (res == 32'b0);
assign negative = res[31];
assign carry = carry_r;
assign overflow = overflow_r;
assign flag = (aluc == SLT)  ? slt_flag :
              (aluc == SLTU) ? sltu_flag :
                               1'b0;

endmodule