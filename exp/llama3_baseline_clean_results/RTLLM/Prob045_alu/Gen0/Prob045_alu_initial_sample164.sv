module alu(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output [31:0] r,
    output zero,
    output carry,
    output negative,
    output overflow,
    output flag
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
reg [31:0] temp_a;
reg [31:0] temp_b;

always @(*) begin
    temp_a = a;
    temp_b = b;
    
    case(aluc)
        ADD: res = temp_a + temp_b;
        ADDU: res = temp_a + temp_b;
        SUB: res = temp_a - temp_b;
        SUBU: res = temp_a - temp_b;
        AND: res = temp_a & temp_b;
        OR: res = temp_a | temp_b;
        XOR: res = temp_a ^ temp_b;
        NOR: res = ~(temp_a | temp_b);
        SLT: res = (temp_a[31] == 1 && temp_b[31] == 0) || (temp_a[31] == temp_b[31] && (temp_a < temp_b));
        SLTU: res = temp_a < temp_b;
        SLL: res = temp_b << a[4:0];
        SRL: res = temp_b >> a[4:0];
        SRA: res = temp_b >>> a[4:0];
        SLLV: res = temp_b << temp_a[4:0];
        SRLV: res = temp_b >> temp_a[4:0];
        SRAV: res = temp_b >>> temp_a[4:0];
        LUI: res = {a[15:0], 16'd0};
        default: res = 32'bz;
    endcase
end

assign r = res;
assign zero = (res == 0);
assign carry = (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU) && (res[31]!= res[30]);
assign negative = res[31];
assign overflow = (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU) && (res[31]!= res[30]);
assign flag = (aluc == SLT || aluc == SLTU) && res;

endmodule