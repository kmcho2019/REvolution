module alu(
    input  [31:0] a,
    input  [31:0] b,
    input  [5:0]  aluc,
    output reg [31:0] r,
    output reg        zero,
    output reg        carry,
    output reg        negative,
    output reg        overflow,
    output reg        flag
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

wire [4:0] shamt = a[4:0];
wire signed [31:0] a_s = a;
wire signed [31:0] b_s = b;

reg [32:0] ext_sum;
reg [32:0] ext_sub;
reg        ovf_tmp;
reg        carry_tmp;

// Internal temporary flags
reg slt_flag;
reg sltu_flag;

always @(*) begin
    // Defaults
    r = 32'bz;
    zero = 1'b0;
    carry = 1'b0;
    negative = 1'b0;
    overflow = 1'b0;
    flag = 1'bz;

    case (aluc)
        ADD: begin
            ext_sum = {a[31], a} + {b[31], b};
            r = ext_sum[31:0];
            carry = ext_sum[32];
            // Overflow for signed add: (a and b positive, result negative) or (a and b negative, result positive)
            ovf_tmp = (~a[31] & ~b[31] & r[31]) | (a[31] & b[31] & ~r[31]);
            overflow = ovf_tmp;
        end
        ADDU: begin
            ext_sum = {1'b0, a} + {1'b0, b};
            r = ext_sum[31:0];
            carry = ext_sum[32];
            overflow = 1'b0; // no overflow in unsigned add
        end
        SUB: begin
            ext_sub = {a[31], a} - {b[31], b};
            r = ext_sub[31:0];
            carry = ext_sub[32];
            // Overflow for signed sub: (a negative, b positive, result positive) or (a positive, b negative, result negative)
            ovf_tmp = (a[31] & ~b[31] & ~r[31]) | (~a[31] & b[31] & r[31]);
            overflow = ovf_tmp;
        end
        SUBU: begin
            ext_sub = {1'b0, a} - {1'b0, b};
            r = ext_sub[31:0];
            carry = ext_sub[32];
            overflow = 1'b0; // no overflow in unsigned sub
        end
        AND: begin
            r = a & b;
            carry = 1'b0;
            overflow = 1'b0;
        end
        OR: begin
            r = a | b;
            carry = 1'b0;
            overflow = 1'b0;
        end
        XOR: begin
            r = a ^ b;
            carry = 1'b0;
            overflow = 1'b0;
        end
        NOR: begin
            r = ~(a | b);
            carry = 1'b0;
            overflow = 1'b0;
        end
        SLT: begin
            slt_flag = (a_s < b_s);
            r = slt_flag ? 32'd1 : 32'd0;
            flag = slt_flag ? 1'b1 : 1'b0;
            carry = 1'b0;
            overflow = 1'b0;
        end
        SLTU: begin
            sltu_flag = (a < b);
            r = sltu_flag ? 32'd1 : 32'd0;
            flag = sltu_flag ? 1'b1 : 1'b0;
            carry = 1'b0;
            overflow = 1'b0;
        end
        SLL: begin
            r = b << shamt;
            carry = 1'b0;
            overflow = 1'b0;
        end
        SRL: begin
            r = b >> shamt;
            carry = 1'b0;
            overflow = 1'b0;
        end
        SRA: begin
            r = $signed(b) >>> shamt;
            carry = 1'b0;
            overflow = 1'b0;
        end
        SLLV: begin
            r = b << shamt;
            carry = 1'b0;
            overflow = 1'b0;
        end
        SRLV: begin
            r = b >> shamt;
            carry = 1'b0;
            overflow = 1'b0;
        end
        SRAV: begin
            r = $signed(b) >>> shamt;
            carry = 1'b0;
            overflow = 1'b0;
        end
        LUI: begin
            // upper 16 bits of a concatenated with 16 zeros
            r = {a[31:16], 16'b0};
            carry = 1'b0;
            overflow = 1'b0;
        end
        default: begin
            r = 32'bz;
            carry = 1'b0;
            overflow = 1'b0;
        end
    endcase

    zero = (r == 32'b0);
    negative = r[31];
    // flag remains 'z' except for SLT/SLTU handled above
end

endmodule