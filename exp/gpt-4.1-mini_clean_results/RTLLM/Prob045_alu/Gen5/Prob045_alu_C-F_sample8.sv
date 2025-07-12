module alu(
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [5:0]  aluc,
    output reg  [31:0] r,
    output wire        zero,
    output reg         carry,
    output reg         negative,
    output reg         overflow,
    output reg         flag
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

// Signed versions for signed arithmetic and comparisons
wire signed [31:0] a_s = $signed(a);
wire signed [31:0] b_s = $signed(b);

// Shift amounts
wire [4:0] shamt_imm = a[4:0];
wire [4:0] shamt_var = a[4:0];

// Extended operands for carry detection
reg [32:0] arith_ext; // 33 bits to detect carry out

always @(*) begin
    // Default output values
    r = 32'b0;
    carry = 1'b0;
    overflow = 1'b0;
    negative = 1'b0;
    flag = 1'bz; // High impedance by default

    case (aluc)
        ADD: begin
            arith_ext = {1'b0, a} + {1'b0, b};
            r = arith_ext[31:0];
            carry = arith_ext[32];
            // Overflow: if sign of a and b same, and sign of result differs
            overflow = (~a[31] & ~b[31] & r[31]) | (a[31] & b[31] & ~r[31]);
            flag = 1'bz;
        end
        ADDU: begin
            arith_ext = {1'b0, a} + {1'b0, b};
            r = arith_ext[31:0];
            carry = arith_ext[32];
            overflow = 1'b0;
            flag = 1'bz;
        end
        SUB: begin
            arith_ext = {1'b0, a} - {1'b0, b};
            r = arith_ext[31:0];
            carry = arith_ext[32];
            // Overflow: if signs of a and b differ and sign of result differs from a
            overflow = (a[31] & ~b[31] & ~r[31]) | (~a[31] & b[31] & r[31]);
            flag = 1'bz;
        end
        SUBU: begin
            arith_ext = {1'b0, a} - {1'b0, b};
            r = arith_ext[31:0];
            carry = arith_ext[32];
            overflow = 1'b0;
            flag = 1'bz;
        end
        AND: begin
            r = a & b;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'bz;
        end
        OR: begin
            r = a | b;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'bz;
        end
        XOR: begin
            r = a ^ b;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'bz;
        end
        NOR: begin
            r = ~(a | b);
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'bz;
        end
        SLT: begin
            r = (a_s < b_s) ? 32'b1 : 32'b0;
            carry = 1'b0;
            overflow = 1'b0;
            flag = (a_s < b_s) ? 1'b1 : 1'b0;
        end
        SLTU: begin
            r = (a < b) ? 32'b1 : 32'b0;
            carry = 1'b0;
            overflow = 1'b0;
            flag = (a < b) ? 1'b1 : 1'b0;
        end
        SLL: begin
            r = b << shamt_imm;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'bz;
        end
        SRL: begin
            r = b >> shamt_imm;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'bz;
        end
        SRA: begin
            r = $signed(b_s) >>> shamt_imm;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'bz;
        end
        SLLV: begin
            r = b << shamt_var;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'bz;
        end
        SRLV: begin
            r = b >> shamt_var;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'bz;
        end
        SRAV: begin
            r = $signed(b_s) >>> shamt_var;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'bz;
        end
        LUI: begin
            // According to problem statement: upper 16 bits of a concatenated with 16 zeros
            r = {a[31:16], 16'b0};
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'bz;
        end
        default: begin
            r = 32'bz;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'bz;
        end
    endcase

    negative = r[31];
end

assign zero = (r == 32'b0);

endmodule