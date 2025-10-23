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

    // Parallel computation units
    wire [31:0] arith_res, logic_res, shift_res;
    wire [32:0] arith_full;
    wire [4:0] shift_amt = aluc[2] ? a[4:0] : b[4:0];
    
    // Arithmetic Unit
    wire [31:0] arith_b = aluc[0] ? ~b : b;
    assign arith_full = {1'b0, a} + {1'b0, arith_b} + aluc[0];
    assign arith_res = arith_full[31:0];
    
    // Logic Unit
    assign logic_res = 
        (aluc == AND) ? a & b :
        (aluc == OR)  ? a | b :
        (aluc == XOR) ? a ^ b :
        (aluc == NOR) ? ~(a | b) :
        (aluc == SLT) ? {31'b0, $signed(a) < $signed(b)} :
        (aluc == SLTU) ? {31'b0, a < b} : 32'b0;
    
    // Shift Unit (Barrel Shifter)
    assign shift_res = 
        (aluc == SLL || aluc == SLLV) ? b << shift_amt :
        (aluc == SRL || aluc == SRLV) ? b >> shift_amt :
        (aluc == SRA || aluc == SRAV) ? $signed(b) >>> shift_amt :
        (aluc == LUI) ? {b[15:0], 16'b0} : 32'b0;
    
    // Result Selection
    always @(*) begin
        case (1'b1)
            (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU): r = arith_res;
            (aluc == AND || aluc == OR || aluc == XOR || aluc == NOR || aluc == SLT || aluc == SLTU): r = logic_res;
            (aluc == SLL || aluc == SRL || aluc == SRA || aluc == SLLV || aluc == SRLV || aluc == SRAV || aluc == LUI): r = shift_res;
            default: r = 32'b0;
        endcase
    end
    
    // Flag Generation
    wire is_arith = (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU);
    wire is_signed_arith = (aluc == ADD || aluc == SUB);
    
    assign zero = (r == 32'b0);
    assign negative = r[31];
    assign carry = is_arith ? arith_full[32] : 1'b0;
    assign overflow = is_signed_arith ? (arith_full[32] ^ arith_full[31]) : 1'b0;
    assign flag = (aluc == SLT || aluc == SLTU) ? r[0] : 1'b0;

endmodule