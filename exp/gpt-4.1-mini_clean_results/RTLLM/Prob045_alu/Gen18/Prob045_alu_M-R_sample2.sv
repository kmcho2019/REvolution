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

// Arithmetic operations with carry and overflow
wire [32:0] add_result = {1'b0, a} + {1'b0, b};
wire [32:0] sub_result = {1'b0, a} - {1'b0, b};

wire        add_overflow = (~a[31] & ~b[31] & add_result[31]) | (a[31] & b[31] & ~add_result[31]);
wire        sub_overflow = (a[31] & ~b[31] & ~sub_result[31]) | (~a[31] & b[31] & sub_result[31]);

// Logical operations
wire [31:0] and_res = a & b;
wire [31:0] or_res  = a | b;
wire [31:0] xor_res = a ^ b;
wire [31:0] nor_res = ~(a | b);

// Shift operations
wire [31:0] sll_res  = b << shamt;
wire [31:0] srl_res  = b >> shamt;
wire [31:0] sra_res  = $signed(b) >>> shamt;
wire [31:0] sllv_res = b << a[4:0];
wire [31:0] srlv_res = b >> a[4:0];
wire [31:0] srav_res = $signed(b) >>> a[4:0];

// Set operations
wire slt_flag = (a_s < b_s);
wire sltu_flag = (a < b);

// LUI operation
wire [31:0] lui_res = {a[15:0], 16'b0};

// Result multiplexer
reg [31:0] result;
reg        carry_out;
reg        ovf;
reg        flag_out;

always @(*) begin
    carry_out = 0;
    ovf = 0;
    flag_out = 0;
    case (aluc)
        ADD: begin
            result = add_result[31:0];
            carry_out = add_result[32];
            ovf = add_overflow;
        end
        ADDU: begin
            result = add_result[31:0];
            carry_out = add_result[32];
            ovf = 0;
        end
        SUB: begin
            result = sub_result[31:0];
            carry_out = sub_result[32];
            ovf = sub_overflow;
        end
        SUBU: begin
            result = sub_result[31:0];
            carry_out = sub_result[32];
            ovf = 0;
        end
        AND:  result = and_res;
        OR:   result = or_res;
        XOR:  result = xor_res;
        NOR:  result = nor_res;
        SLT:  begin
            flag_out = slt_flag;
            result = {31'b0, slt_flag};
        end
        SLTU: begin
            flag_out = sltu_flag;
            result = {31'b0, sltu_flag};
        end
        SLL:  result = sll_res;
        SRL:  result = srl_res;
        SRA:  result = sra_res;
        SLLV: result = sllv_res;
        SRLV: result = srlv_res;
        SRAV: result = srav_res;
        LUI:  result = lui_res;
        default: result = 32'b0;
    endcase
end

assign r = result;
assign carry = carry_out;
assign overflow = ovf;
assign flag = flag_out;
assign zero = (result == 32'b0);
assign negative = result[31];

endmodule