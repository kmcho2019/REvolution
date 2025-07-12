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

always @(*) begin
    r = 32'b0;
    zero = 1'b0;
    carry = 1'b0;
    negative = 1'b0;
    overflow = 1'b0;
    flag = 1'b0;

    case (aluc)
        ADD: begin
            {carry, r} = a + b;
            // Overflow: if signs of a and b same, but result sign differs
            overflow = (~a[31] & ~b[31] & r[31]) | (a[31] & b[31] & ~r[31]);
            negative = r[31];
        end
        ADDU: begin
            {carry, r} = a + b;
            overflow = 1'b0;
            negative = r[31];
        end
        SUB: begin
            {carry, r} = a - b;
            // For carry in subtraction, 'carry' = ~borrow; borrow = 1 if a < b unsigned
            carry = (a >= b) ? 1'b1 : 1'b0;
            overflow = (a[31] & ~b[31] & ~r[31]) | (~a[31] & b[31] & r[31]);
            negative = r[31];
        end
        SUBU: begin
            {carry, r} = a - b;
            carry = (a >= b) ? 1'b1 : 1'b0;
            overflow = 1'b0;
            negative = r[31];
        end
        AND: begin
            r = a & b;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
        end
        OR: begin
            r = a | b;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
        end
        XOR: begin
            r = a ^ b;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
        end
        NOR: begin
            r = ~(a | b);
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
        end
        SLT: begin
            flag = (a_s < b_s) ? 1'b1 : 1'b0;
            r = {31'b0, flag};
            carry = 1'b0;
            overflow = 1'b0;
            negative = 1'b0;
        end
        SLTU: begin
            flag = (a < b) ? 1'b1 : 1'b0;
            r = {31'b0, flag};
            carry = 1'b0;
            overflow = 1'b0;
            negative = 1'b0;
        end
        SLL: begin
            r = b << shamt;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
        end
        SRL: begin
            r = b >> shamt;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
        end
        SRA: begin
            r = $signed(b_s) >>> shamt;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
        end
        SLLV: begin
            r = b << a[4:0];
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
        end
        SRLV: begin
            r = b >> a[4:0];
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
        end
        SRAV: begin
            r = $signed(b_s) >>> a[4:0];
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
        end
        LUI: begin
            r = b << 16;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
        end
        default: begin
            r = 32'b0;
            carry = 1'b0;
            overflow = 1'b0;
            negative = 1'b0;
            flag = 1'b0;
        end
    endcase

    zero = (r == 32'b0);
end

endmodule