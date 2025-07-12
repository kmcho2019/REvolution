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

    // Operation group detection
    wire is_arith = (aluc == ADD) || (aluc == ADDU) || (aluc == SUB) || (aluc == SUBU);
    wire is_logic = (aluc == AND) || (aluc == OR) || (aluc == XOR) || (aluc == NOR);
    wire is_shift = (aluc == SLL) || (aluc == SRL) || (aluc == SRA) || 
                    (aluc == SLLV) || (aluc == SRLV) || (aluc == SRAV);
    wire is_comp = (aluc == SLT) || (aluc == SLTU);
    
    // Shared arithmetic unit
    wire [31:0] b_arith = (aluc == SUB || aluc == SUBU) ? ~b : b;
    wire [32:0] arith_result = a + b_arith + ((aluc == SUB || aluc == SUBU) ? 1'b1 : 1'b0);
    
    // Shared shift unit
    wire [4:0] shift_amount = (aluc[3]) ? a[4:0] : b[4:0]; // SLLV/SRLV/SRAV use a[4:0]
    wire [31:0] shift_result = 
        (aluc == SLL || aluc == SLLV) ? b << shift_amount :
        (aluc == SRL || aluc == SRLV) ? b >> shift_amount :
        $signed(b) >>> shift_amount; // SRA/SRAV
    
    // Flag generation
    assign zero = (r == 32'b0);
    assign carry = is_arith & arith_result[32];
    assign negative = r[31];
    assign overflow = ((aluc == ADD) & (a[31] == b[31]) & (r[31] != a[31])) |
                     ((aluc == SUB) & (a[31] != b[31]) & (r[31] != a[31]));
    assign flag = is_comp & r[0];

    // Main operation selection
    always @(*) begin
        case (aluc)
            ADD, ADDU, SUB, SUBU: r = arith_result[31:0];
            AND:  r = a & b;
            OR:   r = a | b;
            XOR:  r = a ^ b;
            NOR:  r = ~(a | b);
            SLT:  r = ($signed(a) < $signed(b)) ? 32'b1 : 32'b0;
            SLTU: r = (a < b) ? 32'b1 : 32'b0;
            SLL, SRL, SRA, SLLV, SRLV, SRAV: r = shift_result;
            LUI:  r = {b[15:0], 16'b0};
            default: r = 32'b0;
        endcase
    end

endmodule