module alu(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output [31:0] r,
    output reg zero,
    output reg carry,
    output reg negative,
    output reg overflow,
    output reg flag
);

// Define parameters for operations
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

always @(*) begin
    case (aluc)
        ADD: result = a + b;
        ADDU: result = a + b;
        SUB: result = a - b;
        SUBU: result = a - b;
        AND: result = a & b;
        OR: result = a | b;
        XOR: result = a ^ b;
        NOR: result = ~(a | b);
        SLT: result = (a < b)? 32'h1 : 32'h0;
        SLTU: result = (a < b)? 32'h1 : 32'h0;
        SLL: result = a << b[4:0];
        SRL: result = a >> b[4:0];
        SRA: result = a >>> b[4:0];
        SLLV: result = a << a[4:0];
        SRLV: result = a >> a[4:0];
        SRAV: result = a >>> a[4:0];
        LUI: result = {a[15:0], 16'h0};
        default: result = 32'bz;
    endcase
end

always @(*) begin
    case (aluc)
        ADD, SUB: begin
            {carry, result} = a + b;
            overflow = (a[31] == b[31] && result[31]!= a[31]);
        end
        SLL, SRL, SRA: begin
            carry = 1'b0;
            overflow = 1'b0;
        end
        default: begin
            carry = 1'b0;
            overflow = 1'b0;
        end
    endcase
end

always @(*) begin
    case (aluc)
        SLT, SLTU: flag = (result == 32'h1);
        default: flag = 1'b0;
    endcase
end

assign r = result;
assign zero = (result == 32'h0);
assign negative = result[31];

endmodule