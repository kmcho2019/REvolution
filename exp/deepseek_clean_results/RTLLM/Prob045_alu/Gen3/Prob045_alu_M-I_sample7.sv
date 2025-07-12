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

    // Operation classification
    wire is_arith = (aluc == ADD)  || (aluc == ADDU) || 
                    (aluc == SUB)  || (aluc == SUBU);
    wire is_logic = (aluc == AND)  || (aluc == OR) || 
                    (aluc == XOR)  || (aluc == NOR);
    wire is_shift = (aluc == SLL)  || (aluc == SRL) || (aluc == SRA) || 
                    (aluc == SLLV) || (aluc == SRLV) || (aluc == SRAV);
    wire is_comp  = (aluc == SLT)  || (aluc == SLTU);
    
    // Shared arithmetic resources
    wire [31:0] b_operand = ((aluc == SUB) || (aluc == SUBU)) ? ~b + 1 : b;
    wire [32:0] arith_res = {1'b0, a} + {1'b0, b_operand};
    
    // Optimized barrel shifter
    wire [4:0] shift_amount = (aluc[3] ? a[4:0] : b[4:0]); // SLLV/SRLV/SRAV use a[4:0]
    wire [31:0] shift_res = 
        (aluc == SLL || aluc == SLLV) ? b << shift_amount :
        (aluc == SRL || aluc == SRLV) ? b >> shift_amount :
        $signed(b) >>> shift_amount; // SRA/SRAV
    
    // Overflow detection (parallel computation)
    wire add_ovf = (a[31] == b[31]) && (arith_res[31] != a[31]);
    wire sub_ovf = (a[31] != b_operand[31]) && (arith_res[31] != a[31]);
    wire ovf = (aluc == ADD) ? add_ovf : 
               (aluc == SUB) ? sub_ovf : 1'b0;
    
    // Status flags
    assign zero = (r == 32'b0);
    assign carry = is_arith & arith_res[32];
    assign negative = r[31];
    assign overflow = ovf;
    assign flag = (aluc == SLT) ? (signed_a < signed_b) :
                 (aluc == SLTU) ? (a < b) : 1'b0;

    // Main operation selection with operation gating
    always @(*) begin
        case (aluc)
            ADD, ADDU, SUB, SUBU: r = arith_res[31:0];
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

endmodule