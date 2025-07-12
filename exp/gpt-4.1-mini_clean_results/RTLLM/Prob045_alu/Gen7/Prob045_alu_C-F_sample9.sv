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
parameter ADD   = 6'b100000;
parameter ADDU  = 6'b100001;
parameter SUB   = 6'b100010;
parameter SUBU  = 6'b100011;
parameter AND   = 6'b100100;
parameter OR    = 6'b100101;
parameter XOR   = 6'b100110;
parameter NOR   = 6'b100111;
parameter SLT   = 6'b101010;
parameter SLTU  = 6'b101011;
parameter SLL   = 6'b000000;
parameter SRL   = 6'b000010;
parameter SRA   = 6'b000011;
parameter SLLV  = 6'b000100;
parameter SRLV  = 6'b000110;
parameter SRAV  = 6'b000111;
parameter LUI   = 6'b001111;

// Signed versions for signed operations
wire signed [31:0] a_s = $signed(a);
wire signed [31:0] b_s = $signed(b);

// Shift amounts
wire [4:0] shamt = a[4:0];

// Arithmetic extended operands for carry and overflow detection
wire [32:0] add_ext  = {1'b0, a} + {1'b0, b};
wire [32:0] sub_ext  = {1'b0, a} - {1'b0, b};
wire [32:0] add_s_ext = {a[31], a} + {b[31], b};
wire [32:0] sub_s_ext = {a[31], a} - {b[31], b};

// Arithmetic results
wire [31:0] res_addu = add_ext[31:0];
wire        carry_addu = add_ext[32];
wire [31:0] res_subu = sub_ext[31:0];
wire        carry_subu = sub_ext[32];

wire [31:0] res_add = add_s_ext[31:0];
wire        overflow_add = (~a[31] & ~b[31] & res_add[31]) | (a[31] & b[31] & ~res_add[31]);

wire [31:0] res_sub = sub_s_ext[31:0];
wire        overflow_sub = (a[31] & ~b[31] & ~res_sub[31]) | (~a[31] & b[31] & res_sub[31]);

// Bitwise logical results
wire [31:0] res_and = a & b;
wire [31:0] res_or  = a | b;
wire [31:0] res_xor = a ^ b;
wire [31:0] res_nor = ~(a | b);

// Set-less-than flags and results
wire slt_flag = (a_s < b_s);
wire [31:0] res_slt = slt_flag ? 32'd1 : 32'd0;

wire sltu_flag = (a < b);
wire [31:0] res_sltu = sltu_flag ? 32'd1 : 32'd0;

// Shift operations
wire [31:0] res_sll  = b << shamt;
wire [31:0] res_srl  = b >> shamt;
wire [31:0] res_sra  = b_s >>> shamt;

wire [31:0] res_sllv = b << a[4:0];
wire [31:0] res_srlv = b >> a[4:0];
wire [31:0] res_srav = b_s >>> a[4:0];

// LUI operation uses upper 16 bits of 'a' concatenated with 16 zeros
wire [31:0] res_lui = {a[31:16], 16'b0};

always @* begin
    // Default outputs
    r = 32'b0;
    carry = 1'b0;
    overflow = 1'b0;
    flag = 1'b0;

    case (aluc)
        ADD: begin
            r = res_add;
            carry = 1'b0; // MIPS does not define carry for signed add
            overflow = overflow_add;
        end
        ADDU: begin
            r = res_addu;
            carry = carry_addu;
            overflow = 1'b0;
        end
        SUB: begin
            r = res_sub;
            carry = 1'b0;
            overflow = overflow_sub;
        end
        SUBU: begin
            r = res_subu;
            carry = carry_subu;
            overflow = 1'b0;
        end
        AND:  r = res_and;
        OR:   r = res_or;
        XOR:  r = res_xor;
        NOR:  r = res_nor;
        SLT: begin
            r = res_slt;
            flag = slt_flag;
        end
        SLTU: begin
            r = res_sltu;
            flag = sltu_flag;
        end
        SLL:  r = res_sll;
        SRL:  r = res_srl;
        SRA:  r = res_sra;
        SLLV: r = res_sllv;
        SRLV: r = res_srlv;
        SRAV: r = res_srav;
        LUI:  r = res_lui;
        default: begin
            r = 32'b0;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
    endcase

    zero = (r == 32'b0);
    negative = r[31];
end

endmodule