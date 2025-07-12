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

// Simplified operation decoding using case statement within an always block
reg [31:0] r_reg;
reg zero_reg;
reg carry_reg;
reg negative_reg;
reg overflow_reg;
reg flag_reg;

always @(*) begin
    case (aluc)
        ADD: begin
            r_reg = a + b;
            carry_reg = (a[31] == 1'b0 && b[31] == 1'b0 && r_reg[31] == 1'b1) || (a[31] == 1'b1 && b[31] == 1'b1 && r_reg[31] == 1'b0);
            overflow_reg = (a[31] == b[31] && b[31] != r_reg[31]);
        end
        ADDU: begin
            r_reg = a + b;
            carry_reg = (a[31] == 1'b0 && b[31] == 1'b0 && r_reg[31] == 1'b1) || (a[31] == 1'b1 && b[31] == 1'b1 && r_reg[31] == 1'b0);
            overflow_reg = 1'b0; // No overflow for unsigned addition
        end
        SUB: begin
            r_reg = a - b;
            carry_reg = (a[31] == 1'b1 && b[31] == 1'b0 && r_reg[31] == 1'b0) || (a[31] == 1'b0 && b[31] == 1'b1 && r_reg[31] == 1'b1);
            overflow_reg = (a[31] != b[31] && r_reg[31] != a[31]);
        end
        SUBU: begin
            r_reg = a - b;
            carry_reg = (a[31] == 1'b1 && b[31] == 1'b0 && r_reg[31] == 1'b0) || (a[31] == 1'b0 && b[31] == 1'b1 && r_reg[31] == 1'b1);
            overflow_reg = 1'b0; // No overflow for unsigned subtraction
        end
        AND: begin
            r_reg = a & b;
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
        end
        OR: begin
            r_reg = a | b;
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
        end
        XOR: begin
            r_reg = a ^ b;
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
        end
        NOR: begin
            r_reg = ~(a | b);
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
        end
        SLT: begin
            r_reg = (signed'(a) < signed'(b))? 32'h1 : 32'h0;
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
            flag_reg = r_reg[0];
        end
        SLTU: begin
            r_reg = (a < b)? 32'h1 : 32'h0;
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
            flag_reg = r_reg[0];
        end
        SLL: begin
            r_reg = a << b[4:0];
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
        end
        SRL: begin
            r_reg = a >> b[4:0];
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
        end
        SRA: begin
            r_reg = a >>> b[4:0];
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
        end
        SLLV: begin
            r_reg = a << a[4:0];
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
        end
        SRLV: begin
            r_reg = a >> a[4:0];
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
        end
        SRAV: begin
            r_reg = a >>> a[4:0];
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
        end
        LUI: begin
            r_reg = {16'd0, b[15:0]};
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
        end
        default: begin
            r_reg = 32'bz;
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
        end
    endcase
    
    zero_reg = (r_reg == 32'h0);
    negative_reg = r_reg[31];
end

assign r = r_reg;
assign zero = zero_reg;
assign carry = carry_reg;
assign negative = negative_reg;
assign overflow = overflow_reg;
assign flag = flag_reg;

endmodule