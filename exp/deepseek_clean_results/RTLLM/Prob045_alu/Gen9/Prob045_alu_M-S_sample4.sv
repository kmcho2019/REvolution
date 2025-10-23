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

    // Main computation
    reg [31:0] result;
    wire [32:0] arith_result = {1'b0, a} + {1'b0, (aluc[1] ? ~b : b)} + aluc[1];
    wire [4:0] shift_amt = aluc[3] ? a[4:0] : b[4:0];
    wire signed [31:0] signed_b = b;

    always @(*) begin
        case (aluc)
            ADD, ADDU: result = arith_result[31:0];
            SUB, SUBU: result = arith_result[31:0];
            AND:       result = a & b;
            OR:        result = a | b;
            XOR:       result = a ^ b;
            NOR:       result = ~(a | b);
            SLT:       result = $signed(a) < $signed(b);
            SLTU:      result = a < b;
            SLL:      result = b << shift_amt;
            SRL:       result = b >> shift_amt;
            SRA:       result = signed_b >>> shift_amt;
            SLLV:     result = b << a[4:0];
            SRLV:     result = b >> a[4:0];
            SRAV:     result = signed_b >>> a[4:0];
            LUI:      result = {b[15:0], 16'b0};
            default:   result = 32'b0;
        endcase
    end

    // Flag generation
    assign zero = (result == 32'b0);
    assign negative = result[31];
    assign carry = (aluc[5:4] == 2'b10) ? arith_result[32] : 1'b0;
    assign overflow = (aluc[5:1] == 5'b10000) & 
                     (a[31] == (aluc[1] ? ~b[31] : b[31])) & 
                     (result[31] != a[31]);
    assign flag = (aluc == SLT || aluc == SLTU) ? result[0] : 1'b0;

    // Final output
    assign r = result;

endmodule