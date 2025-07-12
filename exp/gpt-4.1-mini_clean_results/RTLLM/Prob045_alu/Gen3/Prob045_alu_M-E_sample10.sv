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

wire signed [31:0] a_s = a;
wire signed [31:0] b_s = b;
wire [4:0] shamt = a[4:0];

reg [32:0] add_ext;
reg [32:0] sub_ext;
reg signed [32:0] add_s_ext;
reg signed [32:0] sub_s_ext;

always @* begin
    // Defaults
    r = 32'bz;
    zero = 1'b0;
    carry = 1'b0;
    negative = 1'b0;
    overflow = 1'b0;
    flag = 1'bz;

    case (aluc)
        ADD: begin
            add_s_ext = {a_s[31], a_s} + {b_s[31], b_s};
            r = add_s_ext[31:0];
            carry = 1'b0; // carry flag not defined for signed add in MIPS ALU
            // overflow when signs of inputs same, result sign differs
            overflow = (~a_s[31] & ~b_s[31] & r[31]) | (a_s[31] & b_s[31] & ~r[31]);
            zero = (r == 32'b0);
            negative = r[31];
            flag = 1'bz;
        end
        ADDU: begin
            add_ext = {1'b0, a} + {1'b0, b};
            r = add_ext[31:0];
            carry = add_ext[32];
            overflow = 1'b0; // overflow not valid for unsigned add
            zero = (r == 32'b0);
            negative = r[31];
            flag = 1'bz;
        end
        SUB: begin
            sub_s_ext = {a_s[31], a_s} - {b_s[31], b_s};
            r = sub_s_ext[31:0];
            carry = 1'b0; // carry flag not defined for signed sub in MIPS ALU
            // overflow when signs of inputs differ and result sign differs from a_s
            overflow = (a_s[31] & ~b_s[31] & ~r[31]) | (~a_s[31] & b_s[31] & r[31]);
            zero = (r == 32'b0);
            negative = r[31];
            flag = 1'bz;
        end
        SUBU: begin
            sub_ext = {1'b0, a} - {1'b0, b};
            r = sub_ext[31:0];
            carry = sub_ext[32]; // borrow flag (carry) for unsigned subtraction
            overflow = 1'b0;
            zero = (r == 32'b0);
            negative = r[31];
            flag = 1'bz;
        end
        AND: begin
            r = a & b;
            zero = (r == 32'b0);
            negative = r[31];
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'bz;
        end
        OR: begin
            r = a | b;
            zero = (r == 32'b0);
            negative = r[31];
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'bz;
        end
        XOR: begin
            r = a ^ b;
            zero = (r == 32'b0);
            negative = r[31];
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'bz;
        end
        NOR: begin
            r = ~(a | b);
            zero = (r == 32'b0);
            negative = r[31];
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'bz;
        end
        SLT: begin
            if (a_s < b_s)
                r = 32'd1;
            else
                r = 32'd0;
            zero = (r == 32'b0);
            negative = r[31];
            carry = 1'b0;
            overflow = 1'b0;
            flag = (a_s < b_s) ? 1'b1 : 1'b0;
        end
        SLTU: begin
            if (a < b)
                r = 32'd1;
            else
                r = 32'd0;
            zero = (r == 32'b0);
            negative = r[31];
            carry = 1'b0;
            overflow = 1'b0;
            flag = (a < b) ? 1'b1 : 1'b0;
        end
        SLL: begin
            r = b << shamt;
            zero = (r == 32'b0);
            negative = r[31];
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'bz;
        end
        SRL: begin
            r = b >> shamt;
            zero = (r == 32'b0);
            negative = r[31];
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'bz;
        end
        SRA: begin
            r = $signed(b) >>> shamt;
            zero = (r == 32'b0);
            negative = r[31];
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'bz;
        end
        SLLV: begin
            r = b << shamt;
            zero = (r == 32'b0);
            negative = r[31];
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'bz;
        end
        SRLV: begin
            r = b >> shamt;
            zero = (r == 32'b0);
            negative = r[31];
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'bz;
        end
        SRAV: begin
            r = $signed(b) >>> shamt;
            zero = (r == 32'b0);
            negative = r[31];
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'bz;
        end
        LUI: begin
            // According to prompt: "upper 16 bits of 'a' concatenated with 16 zeros"
            r = {a[31:16], 16'b0};
            zero = (r == 32'b0);
            negative = r[31];
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'bz;
        end
        default: begin
            r = 32'bz; // undefined operation
            zero = 1'b0;
            carry = 1'b0;
            negative = 1'b0;
            overflow = 1'b0;
            flag = 1'bz;
        end
    endcase
end

endmodule