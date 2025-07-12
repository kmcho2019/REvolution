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
wire [4:0] shamt = a[4:0];

// Arithmetic with carry
wire [32:0] add_res  = {1'b0,a} + {1'b0,b};
wire [32:0] addu_res = {1'b0,a} + {1'b0,b};
wire [32:0] sub_res  = {1'b0,a} - {1'b0,b};
wire [32:0] subu_res = {1'b0,a} - {1'b0,b};

// Logical operations
wire [31:0] and_res  = a & b;
wire [31:0] or_res   = a | b;
wire [31:0] xor_res  = a ^ b;
wire [31:0] nor_res  = ~(a | b);

// Set less than signed and unsigned
wire slt_flag  = (a_s < b_s);
wire sltu_flag = (a < b);

// Shift operations
wire [31:0] sll_res  = b << shamt;
wire [31:0] srl_res  = b >> shamt;
wire [31:0] sra_res  = $signed(b_s) >>> shamt;
wire [31:0] sllv_res = b << a[4:0];
wire [31:0] srlv_res = b >> a[4:0];
wire [31:0] srav_res = $signed(b_s) >>> a[4:0];

// LUI operation
wire [31:0] lui_res = {a[15:0], 16'b0};

// Default result (zero)
wire [31:0] default_res = 32'b0;

// Result mux
reg [31:0] result_reg;
reg carry_reg, overflow_reg;
reg flag_reg;

always @(*) begin
    result_reg = default_res;
    carry_reg = 1'b0;
    overflow_reg = 1'b0;
    flag_reg = 1'b0;

    case (aluc)
        ADD: begin
            result_reg = add_res[31:0];
            carry_reg = add_res[32];
            overflow_reg = (~a[31] & ~b[31] & result_reg[31]) | (a[31] & b[31] & ~result_reg[31]);
        end
        ADDU: begin
            result_reg = addu_res[31:0];
            carry_reg = addu_res[32];
        end
        SUB: begin
            result_reg = sub_res[31:0];
            carry_reg = sub_res[32];
            overflow_reg = (a[31] & ~b[31] & ~result_reg[31]) | (~a[31] & b[31] & result_reg[31]);
        end
        SUBU: begin
            result_reg = subu_res[31:0];
            carry_reg = subu_res[32];
        end
        AND:  result_reg = and_res;
        OR:   result_reg = or_res;
        XOR:  result_reg = xor_res;
        NOR:  result_reg = nor_res;
        SLT: begin
            flag_reg = slt_flag;
            result_reg = {31'b0, flag_reg};
        end
        SLTU: begin
            flag_reg = sltu_flag;
            result_reg = {31'b0, flag_reg};
        end
        SLL:  result_reg = sll_res;
        SRL:  result_reg = srl_res;
        SRA:  result_reg = sra_res;
        SLLV: result_reg = sllv_res;
        SRLV: result_reg = srlv_res;
        SRAV: result_reg = srav_res;
        LUI:  result_reg = lui_res;
        default: begin
            result_reg = default_res;
            flag_reg = 1'b0;
        end
    endcase
end

assign r = result_reg;
assign carry = carry_reg;
assign overflow = overflow_reg;
assign flag = (aluc == SLT || aluc == SLTU) ? flag_reg : 1'b0;
assign zero = (result_reg == 32'b0);
assign negative = result_reg[31];

endmodule