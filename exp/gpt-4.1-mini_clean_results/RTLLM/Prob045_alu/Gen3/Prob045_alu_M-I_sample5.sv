module alu(
    input  [31:0] a,
    input  [31:0] b,
    input  [5:0]  aluc,
    output reg [31:0] r,
    output zero,
    output reg carry,
    output negative,
    output reg overflow,
    output reg flag
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

// Internal signed operands for arithmetic
wire signed [31:0] a_s = a;
wire signed [31:0] b_s = b;

// Internal 33-bit registers for carry and overflow calculation
reg signed [32:0] add_res;
reg signed [32:0] sub_res;

// Temporary registers for result, carry, overflow, and flag
reg [31:0] res;
reg c;
reg ovf;
reg f;

always @(*) begin
    // Defaults
    res = 32'b0;
    c = 1'b0;
    ovf = 1'b0;
    f = 1'b0;

    case (aluc)
        ADD: begin
            // Signed addition with extended bit for carry out
            add_res = {a_s[31], a_s} + {b_s[31], b_s};
            res = add_res[31:0];
            c = add_res[32]; // carry out from 33rd bit
            // Overflow when sign of operands equal but differ from result sign
            ovf = (~(a_s[31] ^ b_s[31])) & (a_s[31] ^ res[31]);
        end
        ADDU: begin
            // Unsigned addition with carry
            add_res = {1'b0, a} + {1'b0, b};
            res = add_res[31:0];
            c = add_res[32];
            ovf = 1'b0;
        end
        SUB: begin
            // Signed subtraction
            sub_res = {a_s[31], a_s} - {b_s[31], b_s};
            res = sub_res[31:0];
            // For carry in subtraction, MIPS defines carry = 1 if no borrow (a >= b unsigned)
            c = (a >= b);
            // Overflow when sign of operands differ and sign of result differs from a
            ovf = (a_s[31] ^ b_s[31]) & (a_s[31] ^ res[31]);
        end
        SUBU: begin
            // Unsigned subtraction
            sub_res = {1'b0, a} - {1'b0, b};
            res = sub_res[31:0];
            c = (a >= b);
            ovf = 1'b0;
        end
        AND:  res = a & b;
        OR:   res = a | b;
        XOR:  res = a ^ b;
        NOR:  res = ~(a | b);
        SLT: begin
            f = (a_s < b_s) ? 1'b1 : 1'b0;
            res = 32'b0;
            res[0] = f;
        end
        SLTU: begin
            f = (a < b) ? 1'b1 : 1'b0;
            res = 32'b0;
            res[0] = f;
        end
        SLL:  res = b << a[4:0];
        SRL:  res = b >> a[4:0];
        SRA:  res = $signed(b) >>> a[4:0];
        SLLV: res = b << a[4:0];
        SRLV: res = b >> a[4:0];
        SRAV: res = $signed(b) >>> a[4:0];
        LUI:  res = {b[15:0], 16'b0};
        default: begin
            res = 32'b0;
            c = 1'b0;
            ovf = 1'b0;
            f = 1'b0;
        end
    endcase
end

// Output assignments directly from internal regs
always @(*) begin
    r = res;
    carry = c;
    overflow = ovf;
    flag = f;
end

assign zero = (r == 32'b0);
assign negative = r[31];

endmodule