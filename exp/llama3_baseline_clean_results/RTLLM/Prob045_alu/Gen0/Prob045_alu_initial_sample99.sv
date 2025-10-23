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

reg [31:0] res;

always @(*) begin
    case (aluc)
        ADD: begin
            {carry, res} = a + b;
            overflow = (a[31] == b[31] && res[31]!= a[31]);
        end
        ADDU: begin
            {carry, res} = a + b;
            overflow = 1'b0;
        end
        SUB: begin
            {carry, res} = a - b;
            overflow = (a[31]!= b[31] && res[31]!= a[31]);
        end
        SUBU: begin
            {carry, res} = a - b;
            overflow = 1'b0;
        end
        AND: res = a & b;
        OR: res = a | b;
        XOR: res = a ^ b;
        NOR: res = ~(a | b);
        SLT: res = (signed'(a) < signed'(b))? 32'b1 : 32'b0;
        SLTU: res = (a < b)? 32'b1 : 32'b0;
        SLL: res = a << b[4:0];
        SRL: res = a >> b[4:0];
        SRA: res = a >>> b[4:0];
        SLLV: res = a << b;
        SRLV: res = a >> b;
        SRAV: res = a >>> b;
        LUI: res = {a[15:0], 16'b0};
        default: res = 32'bz;
    endcase
    
    r = res;
    zero = (res == 32'b0);
    negative = res[31];
    flag = (aluc == SLT || aluc == SLTU);
end

endmodule