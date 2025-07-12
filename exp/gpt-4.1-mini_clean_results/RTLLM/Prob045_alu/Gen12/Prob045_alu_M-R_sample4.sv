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

// Arithmetic operations with carry out
wire [32:0] add_res = {1'b0, a} + {1'b0, b};
wire [32:0] addu_res = {1'b0, a} + {1'b0, b};
wire [32:0] sub_res = {1'b0, a} - {1'b0, b};
wire [32:0] subu_res = {1'b0, a} - {1'b0, b};

// Logical operations
wire [31:0] and_res = a & b;
wire [31:0] or_res  = a | b;
wire [31:0] xor_res = a ^ b;
wire [31:0] nor_res = ~(a | b);

// Set on less than
wire slt_flag = (a_s < b_s);
wire sltu_flag = (a < b);

// Shift operations
wire [31:0] sll_res  = b << shamt;
wire [31:0] srl_res  = b >> shamt;
wire [31:0] sra_res  = $signed(b_s) >>> shamt;
wire [31:0] sllv_res = b << a[4:0];
wire [31:0] srlv_res = b >> a[4:0];
wire [31:0] srav_res = $signed(b_s) >>> a[4:0];

// LUI operation: upper 16 bits from 'a[15:0]', lower 16 bits zero
wire [31:0] lui_res = {a[15:0], 16'b0};

// Select result based on opcode
reg [31:0] res_mux;
reg carry_mux;
reg overflow_mux;
reg flag_mux;

always @(*) begin
    res_mux = 32'b0;
    carry_mux = 1'b0;
    overflow_mux = 1'b0;
    flag_mux = 1'b0;

    case (aluc)
        ADD: begin
            res_mux = add_res[31:0];
            carry_mux = add_res[32];
            // Overflow: if a and b have same sign but result has different sign
            overflow_mux = (~a[31] & ~b[31] & res_mux[31]) | (a[31] & b[31] & ~res_mux[31]);
        end
        ADDU: begin
            res_mux = addu_res[31:0];
            carry_mux = addu_res[32];
            overflow_mux = 1'b0;
        end
        SUB: begin
            res_mux = sub_res[31:0];
            carry_mux = sub_res[32];
            // Overflow: if a and b have different sign and result sign different from a
            overflow_mux = (a[31] & ~b[31] & ~res_mux[31]) | (~a[31] & b[31] & res_mux[31]);
        end
        SUBU: begin
            res_mux = subu_res[31:0];
            carry_mux = subu_res[32];
            overflow_mux = 1'b0;
        end
        AND: res_mux = and_res;
        OR:  res_mux = or_res;
        XOR: res_mux = xor_res;
        NOR: res_mux = nor_res;
        SLT: begin
            flag_mux = slt_flag;
            res_mux = {31'b0, slt_flag};
        end
        SLTU: begin
            flag_mux = sltu_flag;
            res_mux = {31'b0, sltu_flag};
        end
        SLL:  res_mux = sll_res;
        SRL:  res_mux = srl_res;
        SRA:  res_mux = sra_res;
        SLLV: res_mux = sllv_res;
        SRLV: res_mux = srlv_res;
        SRAV: res_mux = srav_res;
        LUI:  res_mux = lui_res;
        default: begin
            res_mux = 32'b0;
            carry_mux = 1'b0;
            overflow_mux = 1'b0;
            flag_mux = 1'b0;
        end
    endcase
end

assign r = res_mux;
assign zero = (res_mux == 32'b0);
assign negative = res_mux[31];
assign carry = carry_mux;
assign overflow = overflow_mux;
assign flag = (aluc == SLT || aluc == SLTU) ? flag_mux : 1'b0;

endmodule