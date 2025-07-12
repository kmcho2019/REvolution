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

    // Internal operation classification
    wire is_arith = (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU);
    wire is_logic = (aluc == AND || aluc == OR || aluc == XOR || aluc == NOR);
    wire is_shift = (aluc == SLL || aluc == SRL || aluc == SRA || 
                    aluc == SLLV || aluc == SRLV || aluc == SRAV);
    wire is_comp  = (aluc == SLT || aluc == SLTU);
    wire is_lui   = (aluc == LUI);

    // Functional unit results
    wire [31:0] arith_result, logic_result, shift_result, comp_result;
    wire arith_carry, arith_overflow;

    // Arithmetic Unit (handles ADD/ADDU/SUB/SUBU)
    wire [32:0] arith_full_result;
    wire do_subtract = (aluc == SUB || aluc == SUBU);
    assign arith_full_result = do_subtract ? ({1'b0, a} - {1'b0, b}) : 
                                           ({1'b0, a} + {1'b0, b});
    assign arith_result = arith_full_result[31:0];
    assign arith_carry = arith_full_result[32];
    assign arith_overflow = (aluc == ADD || aluc == SUB) ? 
                          ((a[31] == b[31] ^ do_subtract) && 
                           (arith_result[31] != a[31])) : 1'b0;

    // Logic Unit (handles AND/OR/XOR/NOR)
    assign logic_result = (aluc == AND) ? (a & b) :
                         (aluc == OR)  ? (a | b) :
                         (aluc == XOR) ? (a ^ b) :
                         ~(a | b);  // NOR

    // Shift Unit (handles all shift operations)
    wire [4:0] shift_amount = (aluc[3] ? a[4:0] : b[4:0]); // Variable shifts use a[4:0]
    assign shift_result = (aluc == SLL || aluc == SLLV) ? (b << shift_amount) :
                         (aluc == SRL || aluc == SRLV) ? (b >> shift_amount) :
                         ($signed(b) >>> shift_amount); // SRA/SRAV

    // Comparison Unit (handles SLT/SLTU)
    assign comp_result = (aluc == SLT) ? ($signed(a) < $signed(b) :
                        (a < b); // SLTU

    // LUI operation
    wire [31:0] lui_result = {b[15:0], 16'b0};

    // Result selection
    always @(*) begin
        case (1'b1)
            is_arith: r = arith_result;
            is_logic: r = logic_result;
            is_shift: r = shift_result;
            is_comp:  r = {31'b0, comp_result};
            is_lui:   r = lui_result;
            default:  r = 32'b0;
        endcase
    end

    // Flag generation
    assign zero = (r == 32'b0);
    assign negative = r[31];
    assign carry = is_arith ? arith_carry : 1'b0;
    assign overflow = is_arith ? arith_overflow : 1'b0;
    assign flag = is_comp ? comp_result : 1'b0;

endmodule