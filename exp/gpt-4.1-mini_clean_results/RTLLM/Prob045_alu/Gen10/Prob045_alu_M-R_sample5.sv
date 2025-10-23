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

reg [32:0] arith_res;  // 33-bit result for carry detection
reg        arith_carry;
reg        arith_overflow;
reg        slt_flag;
reg        sltu_flag;
reg [31:0] shifted;

always @* begin
    // Defaults
    r = 32'bz;
    carry = 1'b0;
    overflow = 1'b0;
    negative = 1'b0;
    zero = 1'b0;
    flag = 1'bz;

    arith_res = 33'b0;
    arith_carry = 1'b0;
    arith_overflow = 1'b0;
    slt_flag = 1'b0;
    sltu_flag = 1'b0;
    shifted = 32'b0;

    case (aluc)
        ADD: begin
            arith_res = {1'b0, a} + {1'b0, b};
            r = arith_res[31:0];
            carry = arith_res[32];
            // Detect signed overflow: if a and b have same sign but result sign differs
            overflow = (~a[31] & ~b[31] & r[31]) | (a[31] & b[31] & ~r[31]);
            negative = r[31];
            zero = (r == 32'b0);
            flag = 1'bz;
        end
        ADDU: begin
            arith_res = {1'b0, a} + {1'b0, b};
            r = arith_res[31:0];
            carry = arith_res[32];
            overflow = 1'b0; // unsigned addition: no overflow flag
            negative = r[31];
            zero = (r == 32'b0);
            flag = 1'bz;
        end
        SUB: begin
            arith_res = {1'b0, a} - {1'b0, b};
            r = arith_res[31:0];
            carry = arith_res[32];
            // Overflow detection for subtraction
            overflow = (a[31] & ~b[31] & ~r[31]) | (~a[31] & b[31] & r[31]);
            negative = r[31];
            zero = (r == 32'b0);
            flag = 1'bz;
        end
        SUBU: begin
            arith_res = {1'b0, a} - {1'b0, b};
            r = arith_res[31:0];
            carry = arith_res[32];
            overflow = 1'b0;
            negative = r[31];
            zero = (r == 32'b0);
            flag = 1'bz;
        end
        AND: begin
            r = a & b;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            zero = (r == 32'b0);
            flag = 1'bz;
        end
        OR: begin
            r = a | b;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            zero = (r == 32'b0);
            flag = 1'bz;
        end
        XOR: begin
            r = a ^ b;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            zero = (r == 32'b0);
            flag = 1'bz;
        end
        NOR: begin
            r = ~(a | b);
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            zero = (r == 32'b0);
            flag = 1'bz;
        end
        SLT: begin
            slt_flag = ($signed(a) < $signed(b));
            r = {31'b0, slt_flag};
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            zero = (r == 32'b0);
            flag = slt_flag;
        end
        SLTU: begin
            sltu_flag = (a < b);
            r = {31'b0, sltu_flag};
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            zero = (r == 32'b0);
            flag = sltu_flag;
        end
        SLL: begin
            shifted = b << a[4:0];
            r = shifted;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            zero = (r == 32'b0);
            flag = 1'bz;
        end
        SRL: begin
            shifted = b >> a[4:0];
            r = shifted;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            zero = (r == 32'b0);
            flag = 1'bz;
        end
        SRA: begin
            shifted = $signed(b) >>> a[4:0];
            r = shifted;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            zero = (r == 32'b0);
            flag = 1'bz;
        end
        SLLV: begin
            shifted = b << a[4:0];
            r = shifted;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            zero = (r == 32'b0);
            flag = 1'bz;
        end
        SRLV: begin
            shifted = b >> a[4:0];
            r = shifted;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            zero = (r == 32'b0);
            flag = 1'bz;
        end
        SRAV: begin
            shifted = $signed(b) >>> a[4:0];
            r = shifted;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            zero = (r == 32'b0);
            flag = 1'bz;
        end
        LUI: begin
            // Load upper immediate: upper 16 bits from a[15:0], lower 16 bits zero
            r = {a[15:0], 16'b0};
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            zero = (r == 32'b0);
            flag = 1'bz;
        end
        default: begin
            r = 32'bz;
            carry = 1'b0;
            overflow = 1'b0;
            negative = 1'b0;
            zero = 1'b0;
            flag = 1'bz;
        end
    endcase
end

endmodule