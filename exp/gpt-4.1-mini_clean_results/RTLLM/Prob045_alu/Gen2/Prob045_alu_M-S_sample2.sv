module alu(
    input  [31:0] a,
    input  [31:0] b,
    input  [5:0]  aluc,
    output reg [31:0] r,
    output zero,
    output reg carry,
    output reg negative,
    output reg overflow,
    output reg flag
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

// Internal signed versions
wire signed [31:0] a_s = a;
wire signed [31:0] b_s = b;
wire [4:0] shamt = a[4:0];

always @(*) begin
    carry = 0;
    overflow = 0;
    flag = 0;
    negative = 0;
    case (aluc)
        ADD: begin
            // Signed addition
            {carry, r} = {1'b0, a} + {1'b0, b};
            // Overflow detection for signed add
            overflow = (~a[31] & ~b[31] & r[31]) | (a[31] & b[31] & ~r[31]);
            negative = r[31];
        end
        ADDU: begin
            {carry, r} = {1'b0, a} + {1'b0, b};
            negative = r[31];
        end
        SUB: begin
            {carry, r} = {1'b0, a} - {1'b0, b};
            // Overflow detection for signed sub
            overflow = (a[31] & ~b[31] & ~r[31]) | (~a[31] & b[31] & r[31]);
            negative = r[31];
        end
        SUBU: begin
            {carry, r} = {1'b0, a} - {1'b0, b};
            negative = r[31];
        end
        AND: begin
            r = a & b;
            negative = r[31];
        end
        OR: begin
            r = a | b;
            negative = r[31];
        end
        XOR: begin
            r = a ^ b;
            negative = r[31];
        end
        NOR: begin
            r = ~(a | b);
            negative = r[31];
        end
        SLT: begin
            // Signed comparison
            r = (a_s < b_s) ? 32'd1 : 32'd0;
            flag = r[0];
            negative = r[31];
        end
        SLTU: begin
            // Unsigned comparison
            r = (a < b) ? 32'd1 : 32'd0;
            flag = r[0];
            negative = r[31];
        end
        SLL: begin
            r = b << shamt;
            negative = r[31];
        end
        SRL: begin
            r = b >> shamt;
            negative = r[31];
        end
        SRA: begin
            r = $signed(b) >>> shamt;
            negative = r[31];
        end
        SLLV: begin
            r = b << (a[4:0]);
            negative = r[31];
        end
        SRLV: begin
            r = b >> (a[4:0]);
            negative = r[31];
        end
        SRAV: begin
            r = $signed(b) >>> (a[4:0]);
            negative = r[31];
        end
        LUI: begin
            r = {b[15:0], 16'b0};  // As in MIPS LUI uses b's lower 16 bits shifted
            negative = r[31];
        end
        default: begin
            r = 32'b0;
            carry = 0;
            overflow = 0;
            negative = 0;
            flag = 0;
        end
    endcase
end

assign zero = (r == 32'b0);

endmodule