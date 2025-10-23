module alu(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output reg [31:0] r,
    output zero,
    output carry,
    output negative,
    output overflow,
    output reg flag
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
    wire signed [31:0] a_signed = a;
    wire signed [31:0] b_signed = b;
    wire [32:0] add_res = {1'b0, a} + {1'b0, b};
    wire [32:0] sub_res = {1'b0, a} - {1'b0, b};

    always @(*) begin
        case (aluc)
            ADD, ADDU: r = add_res[31:0];
            SUB, SUBU: r = sub_res[31:0];
            AND:  r = a & b;
            OR:   r = a | b;
            XOR:  r = a ^ b;
            NOR:  r = ~(a | b);
            SLT:  r = {31'b0, a_signed < b_signed};
            SLTU: r = {31'b0, a < b};
            SLL:  r = b << a[4:0];
            SRL:  r = b >> a[4:0];
            SRA:  r = $signed(b) >>> a[4:0];
            SLLV: r = b << b[4:0];
            SRLV: r = b >> b[4:0];
            SRAV: r = $signed(b) >>> b[4:0];
            LUI:  r = {b[15:0], 16'b0};
            default: r = 32'bz;
        endcase

        // Flag outputs
        flag = (aluc == SLT) ? (a_signed < b_signed) :
               (aluc == SLTU) ? (a < b) : 1'bz;
    end

    // Continuous flag assignments
    assign zero = (r == 32'b0);
    assign carry = (aluc == ADD || aluc == ADDU) ? add_res[32] :
                  (aluc == SUB || aluc == SUBU) ? sub_res[32] : 1'b0;
    assign negative = r[31];
    assign overflow = (aluc == ADD) ? (a_signed[31] == b_signed[31]) && (r[31] != a_signed[31]) :
                     (aluc == SUB) ? (a_signed[31] != b_signed[31]) && (r[31] != a_signed[31]) : 1'b0;

endmodule