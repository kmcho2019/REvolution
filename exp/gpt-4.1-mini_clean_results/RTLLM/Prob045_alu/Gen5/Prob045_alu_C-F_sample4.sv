module alu(
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [5:0]  aluc,
    output reg  [31:0] r,
    output wire        zero,
    output reg         carry,
    output reg         negative,
    output reg         overflow,
    output wire        flag
);

// Define opcodes as parameters
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

reg slt_flag_reg;
reg sltu_flag_reg;

reg [32:0] arith_res;   // 33-bit for carry-out detection
reg [31:0] temp_r;
reg temp_carry;
reg temp_overflow;

always @(*) begin
    // Default outputs
    r        = 32'b0;
    carry    = 1'b0;
    overflow = 1'b0;
    negative = 1'b0;
    slt_flag_reg = 1'b0;
    sltu_flag_reg = 1'b0;
    arith_res = 33'd0;

    case (aluc)
        ADD: begin
            arith_res = {1'b0, a} + {1'b0, b};
            temp_r = arith_res[31:0];
            temp_carry = arith_res[32];
            // overflow detection for signed add: when inputs have same sign but result sign differs
            temp_overflow = (~(a[31] ^ b[31])) & (a[31] ^ temp_r[31]);
            r = temp_r;
            carry = temp_carry;
            overflow = temp_overflow;
        end

        ADDU: begin
            arith_res = {1'b0, a} + {1'b0, b};
            temp_r = arith_res[31:0];
            temp_carry = arith_res[32];
            r = temp_r;
            carry = temp_carry;
            overflow = 1'b0;
        end

        SUB: begin
            arith_res = {1'b0, a} - {1'b0, b};
            temp_r = arith_res[31:0];
            // carry: no borrow if a >= b, else borrow (carry=1 means no borrow)
            temp_carry = (a >= b);
            // overflow detection for signed sub: inputs signs differ & result sign differs from a
            temp_overflow = ((a[31] ^ b[31]) & (a[31] ^ temp_r[31]));
            r = temp_r;
            carry = temp_carry;
            overflow = temp_overflow;
        end

        SUBU: begin
            arith_res = {1'b0, a} - {1'b0, b};
            temp_r = arith_res[31:0];
            temp_carry = (a >= b);
            r = temp_r;
            carry = temp_carry;
            overflow = 1'b0;
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
            slt_flag_reg = (a_s < b_s);
            r = 32'b0;
            r[0] = slt_flag_reg;
            carry = 1'b0;
            overflow = 1'b0;
        end

        SLTU: begin
            sltu_flag_reg = (a < b);
            r = 32'b0;
            r[0] = sltu_flag_reg;
            carry = 1'b0;
            overflow = 1'b0;
        end

        SLL: begin
            r = b << a[4:0];
            carry = 1'b0;
            overflow = 1'b0;
        end

        SRL: begin
            r = b >> a[4:0];
            carry = 1'b0;
            overflow = 1'b0;
        end

        SRA: begin
            r = $signed(b_s) >>> a[4:0];
            carry = 1'b0;
            overflow = 1'b0;
        end

        SLLV: begin
            r = b << a[4:0];
            carry = 1'b0;
            overflow = 1'b0;
        end

        SRLV: begin
            r = b >> a[4:0];
            carry = 1'b0;
            overflow = 1'b0;
        end

        SRAV: begin
            r = $signed(b_s) >>> a[4:0];
            carry = 1'b0;
            overflow = 1'b0;
        end

        LUI: begin
            // Typical MIPS LUI puts immediate (usually from b) into upper 16 bits and zeros lower 16 bits
            r = {b[15:0], 16'b0};
            carry = 1'b0;
            overflow = 1'b0;
        end

        default: begin
            r = 32'bz; // undefined: high impedance
            carry = 1'b0;
            overflow = 1'b0;
        end
    endcase

    negative = r[31];
end

assign zero = (r == 32'b0);

// flag output: only driven for SLT and SLTU, else high impedance
assign flag = (aluc == SLT)  ? slt_flag_reg :
              (aluc == SLTU) ? sltu_flag_reg :
                              1'bz;

endmodule