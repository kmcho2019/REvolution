module alu(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output reg [31:0] r,
    output reg zero,
    output reg carry,
    output reg negative,
    output reg overflow,
    output reg flag
);

// Operation categories
parameter ADD = 6'b100000;
parameter ADDU = 6'b100001;
parameter SUB = 6'b100010;
parameter SUBU = 6'b100011;
parameter AND = 6'b100100;
parameter OR = 6'b100101;
parameter XOR = 6'b100110;
parameter NOR = 6'b100111;
parameter SLT = 6'b101010;
parameter SLTU = 6'b101011;
parameter SLL = 6'b000000;
parameter SRL = 6'b000010;
parameter SRA = 6'b000011;
parameter SLLV = 6'b000100;
parameter SRLV = 6'b000110;
parameter SRAV = 6'b000111;
parameter LUI = 6'b001111;

// Internal signals
reg [31:0] result;
reg [31:0] result_unsigned;
reg [31:0] result_signed;

// Core operations
always @(*) begin
    case (aluc)
        ADD: begin
            result = a + b;
            overflow = (a[31] == b[31] && a[31] != result[31]);
        end
        ADDU: begin
            result = a + b;
            overflow = 1'b0;
        end
        SUB: begin
            result = a - b;
            overflow = (a[31] != b[31] && a[31] != result[31]);
        end
        SUBU: begin
            result = a - b;
            overflow = 1'b0;
        end
        AND: result = a & b;
        OR: result = a | b;
        XOR: result = a ^ b;
        NOR: result = ~(a | b);
        SLT: begin
            result_signed = (signed'(a) < signed'(b)) ? 32'd1 : 32'd0;
            result = result_signed;
            flag = (signed'(a) < signed'(b));
        end
        SLTU: begin
            result_unsigned = (a < b) ? 32'd1 : 32'd0;
            result = result_unsigned;
            flag = (a < b);
        end
        SLL: result = a << b[4:0];
        SRL: result = a >> b[4:0];
        SRA: result = a >>> b[4:0];
        SLLV: result = a << a[4:0];
        SRLV: result = a >> a[4:0];
        SRAV: result = a >>> a[4:0];
        LUI: result = {b[15:0], 16'd0};
        default: result = 32'bx;
    endcase
end

// Output assignments
always @(*) begin
    r = result;
    zero = (result == 32'd0);
    carry = (result[31] == 1'b1);
    negative = (result[31] == 1'b1);
    flag = (aluc == SLT || aluc == SLTU) ? (result[0] == 1'b1) : 1'b0;
end

endmodule