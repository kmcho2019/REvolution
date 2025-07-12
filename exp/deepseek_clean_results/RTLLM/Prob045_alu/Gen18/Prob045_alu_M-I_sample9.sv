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

    // Operation group detection
    wire is_arith = (aluc[5:4] == 2'b10); // ADD/SUB/SLT
    wire is_logic = (aluc[5:4] == 2'b10 && aluc[3]); // AND/OR/XOR/NOR
    wire is_shift = (aluc[5:4] == 2'b00); // Shift operations
    wire is_lui   = (aluc == LUI);

    // Arithmetic Unit (only activated for arithmetic ops)
    wire [32:0] arith_result;
    wire arith_ovf;
    wire arith_carry;
    wire a_sign = a[31];
    wire b_sign = b[31];
    
    assign {arith_carry, arith_result[31:0]} = 
        (aluc[0] ? {1'b0, a + b} : // ADD/ADDU
        {1'b0, a - b};              // SUB/SUBU
    
    assign arith_ovf = (aluc == ADD) && 
                      ((a_sign == b_sign) && (arith_result[31] != a_sign));

    // Comparison Unit (shared between SLT/SLTU/zero)
    wire signed [31:0] signed_a = a;
    wire signed [31:0] signed_b = b;
    wire lt_signed = (signed_a < signed_b);
    wire lt_unsigned = (a < b);
    wire cmp_result = (aluc[0] ? lt_unsigned : lt_signed);

    // Logic Unit
    wire [31:0] logic_result = 
        (aluc[1:0] == 2'b00) ? a & b :
        (aluc[1:0] == 2'b01) ? a | b :
        (aluc[1:0] == 2'b10) ? a ^ b :
        ~(a | b);

    // Shift Unit (with gated shift amount calculation)
    wire [4:0] shamt = is_shift ? 
                      ((aluc[3] && aluc[1:0] != 2'b00) ? a[4:0] : b[4:0]) : 
                      5'b0;
    wire [31:0] shift_result = 
        (aluc[2:0] == 3'b000) ? b << shamt :
        (aluc[2:0] == 3'b010) ? b >> shamt :
        $signed(b) >>> shamt;

    // Hierarchical Result Selection
    wire [31:0] group_result = 
        is_arith ? (aluc[3] ? {31'b0, cmp_result} : arith_result[31:0]) :
        is_logic ? logic_result :
        is_shift ? shift_result :
        is_lui   ? {b[15:0], 16'b0} :
        32'b0;

    assign r = group_result;

    // Optimized Flag Generation
    assign zero = (group_result == 0);
    assign carry = is_arith && !aluc[3] ? arith_carry : 1'b0;
    assign negative = group_result[31];
    assign overflow = is_arith && !aluc[3] ? arith_ovf : 1'b0;
    assign flag = (aluc == SLT || aluc == SLTU) ? cmp_result : 1'b0;

endmodule