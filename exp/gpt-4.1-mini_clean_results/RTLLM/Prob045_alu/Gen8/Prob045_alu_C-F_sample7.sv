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

// Opcodes as parameters
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

// Precompute arithmetic results with carry/borrow
wire [32:0] add_res  = {1'b0, a} + {1'b0, b};
wire [32:0] sub_res  = {1'b0, a} - {1'b0, b};

// Precompute logical results
wire [31:0] and_res = a & b;
wire [31:0] or_res  = a | b;
wire [31:0] xor_res = a ^ b;
wire [31:0] nor_res = ~(a | b);

// Precompute shift results
wire [31:0] sll_res  = b << shamt;
wire [31:0] srl_res  = b >> shamt;
wire [31:0] sra_res  = $signed(b_s) >>> shamt;
wire [31:0] sllv_res = b << a[4:0];
wire [31:0] srlv_res = b >> a[4:0];
wire [31:0] srav_res = $signed(b_s) >>> a[4:0];

// Precompute SLT flags and results
wire slt_flag  = (a_s < b_s);
wire sltu_flag = (a < b);
wire [31:0] slt_res  = slt_flag ? 32'd1 : 32'd0;
wire [31:0] sltu_res = sltu_flag ? 32'd1 : 32'd0;

// Precompute LUI result (upper 16 bits = a[15:0], lower 16 bits zero)
wire [31:0] lui_res = {a[15:0], 16'b0};

// Overflow detection for ADD/SUB
wire overflow_add = (~a[31] & ~b[31] & add_res[31]) | (a[31] & b[31] & ~add_res[31]);
wire overflow_sub = (a[31] & ~b[31] & ~sub_res[31]) | (~a[31] & b[31] & sub_res[31]);

always @(*) begin
    // Default values to avoid latches and reduce unnecessary toggling
    r = 32'b0;
    carry = 1'b0;
    overflow = 1'b0;
    flag = 1'b0;
    negative = 1'b0;
    zero = 1'b0;

    case (aluc)
        ADD: begin
            r = add_res[31:0];
            carry = add_res[32];
            overflow = overflow_add;
        end
        ADDU: begin
            r = add_res[31:0];
            carry = add_res[32];
            overflow = 1'b0;
        end
        SUB: begin
            r = sub_res[31:0];
            carry = sub_res[32];
            overflow = overflow_sub;
        end
        SUBU: begin
            r = sub_res[31:0];
            carry = sub_res[32];
            overflow = 1'b0;
        end
        AND: begin
            r = and_res;
        end
        OR: begin
            r = or_res;
        end
        XOR: begin
            r = xor_res;
        end
        NOR: begin
            r = nor_res;
        end
        SLT: begin
            r = slt_res;
            flag = slt_flag;
        end
        SLTU: begin
            r = sltu_res;
            flag = sltu_flag;
        end
        SLL: begin
            r = sll_res;
        end
        SRL: begin
            r = srl_res;
        end
        SRA: begin
            r = sra_res;
        end
        SLLV: begin
            r = sllv_res;
        end
        SRLV: begin
            r = srlv_res;
        end
        SRAV: begin
            r = srav_res;
        end
        LUI: begin
            r = lui_res;
        end
        default: begin
            // For unsupported opcodes, set outputs to zero by default
            r = 32'b0;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
    endcase

    negative = r[31];
    zero = (r == 32'b0);
end

endmodule