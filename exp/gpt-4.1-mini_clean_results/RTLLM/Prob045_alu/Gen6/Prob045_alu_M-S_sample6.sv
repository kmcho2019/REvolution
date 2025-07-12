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

wire [4:0] shamt = a[4:0];
wire signed [31:0] a_s = $signed(a);
wire signed [31:0] b_s = $signed(b);

always @(*) begin
    r = 32'b0;
    carry = 1'b0;
    overflow = 1'b0;
    negative = 1'b0;
    flag = 1'b0;

    case (aluc)
        ADD: begin
            {carry, r} = a + b;
            // Overflow detection for signed addition
            overflow = (~(a[31] ^ b[31])) & (a[31] ^ r[31]);
            negative = r[31];
        end
        ADDU: begin
            {carry, r} = a + b;
            overflow = 1'b0;
            negative = r[31];
        end
        SUB: begin
            {carry, r} = a - b;
            // carry here indicates no borrow (carry=1 if no borrow)
            // Overflow detection for signed subtraction
            overflow = ((a[31] ^ b[31]) & (a[31] ^ r[31]));
            negative = r[31];
        end
        SUBU: begin
            {carry, r} = a - b;
            overflow = 1'b0;
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
            // signed comparison
            flag = (a_s < b_s) ? 1'b1 : 1'b0;
            r = 32'b0;
            r[0] = flag;
            negative = 1'b0;
        end
        SLTU: begin
            // unsigned comparison
            flag = (a < b) ? 1'b1 : 1'b0;
            r = 32'b0;
            r[0] = flag;
            negative = 1'b0;
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
            r = b << a[4:0];
            negative = r[31];
        end
        SRLV: begin
            r = b >> a[4:0];
            negative = r[31];
        end
        SRAV: begin
            r = $signed(b) >>> a[4:0];
            negative = r[31];
        end
        LUI: begin
            // load upper immediate: set upper 16 bits to b[15:0], lower 16 bits zero
            r = {b[15:0], 16'b0};
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
end

assign zero = (r == 32'b0);

endmodule