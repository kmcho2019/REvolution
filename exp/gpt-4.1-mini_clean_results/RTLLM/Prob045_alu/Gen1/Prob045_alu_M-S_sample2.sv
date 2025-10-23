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

// Signed versions for comparisons and arithmetic
wire signed [31:0] a_signed = a;
wire signed [31:0] b_signed = b;

reg [32:0] tmp_arith; // for add/sub with carry

always @(*) begin
    carry = 1'b0;
    overflow = 1'b0;
    flag = 1'b0;  // default flag to 0 to avoid 'z'

    case (aluc)
        ADD: begin
            tmp_arith = {1'b0,a} + {1'b0,b};
            r = tmp_arith[31:0];
            carry = tmp_arith[32];
            overflow = ((a[31] == b[31]) && (r[31] != a[31]));
        end
        ADDU: begin
            tmp_arith = {1'b0,a} + {1'b0,b};
            r = tmp_arith[31:0];
            carry = tmp_arith[32];
            overflow = 1'b0;
        end
        SUB: begin
            tmp_arith = {1'b0,a} - {1'b0,b};
            r = tmp_arith[31:0];
            carry = (a >= b); // no borrow
            overflow = ((a[31] != b[31]) && (r[31] != a[31]));
        end
        SUBU: begin
            tmp_arith = {1'b0,a} - {1'b0,b};
            r = tmp_arith[31:0];
            carry = (a >= b);
            overflow = 1'b0;
        end
        AND: r = a & b;
        OR:  r = a | b;
        XOR: r = a ^ b;
        NOR: r = ~(a | b);
        SLT: begin
            flag = (a_signed < b_signed) ? 1'b1 : 1'b0;
            r = {31'b0, flag};
        end
        SLTU: begin
            flag = (a < b) ? 1'b1 : 1'b0;
            r = {31'b0, flag};
        end
        SLL:  r = b << a[4:0];
        SRL:  r = b >> a[4:0];
        SRA:  r = $signed(b) >>> a[4:0];
        SLLV: r = b << a[4:0];
        SRLV: r = b >> a[4:0];
        SRAV: r = $signed(b) >>> a[4:0];
        LUI:  r = {b[15:0],16'b0};
        default: r = 32'b0;
    endcase
end

assign zero = (r == 32'b0);
assign negative = r[31];

endmodule