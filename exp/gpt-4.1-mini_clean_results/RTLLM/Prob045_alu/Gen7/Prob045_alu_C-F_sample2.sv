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

// Signed versions of inputs for arithmetic and comparisons
wire signed [31:0] a_s = $signed(a);
wire signed [31:0] b_s = $signed(b);

// Shift amounts for immediate and variable shifts
wire [4:0] shamt = a[4:0];

// Internal signals for arithmetic extended addition/subtraction
reg [32:0] arith_full;
reg [31:0] arith_res;
reg       arith_overflow;
reg       arith_carry;

// Compute SLT and SLTU flags and results
wire slt_flag  = (a_s < b_s);
wire sltu_flag = (a < b);
wire [31:0] slt_res  = slt_flag  ? 32'b1 : 32'b0;
wire [31:0] sltu_res = sltu_flag ? 32'b1 : 32'b0;

always @(*) begin
    // Default outputs
    r        = 32'b0;
    carry    = 1'b0;
    overflow = 1'b0;
    negative = 1'b0;
    flag     = 1'b0;

    // Arithmetic operations compute with 33-bit operands for carry detection
    case (aluc)
        ADD: begin
            arith_full = {1'b0, a} + {1'b0, b};
            arith_res = arith_full[31:0];
            carry = arith_full[32];
            // Overflow: if sign of operands equal and sign of result differs
            overflow = (~a[31] & ~b[31] &  arith_res[31]) |
                       ( a[31] &  b[31] & ~arith_res[31]);
            r = arith_res;
        end
        ADDU: begin
            arith_full = {1'b0, a} + {1'b0, b};
            arith_res = arith_full[31:0];
            carry = arith_full[32];
            overflow = 1'b0;
            r = arith_res;
        end
        SUB: begin
            arith_full = {1'b0, a} - {1'b0, b};
            arith_res = arith_full[31:0];
            // For carry in subtraction, borrow = ~carry; here carry means borrow flag
            carry = arith_full[32];
            // Overflow: if signs differ and sign of result differs from a
            overflow = ( a[31] & ~b[31] & ~arith_res[31]) |
                       (~a[31] &  b[31] &  arith_res[31]);
            r = arith_res;
        end
        SUBU: begin
            arith_full = {1'b0, a} - {1'b0, b};
            arith_res = arith_full[31:0];
            carry = arith_full[32];
            overflow = 1'b0;
            r = arith_res;
        end
        AND: begin
            r = a & b;
        end
        OR: begin
            r = a | b;
        end
        XOR: begin
            r = a ^ b;
        end
        NOR: begin
            r = ~(a | b);
        end
        SLT: begin
            r = slt_res;
            flag = 1'b1;
        end
        SLTU: begin
            r = sltu_res;
            flag = 1'b1;
        end
        SLL: begin
            r = b << shamt;
        end
        SRL: begin
            r = b >> shamt;
        end
        SRA: begin
            r = $signed(b_s) >>> shamt;
        end
        SLLV: begin
            r = b << a[4:0];
        end
        SRLV: begin
            r = b >> a[4:0];
        end
        SRAV: begin
            r = $signed(b_s) >>> a[4:0];
        end
        LUI: begin
            // According to spec: lower 16 bits of a concatenated with 16 zeros
            r = {a[15:0], 16'b0};
        end
        default: begin
            // All outputs are zero or cleared by default at start of block
            // Carry, overflow, flag, negative already zero
            // r is zero
        end
    endcase

    // Negative flag is MSB of result
    negative = r[31];
end

// zero flag is high if r is zero
assign zero = (r == 32'b0);

endmodule