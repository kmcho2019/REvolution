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

wire [4:0] shamt = a[4:0];
wire signed [31:0] a_s = a;
wire signed [31:0] b_s = b;

wire [32:0] add_ext  = {1'b0, a} + {1'b0, b};
wire [32:0] sub_ext  = {1'b0, a} - {1'b0, b};

// Arithmetic results
wire [31:0] add_res  = add_ext[31:0];
wire [31:0] sub_res  = sub_ext[31:0];

// Carry signals for arithmetic operations
wire add_carry = add_ext[32];
wire sub_carry = sub_ext[32];

// Overflow detection for signed add: (pos + pos = neg) or (neg + neg = pos)
wire add_overflow = (~a[31] & ~b[31] & add_res[31]) | (a[31] & b[31] & ~add_res[31]);
// Overflow detection for signed sub: (pos - neg = neg) or (neg - pos = pos)
wire sub_overflow = (a[31] & ~b[31] & ~sub_res[31]) | (~a[31] & b[31] & sub_res[31]);

// Logic operations
wire [31:0] and_res = a & b;
wire [31:0] or_res  = a | b;
wire [31:0] xor_res = a ^ b;
wire [31:0] nor_res = ~(a | b);

// Set less than (signed and unsigned)
wire slt_flag  = (a_s < b_s);
wire sltu_flag = (a < b);

// Shift operations
wire [31:0] sll_res  = b << shamt;
wire [31:0] srl_res  = b >> shamt;
wire [31:0] sra_res  = b_s >>> shamt;
wire [31:0] sllv_res = b << shamt;
wire [31:0] srlv_res = b >> shamt;
wire [31:0] srav_res = b_s >>> shamt;

// LUI operation: upper 16 bits = a[15:0], lower 16 bits = 0
wire [31:0] lui_res = a << 16;

// Default output
wire [31:0] default_res = 32'b0;

// Result mux
reg [31:0] result;
reg c;
reg ov;
reg fl;

always @(*) begin
    result = default_res;
    c = 1'b0;
    ov = 1'b0;
    fl = 1'b0;
    case (aluc)
        ADD: begin
            result = add_res;
            c = add_carry;
            ov = add_overflow;
        end
        ADDU: begin
            result = add_res;
            c = add_carry;
            ov = 1'b0;
        end
        SUB: begin
            result = sub_res;
            c = sub_carry;
            ov = sub_overflow;
        end
        SUBU: begin
            result = sub_res;
            c = sub_carry;
            ov = 1'b0;
        end
        AND:  result = and_res;
        OR:   result = or_res;
        XOR:  result = xor_res;
        NOR:  result = nor_res;
        SLT: begin
            result = {31'b0, slt_flag};
            fl = slt_flag;
        end
        SLTU: begin
            result = {31'b0, sltu_flag};
            fl = sltu_flag;
        end
        SLL:  result = sll_res;
        SRL:  result = srl_res;
        SRA:  result = sra_res;
        SLLV: result = sllv_res;
        SRLV: result = srlv_res;
        SRAV: result = srav_res;
        LUI:  result = lui_res;
        default: begin
            result = default_res;
            c = 1'b0;
            ov = 1'b0;
            fl = 1'b0;
        end
    endcase
end

assign r = result;
assign carry = c;
assign overflow = ov;
assign flag = fl;
assign zero = (result == 32'b0);
assign negative = result[31];

endmodule