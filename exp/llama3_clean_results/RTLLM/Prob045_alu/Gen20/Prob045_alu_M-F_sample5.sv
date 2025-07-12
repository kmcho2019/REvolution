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

// Define operation codes
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

reg [32:0] result;
reg [31:0] temp;

always @(*) begin
    case (aluc)
        ADD: begin
            {carry, result[31:0]} = a + b;
            overflow = (a[31] == b[31] && a[31]!= result[31]);
            flag = 1'b0;
        end
        ADDU: begin
            {carry, result[31:0]} = a + b;
            overflow = 1'b0;
            flag = 1'b0;
        end
        SUB: begin
            {carry, result[31:0]} = a - b;
            overflow = (a[31]!= b[31] && a[31]!= result[31]);
            flag = 1'b0;
        end
        SUBU: begin
            {carry, result[31:0]} = a - b;
            overflow = 1'b0;
            flag = 1'b0;
        end
        AND: begin
            result[31:0] = a & b;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
        OR: begin
            result[31:0] = a | b;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
        XOR: begin
            result[31:0] = a ^ b;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
        NOR: begin
            result[31:0] = ~(a | b);
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
        SLL: begin
            result[31:0] = a << b[4:0];
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
        SRL: begin
            result[31:0] = a >> b[4:0];
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
        SRA: begin
            result[31:0] = a >>> b[4:0];
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
        SLLV: begin
            result[31:0] = a << a[4:0];
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
        SRLV: begin
            result[31:0] = a >> a[4:0];
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
        SRAV: begin
            result[31:0] = a >>> a[4:0];
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
        LUI: begin
            result[31:0] = {16'b0, a[15:0]};
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
        SLT: begin
            temp = ($signed(a) < $signed(b))? 32'd1 : 32'd0;
            result[31:0] = temp;
            flag = $signed(a) < $signed(b);
            carry = 1'b0;
            overflow = 1'b0;
        end
        SLTU: begin
            temp = (a < b)? 32'd1 : 32'd0;
            result[31:0] = temp;
            flag = a < b;
            carry = 1'b0;
            overflow = 1'b0;
        end
        default: begin
            result[31:0] = 32'bx;
            carry = 1'bx;
            overflow = 1'bx;
            flag = 1'bx;
        end
    endcase

    r = result[31:0];
    zero = (result[31:0] == 32'd0);
    negative = result[31];
end

endmodule