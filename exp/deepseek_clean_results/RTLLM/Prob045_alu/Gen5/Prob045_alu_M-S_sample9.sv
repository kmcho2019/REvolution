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
    parameter SUB  = 6'b100010;
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
    wire [4:0] shift_amount = aluc[2] ? a[4:0] : b[4:0]; // For variable shifts
    wire [32:0] arith_res = (aluc[1] ? {1'b0,a} - {1'b0,b} : {1'b0,a} + {1'b0,b});
    wire [31:0] shift_res = 
        (aluc[1:0] == 2'b00) ? b << shift_amount :
        (aluc[1:0] == 2'b10) ? b >> shift_amount :
        $signed(b) >>> shift_amount;

    always @(*) begin
        case (aluc)
            ADD, SUB: r = arith_res[31:0];
            AND:  r = a & b;
            OR:   r = a | b;
            XOR:  r = a ^ b;
            NOR:  r = ~(a | b);
            SLT:  r = {31'b0, $signed(a) < $signed(b)};
            SLTU: r = {31'b0, a < b};
            SLL, SRL, SRA, SLLV, SRLV, SRAV: r = shift_res;
            LUI:  r = {b[15:0], 16'b0};
            default: r = 32'b0;
        endcase
    end

    // Flag assignments
    assign zero = (r == 0);
    assign carry = arith_res[32] & (aluc == ADD || aluc == SUB);
    assign negative = r[31];
    assign overflow = (aluc == ADD) ? (~a[31] & ~b[31] & r[31]) | (a[31] & b[31] & ~r[31]) :
                     (aluc == SUB) ? (~a[31] & b[31] & r[31]) | (a[31] & ~b[31] & ~r[31]) : 0;
    assign flag = (aluc == SLT) ? ($signed(a) < $signed(b)) :
                 (aluc == SLTU) ? (a < b) : 0;

endmodule