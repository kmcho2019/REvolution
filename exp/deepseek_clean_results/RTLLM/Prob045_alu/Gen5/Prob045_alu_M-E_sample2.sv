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

    // Operation type detection
    wire is_arith = (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU || 
                    aluc == SLT || aluc == SLTU);
    wire is_logic = (aluc == AND || aluc == OR || aluc == XOR || aluc == NOR);
    wire is_shift = (aluc == SLL || aluc == SRL || aluc == SRA || 
                    aluc == SLLV || aluc == SRLV || aluc == SRAV);
    wire is_special = (aluc == LUI);

    // Arithmetic Unit (handles ADD/SUB/SLT)
    wire [31:0] arith_b = (aluc == SUB || aluc == SUBU) ? ~b : b;
    wire [32:0] arith_sum = {1'b0, a} + {1'b0, arith_b} + 
                           ((aluc == SUB || aluc == SUBU) ? 33'b1 : 33'b0);
    wire [31:0] arith_result = arith_sum[31:0];
    wire arith_carry = arith_sum[32];
    
    // Comparison results
    wire slt_result = $signed(a) < $signed(b);
    wire sltu_result = a < b;

    // Logical Unit
    wire [31:0] logic_and = a & b;
    wire [31:0] logic_or = a | b;
    wire [31:0] logic_xor = a ^ b;
    wire [31:0] logic_nor = ~(a | b);
    
    // Shift Unit
    wire [4:0] shift_amount = (aluc[3] /* SxLV ops */) ? a[4:0] : b[4:0];
    wire [31:0] shift_left = b << shift_amount;
    wire [31:0] shift_right_logical = b >> shift_amount;
    wire [31:0] shift_right_arithmetic = $signed(b) >>> shift_amount;

    // Special Operations
    wire [31:0] lui_result = {b[15:0], 16'b0};

    // Result Selection
    reg [31:0] result;
    always @(*) begin
        case (aluc)
            ADD, ADDU, SUB, SUBU: result = arith_result;
            SLT: result = {31'b0, slt_result};
            SLTU: result = {31'b0, sltu_result};
            AND: result = logic_and;
            OR: result = logic_or;
            XOR: result = logic_xor;
            NOR: result = logic_nor;
            SLL, SLLV: result = shift_left;
            SRL, SRLV: result = shift_right_logical;
            SRA, SRAV: result = shift_right_arithmetic;
            LUI: result = lui_result;
            default: result = 32'b0;
        endcase
    end

    // Flag Generation
    assign r = result;
    assign zero = (result == 32'b0);
    assign negative = result[31];
    assign carry = (aluc == ADDU || aluc == SUBU) ? arith_carry : 1'b0;
    
    // Overflow detection
    wire add_overflow = (a[31] == b[31]) && (result[31] != a[31]);
    wire sub_overflow = (a[31] != b[31]) && (result[31] == b[31]);
    assign overflow = (aluc == ADD) ? add_overflow : 
                     (aluc == SUB) ? sub_overflow : 1'b0;
    
    // Flag output (for SLT/SLTU)
    assign flag = (aluc == SLT || aluc == SLTU) ? result[0] : 1'b0;

endmodule