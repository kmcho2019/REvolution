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

    reg [31:0] result;
    reg [32:0] sum; // Extra bit for carry
    reg comp_flag;
    
    always @(*) begin
        case(aluc)
            ADD, ADDU: begin
                sum = a + b;
                result = sum[31:0];
            end
            SUB, SUBU: begin
                sum = a - b;
                result = sum[31:0];
            end
            AND:  result = a & b;
            OR:   result = a | b;
            XOR:  result = a ^ b;
            NOR:  result = ~(a | b);
            SLT:  begin
                result = 0;
                comp_flag = $signed(a) < $signed(b);
            end
            SLTU: begin
                result = 0;
                comp_flag = a < b;
            end
            SLL:  result = b << a[4:0];
            SRL:  result = b >> a[4:0];
            SRA:  result = $signed(b) >>> a[4:0];
            SLLV: result = b << a[4:0];
            SRLV: result = b >> a[4:0];
            SRAV: result = $signed(b) >>> a[4:0];
            LUI:  result = {b[15:0], 16'b0};
            default: result = 32'b0;
        endcase
    end

    // Flag generation
    assign r = result;
    assign zero = (result == 32'b0);
    assign carry = (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU) ? sum[32] : 1'b0;
    assign negative = result[31];
    assign overflow = ((aluc == ADD || aluc == SUB) && 
                      (a[31] == b[31] ^ (aluc == SUB)) && 
                      (result[31] != a[31]));
    assign flag = (aluc == SLT || aluc == SLTU) ? comp_flag : 1'b0;

endmodule