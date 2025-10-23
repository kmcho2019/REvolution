module alu(
    input wire [31:0] a,
    input wire [31:0] b,
    input wire [5:0] aluc,
    output wire [31:0] r,
    output wire zero,
    output wire carry,
    output wire negative,
    output wire overflow,
    output wire flag
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

// Bitwise Operations Module
wire [31:0] bitwise_result;
assign bitwise_result = (aluc == AND) ? (a & b) :
                       (aluc == OR) ? (a | b) :
                       (aluc == XOR) ? (a ^ b) :
                       (aluc == NOR) ? ~(a | b) : 32'd0;

// Arithmetic Circuits Module
wire [31:0] arithmetic_result;
assign arithmetic_result = (aluc == ADD) ? (a + b) :
                          (aluc == ADDU) ? (a + b) :
                          (aluc == SUB) ? (a - b) :
                          (aluc == SUBU) ? (a - b) : 32'd0;

// Flag Generation Unit
assign zero = (r == 0);
assign carry = (aluc == ADD) ? (a[31] != b[31] && r[31] != a[31]) :
               (aluc == ADDU) ? (r[31] == 1'b1) : 1'b0;
assign negative = r[31];
assign overflow = (aluc == ADD) ? (a[31] != b[31] && r[31] != a[31]) :
                  (aluc == SUB) ? (a[31] == b[31] && r[31] != a[31]) : 1'b0;
assign flag = (aluc == SLT) ? (signed'(a) < signed'(b)) :
              (aluc == SLTU) ? (a < b) : 1'b0;

// Result Mux
assign r = (aluc == SLL) ? (a << b[4:0]) :
           (aluc == SRL) ? (a >> b[4:0]) :
           (aluc == SRA) ? (a >>> b[4:0]) :
           (aluc == LUI) ? ({a[15:0], 16'd0}) :
           (aluc == AND || aluc == OR || aluc == XOR || aluc == NOR) ? bitwise_result :
           (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU) ? arithmetic_result : 32'd0;

endmodule