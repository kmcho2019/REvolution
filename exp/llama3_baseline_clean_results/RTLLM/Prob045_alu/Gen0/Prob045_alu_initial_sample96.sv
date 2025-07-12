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

// Define parameters for different operations
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
reg zero_reg;
reg carry_reg;
reg negative_reg;
reg overflow_reg;
reg flag_reg;

assign r = res;
assign zero = zero_reg;
assign carry = carry_reg;
assign negative = negative_reg;
assign overflow = overflow_reg;
assign flag = flag_reg;

always @(*)
begin
    // Reset flags
    zero_reg = 0;
    carry_reg = 0;
    negative_reg = 0;
    overflow_reg = 0;
    flag_reg = 0;

    case(aluc)
        ADD: 
        begin
            res = a + b;
            if (res == 0) zero_reg = 1;
            if (res[31] == 1) negative_reg = 1;
            if ((a[31] == 1 && b[31] == 1 && res[31] == 0) || (a[31] == 0 && b[31] == 0 && res[31] == 1)) overflow_reg = 1;
        end
        ADDU: 
        begin
            res = a + b;
            if (res == 0) zero_reg = 1;
            if (res[31] == 1) negative_reg = 1;
        end
        SUB: 
        begin
            res = a - b;
            if (res == 0) zero_reg = 1;
            if (res[31] == 1) negative_reg = 1;
            if ((a[31] == 1 && b[31] == 0 && res[31] == 1) || (a[31] == 0 && b[31] == 1 && res[31] == 0)) overflow_reg = 1;
        end
        SUBU: 
        begin
            res = a - b;
            if (res == 0) zero_reg = 1;
            if (res[31] == 1) negative_reg = 1;
        end
        AND: 
        begin
            res = a & b;
            if (res == 0) zero_reg = 1;
        end
        OR: 
        begin
            res = a | b;
            if (res == 0) zero_reg = 1;
        end
        XOR: 
        begin
            res = a ^ b;
            if (res == 0) zero_reg = 1;
        end
        NOR: 
        begin
            res = ~(a | b);
            if (res == 0) zero_reg = 1;
        end
        SLT: 
        begin
            if ($signed(a) < $signed(b)) res = 1; else res = 0;
            if (res == 0) zero_reg = 1;
            flag_reg = res;
        end
        SLTU: 
        begin
            if (a < b) res = 1; else res = 0;
            if (res == 0) zero_reg = 1;
            flag_reg = res;
        end
        SLL: 
        begin
            res = a << b[4:0];
            if (res == 0) zero_reg = 1;
        end
        SRL: 
        begin
            res = a >> b[4:0];
            if (res == 0) zero_reg = 1;
        end
        SRA: 
        begin
            res = $signed(a) >>> b[4:0];
            if (res == 0) zero_reg = 1;
        end
        SLLV: 
        begin
            res = a << b[4:0];
            if (res == 0) zero_reg = 1;
        end
        SRLV: 
        begin
            res = a >> b[4:0];
            if (res == 0) zero_reg = 1;
        end
        SRAV: 
        begin
            res = $signed(a) >>> b[4:0];
            if (res == 0) zero_reg = 1;
        end
        LUI: 
        begin
            res = {a[15:0], 16'd0};
            if (res == 0) zero_reg = 1;
        end
        default: res = {32{1'bz}};
    endcase
end

endmodule