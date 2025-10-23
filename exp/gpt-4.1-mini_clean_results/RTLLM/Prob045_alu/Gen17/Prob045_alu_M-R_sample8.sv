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

wire [4:0] shamt = a[4:0];

// Intermediate results for each operation
wire [32:0] add_res  = {1'b0, a} + {1'b0, b};
wire [32:0] addu_res = {1'b0, a} + {1'b0, b};
wire [32:0] sub_res  = {1'b0, a} - {1'b0, b};
wire [32:0] subu_res = {1'b0, a} - {1'b0, b};

wire [31:0] and_res = a & b;
wire [31:0] or_res  = a | b;
wire [31:0] xor_res = a ^ b;
wire [31:0] nor_res = ~(a | b);

wire slt_flag  = ($signed(a) < $signed(b)) ? 1'b1 : 1'b0;
wire sltu_flag = (a < b) ? 1'b1 : 1'b0;

wire [31:0] slt_res  = {31'b0, slt_flag};
wire [31:0] sltu_res = {31'b0, sltu_flag};

wire [31:0] sll_res  = b << shamt;
wire [31:0] srl_res  = b >> shamt;
wire [31:0] sra_res  = $signed(b) >>> shamt;

wire [31:0] sllv_res = b << a[4:0];
wire [31:0] srlv_res = b >> a[4:0];
wire [31:0] srav_res = $signed(b) >>> a[4:0];

wire [31:0] lui_res  = {a[15:0], 16'b0};

// Result selection
reg [31:0] r_reg;
reg carry_reg;
reg overflow_reg;
reg flag_reg;

always @(*) begin
    r_reg = 32'b0;
    carry_reg = 0;
    overflow_reg = 0;
    flag_reg = 0;

    case(aluc)
        ADD: begin
            r_reg = add_res[31:0];
            carry_reg = add_res[32];
            // Overflow detection for signed addition
            overflow_reg = (~a[31] & ~b[31] & r_reg[31]) | (a[31] & b[31] & ~r_reg[31]);
        end
        ADDU: begin
            r_reg = addu_res[31:0];
            carry_reg = addu_res[32];
        end
        SUB: begin
            r_reg = sub_res[31:0];
            carry_reg = sub_res[32];
            // Overflow detection for signed subtraction
            overflow_reg = (a[31] & ~b[31] & ~r_reg[31]) | (~a[31] & b[31] & r_reg[31]);
        end
        SUBU: begin
            r_reg = subu_res[31:0];
            carry_reg = subu_res[32];
        end
        AND:  r_reg = and_res;
        OR:   r_reg = or_res;
        XOR:  r_reg = xor_res;
        NOR:  r_reg = nor_res;
        SLT: begin
            r_reg = slt_res;
            flag_reg = slt_flag;
        end
        SLTU: begin
            r_reg = sltu_res;
            flag_reg = sltu_flag;
        end
        SLL:  r_reg = sll_res;
        SRL:  r_reg = srl_res;
        SRA:  r_reg = sra_res;
        SLLV: r_reg = sllv_res;
        SRLV: r_reg = srlv_res;
        SRAV: r_reg = srav_res;
        LUI:  r_reg = lui_res;
        default: begin
            r_reg = 32'b0;
            carry_reg = 0;
            overflow_reg = 0;
            flag_reg = 0;
        end
    endcase
end

assign r        = r_reg;
assign carry    = carry_reg;
assign overflow = overflow_reg;
assign flag     = flag_reg;
assign zero     = (r_reg == 32'b0);
assign negative = r_reg[31];

endmodule