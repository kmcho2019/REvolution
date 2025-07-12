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
    parameter LUI  = 6'b001111;

    wire [32:0] add_sub_result = (aluc == ADD) ? {1'b0, a} + {1'b0, b} : {1'b0, a} - {1'b0, b};
    wire slt_result = (aluc == SLT) ? ($signed(a) < $signed(b)) : (a < b);

    always @(*) begin
        case (aluc)
            ADD, SUB:  r = add_sub_result[31:0];
            AND:       r = a & b;
            OR:        r = a | b;
            XOR:       r = a ^ b;
            NOR:       r = ~(a | b);
            SLT, SLTU: r = {31'b0, slt_result};
            SLL:       r = b << a[4:0];
            SRL:       r = b >> a[4:0];
            SRA:      r = $signed(b) >>> a[4:0];
            LUI:       r = {b[15:0], 16'b0};
            default:   r = 0;
        endcase
    end

    assign zero = (r == 0);
    assign carry = ((aluc == ADD) || (aluc == SUB)) ? add_sub_result[32] : 0;
    assign negative = r[31];
    assign overflow = ((aluc == ADD) || (aluc == SUB)) ? 
                     (a[31] == b[31]) && (r[31] != a[31]) : 0;
    assign flag = ((aluc == SLT) || (aluc == SLTU)) ? r[0] : 0;

endmodule