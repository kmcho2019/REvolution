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

    // Clock gating signals
    wire arith_en = (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU || 
                    aluc == SLT || aluc == SLTU);
    wire logic_en = (aluc == AND || aluc == OR || aluc == XOR || aluc == NOR);
    wire shift_en = (aluc == SLL || aluc == SRL || aluc == SRA || 
                    aluc == SLLV || aluc == SRLV || aluc == SRAV);
    wire lui_en = (aluc == LUI);

    // Arithmetic operations (signed and unsigned separated)
    wire [31:0] add_result, sub_result;
    wire [32:0] add_ext = {1'b0, a} + {1'b0, b};
    wire [32:0] sub_ext = {1'b0, a} - {1'b0, b};
    
    assign add_result = (aluc == ADD || aluc == ADDU) ? add_ext[31:0] : 32'b0;
    assign sub_result = (aluc == SUB || aluc == SUBU) ? sub_ext[31:0] : 32'b0;
    
    // Comparison operations
    wire slt_result = $signed(a) < $signed(b);
    wire sltu_result = a < b;
    
    // Shared arithmetic result
    wire [31:0] arith_result = 
        (aluc == ADD || aluc == ADDU) ? add_result :
        (aluc == SUB || aluc == SUBU) ? sub_result :
        (aluc == SLT) ? {31'b0, slt_result} :
        (aluc == SLTU) ? {31'b0, sltu_result} :
        32'b0;

    // Logical operations (combined)
    wire [31:0] logic_result = 
        (aluc == AND) ? a & b :
        (aluc == OR)  ? a | b :
        (aluc == XOR) ? a ^ b :
        (aluc == NOR) ? ~(a | b) :
        32'b0;

    // Shared shifter
    wire [4:0] shamt = (aluc[3]) ? a[4:0] : b[4:0]; // SLLV/SRLV/SRAV use a[4:0]
    wire [31:0] shift_in = (aluc == SLL || aluc == SLLV) ? b : 
                          (aluc == SRA || aluc == SRAV) ? $signed(b) : b;
    wire [31:0] shifted = shift_in >> shamt;
    
    // Shift operations
    wire [31:0] shift_result = 
        (aluc == SLL || aluc == SLLV) ? b << shamt :
        (aluc == SRL || aluc == SRLV) ? b >> shamt :
        shifted;

    // Special operations
    wire [31:0] special_result = 
        (aluc == LUI) ? {b[15:0], 16'b0} :
        shift_result;

    // Hierarchical result selection
    wire [31:0] result;
    assign result = 
        arith_en ? arith_result :
        logic_en ? logic_result :
        (shift_en || lui_en) ? special_result :
        32'b0;

    assign r = result;

    // Optimized flag generation
    wire arith_carry = (aluc == ADD || aluc == ADDU) ? add_ext[32] : 
                      (aluc == SUB || aluc == SUBU) ? sub_ext[32] : 1'b0;
    
    assign zero = (result == 32'b0);
    assign carry = (aluc == ADDU || aluc == SUBU) ? arith_carry : 1'b0;
    assign negative = result[31];
    assign overflow = (aluc == ADD) ? (a[31] == b[31] && result[31] != a[31]) :
                     (aluc == SUB) ? (a[31] != b[31] && result[31] == b[31]) :
                     1'b0;
    assign flag = (aluc == SLT) ? slt_result :
                 (aluc == SLTU) ? sltu_result :
                 1'b0;

endmodule