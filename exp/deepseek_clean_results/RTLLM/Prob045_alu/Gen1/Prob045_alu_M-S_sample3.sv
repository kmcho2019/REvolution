module alu(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output reg [31:0] r,
    output zero,
    output carry,
    output negative,
    output overflow,
    output flag
);

    // Operation codes
    parameter ADD  = 6'b100000;
    parameter ADDU = 6'b100001;
    parameter SUB  = 6'b100010;
    parameter SUBU = 6'b100011;
    parameter AND  = 6'b100100;
    parameter OR   = 6'b100101;
    parameter XOR  = 6'b100110;
    parameter NOR  = 6'b100111;
    parameter SLT  = 6'b101010;
    parameter SLTU = 6'b101011;
    parameter SLL  = 6'b000000;
    parameter SRL  = 6'b000010;
    parameter SRA  = 6'b000011;
    parameter SLLV = 6'b000100;
    parameter SRLV = 6'b000110;
    parameter SRAV = 6'b000111;
    parameter LUI  = 6'b001111;

    // Internal signals
    wire [31:0] add_res = a + b;
    wire [31:0] sub_res = a - b;
    wire [4:0] shamt = b[4:0];
    wire signed [31:0] a_signed = a;
    wire signed [31:0] b_signed = b;

    // Status flags
    assign zero = (r == 32'b0);
    assign negative = r[31];
    assign carry = (aluc == ADD || aluc == ADDU) ? (a + b < a) :
                  (aluc == SUB || aluc == SUBU) ? (a < b) : 1'b0;
    assign overflow = (aluc == ADD) ? (~a[31] & ~b[31] & r[31]) | (a[31] & b[31] & ~r[31]) :
                     (aluc == SUB) ? (~a[31] & b[31] & r[31]) | (a[31] & ~b[31] & ~r[31]) : 1'b0;
    assign flag = (aluc == SLT) ? (a_signed < b_signed) :
                 (aluc == SLTU) ? (a < b) : 1'b0;

    always @(*) begin
        case (aluc)
            ADD, ADDU: r = add_res;
            SUB, SUBU: r = sub_res;
            AND: r = a & b;
            OR:  r = a | b;
            XOR: r = a ^ b;
            NOR: r = ~(a | b);
            SLT, SLTU: r = 32'b0;  // Result handled by flag
            SLL, SLLV: r = b << (aluc == SLL ? a[4:0] : shamt);
            SRL, SRLV: r = b >> (aluc == SRL ? a[4:0] : shamt);
            SRA, SRAV: r = $signed(b) >>> (aluc == SRA ? a[4:0] : shamt);
            LUI: r = {b[15:0], 16'b0};
            default: r = 32'b0;
        endcase
    end

endmodule