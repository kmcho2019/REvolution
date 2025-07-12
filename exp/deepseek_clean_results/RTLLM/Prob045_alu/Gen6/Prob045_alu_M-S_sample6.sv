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

    wire signed [31:0] a_signed = a;
    wire signed [31:0] b_signed = b;
    wire [4:0] shift_amount = aluc[2] ? a[4:0] : b[4:0];  // SLLV/SRLV/SRAV use a[4:0]
    
    reg [31:0] result;
    reg carry_out, overflow_out, flag_out;

    always @(*) begin
        case(aluc)
            ADD, ADDU: {carry_out, result} = a + b;
            SUB, SUBU: {carry_out, result} = a - b;
            AND:  result = a & b;
            OR:   result = a | b;
            XOR:  result = a ^ b;
            NOR:  result = ~(a | b);
            SLT:  begin
                result = {31'b0, a_signed < b_signed};
                flag_out = a_signed < b_signed;
            end
            SLTU: begin
                result = {31'b0, a < b};
                flag_out = a < b;
            end
            SLL, SLLV:  result = b << shift_amount;
            SRL, SRLV:  result = b >> shift_amount;
            SRA, SRAV:  result = $signed(b) >>> shift_amount;
            LUI:  result = {b[15:0], 16'b0};
            default: result = 32'b0;
        endcase

        // Overflow detection for signed operations
        overflow_out = 1'b0;
        if (aluc == ADD)
            overflow_out = (~a[31] & ~b[31] & result[31]) | (a[31] & b[31] & ~result[31]);
        else if (aluc == SUB)
            overflow_out = (~a[31] & b[31] & result[31]) | (a[31] & ~b[31] & ~result[31]);
    end

    assign r = result;
    assign zero = (result == 32'b0);
    assign carry = carry_out;
    assign negative = result[31];
    assign overflow = overflow_out;
    assign flag = (aluc == SLT || aluc == SLTU) ? flag_out : 1'b0;

endmodule