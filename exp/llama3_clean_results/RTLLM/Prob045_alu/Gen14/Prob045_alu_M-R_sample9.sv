// Arithmetic Operations Module
module arithmetic_operations(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output reg [31:0] r,
    output reg carry,
    output reg overflow
);

parameter ADD = 6'b100000;
parameter ADDU = 6'b100001;
parameter SUB = 6'b100010;
parameter SUBU = 6'b100011;

always @(a, b, aluc) begin
    case (aluc)
        ADD: begin
            r = a + b;
            carry = ((a[31]!= b[31]) && (a[31]!= r[31])) ? 1'b1 : 1'b0;
            overflow = ((a[31]!= b[31]) && (a[31]!= r[31])) ? 1'b1 : 1'b0;
        end
        ADDU: begin
            r = a + b;
            carry = (r[31] == 1'b1) ? 1'b1 : 1'b0;
            overflow = 1'b0;
        end
        SUB: begin
            r = a - b;
            carry = ((a[31]== b[31]) && (a[31]!= r[31])) ? 1'b1 : 1'b0;
            overflow = ((a[31]== b[31]) && (a[31]!= r[31])) ? 1'b1 : 1'b0;
        end
        SUBU: begin
            r = a - b;
            carry = (r[31] == 1'b1) ? 1'b1 : 1'b0;
            overflow = 1'b0;
        end
        default: begin
            r = 32'bx;
            carry = 1'b0;
            overflow = 1'b0;
        end
    endcase
end

endmodule

// Logical Operations Module
module logical_operations(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output reg [31:0] r
);

parameter AND = 6'b100100;
parameter OR = 6'b100101;
parameter XOR = 6'b100110;
parameter NOR = 6'b100111;

always @(a, b, aluc) begin
    case (aluc)
        AND: r = a & b;
        OR: r = a | b;
        XOR: r = a ^ b;
        NOR: r = ~(a | b);
        default: r = 32'bx;
    endcase
end

endmodule

// Shift Operations Module
module shift_operations(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output reg [31:0] r
);

parameter SLL = 6'b000000;
parameter SRL = 6'b000010;
parameter SRA = 6'b000011;
parameter SLLV = 6'b000100;
parameter SRLV = 6'b000110;
parameter SRAV = 6'b000111;

always @(a, b, aluc) begin
    case (aluc)
        SLL: r = a << b[4:0];
        SRL: r = a >> b[4:0];
        SRA: r = a >>> b[4:0];
        SLLV: r = a << b[4:0];
        SRLV: r = a >> b[4:0];
        SRAV: r = a >>> b[4:0];
        default: r = 32'bx;
    endcase
end

endmodule

// ALU Module
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

parameter LUI = 6'b001111;
parameter SLT = 6'b101010;
parameter SLTU = 6'b101011;

wire [31:0] arith_r;
wire [31:0] log_r;
wire [31:0] shift_r;
wire carry_arith;
wire overflow_arith;

arithmetic_operations arith_op(.a(a), .b(b), .aluc(aluc), .r(arith_r), .carry(carry_arith), .overflow(overflow_arith));
logical_operations log_op(.a(a), .b(b), .aluc(aluc), .r(log_r));
shift_operations shift_op(.a(a), .b(b), .aluc(aluc), .r(shift_r));

assign r = (aluc == LUI) ? {a[15:0], 16'd0} :
           (aluc == SLT) ? (signed'(a) < signed'(b)) ? 32'd1 : 32'd0 :
           (aluc == SLTU) ? (a < b) ? 32'd1 : 32'd0 :
           (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU) ? arith_r :
           (aluc == AND || aluc == OR || aluc == XOR || aluc == NOR) ? log_r :
           (aluc == SLL || aluc == SRL || aluc == SRA || aluc == SLLV || aluc == SRLV || aluc == SRAV) ? shift_r :
           32'bx;

assign zero = (r == 32'd0) ? 1'b1 : 1'b0;
assign carry = (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU) ? carry_arith : 1'b0;
assign negative = (r[31] == 1'b1) ? 1'b1 : 1'b0;
assign overflow = (aluc == ADD || aluc == SUB) ? overflow_arith : 1'b0;
assign flag = (aluc == SLT || aluc == SLTU) ? (r[0] == 1'b1) ? 1'b1 : 1'b0 : 1'b0;

endmodule