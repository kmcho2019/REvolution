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

reg [31:0] result;
reg [31:0] unsigned_a;
reg [31:0] unsigned_b;
reg [31:0] unsigned_result;

always @(*) begin
    unsigned_a = a;
    unsigned_b = b;
end

always @(*) begin
    case (aluc)
        ADD: result = a + b;
        ADDU: result = unsigned_a + unsigned_b;
        SUB: result = a - b;
        SUBU: result = unsigned_a - unsigned_b;
        AND: result = a & b;
        OR: result = a | b;
        XOR: result = a ^ b;
        NOR: result = ~(a | b);
        SLT: result = (signed'(a) < signed'(b))? 32'h1 : 32'h0;
        SLTU: result = (unsigned_a < unsigned_b)? 32'h1 : 32'h0;
        SLL: result = a << b[4:0];
        SRL: result = a >> b[4:0];
        SRA: result = a >>> b[4:0];
        SLLV: result = a << b[4:0];
        SRLV: result = a >> b[4:0];
        SRAV: result = a >>> b[4:0];
        LUI: result = { a[15:0], 16'h0 };
        default: result = 32'bx;
    endcase
end

always @(*) begin
    if (aluc == ADD || aluc == ADDU) begin
        if (result[31]!= a[31] && result[31]!= b[31]) begin
            overflow = 1'b1;
        end else begin
            overflow = 1'b0;
        end
    end else if (aluc == SUB || aluc == SUBU) begin
        if (result[31]!= a[31] && result[31]!= ~b[31]) begin
            overflow = 1'b1;
        end else begin
            overflow = 1'b0;
        end
    end else begin
        overflow = 1'b0;
    end
end

always @(*) begin
    if (aluc == ADD || aluc == ADDU) begin
        if (result > a && result > b) begin
            carry = 1'b1;
        end else begin
            carry = 1'b0;
        end
    end else if (aluc == SUB || aluc == SUBU) begin
        if (result < a && result < b) begin
            carry = 1'b1;
        end else begin
            carry = 1'b0;
        end
    end else begin
        carry = 1'b0;
    end
end

assign r = result;
assign zero = (result == 32'h0);
assign negative = result[31];
assign flag = (aluc == SLT || aluc == SLTU)? (result[0] == 1'b1) : 1'bz;

endmodule