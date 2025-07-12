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

    // Operation codes (same as specification)
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

    // Operation Group Detection
    wire is_arith = (aluc[5:4] == 2'b10); // ADD/ADDU/SUB/SUBU
    wire is_logic = (aluc[5:3] == 3'b100); // AND/OR/XOR/NOR
    wire is_shift = (aluc[5:3] == 3'b000); // Shift operations
    wire is_comp = (aluc == SLT || aluc == SLTU);
    wire is_lui = (aluc == LUI);

    // Arithmetic Unit (Hybrid Carry-Select)
    wire [31:0] arith_b = (aluc[0] ? b : ~b); // SUB/SUBU when aluc[0]=0
    wire cin = (aluc == SUB || aluc == SUBU);
    
    // 16-bit chunks for carry-select
    wire [15:0] sum_low, sum_high0, sum_high1;
    wire cout_low, cout_high0, cout_high1;
    
    // Lower 16 bits (ripple carry)
    assign {cout_low, sum_low} = a[15:0] + arith_b[15:0] + cin;
    
    // Upper 16 bits (carry-select)
    assign {cout_high0, sum_high0} = a[31:16] + arith_b[31:16] + 1'b0;
    assign {cout_high1, sum_high1} = a[31:16] + arith_b[31:16] + 1'b1;
    
    wire [31:0] arith_result = {cout_low ? sum_high1 : sum_high0, sum_low};
    wire arith_carry = cout_low ? cout_high1 : cout_high0;
    wire arith_ovf = ~aluc[1] & (a[31] == arith_b[31]) & (arith_result[31] != a[31]);

    // Logical Unit (Parallel Execution)
    wire [31:0] logic_result = 
        (aluc[1:0] == 2'b00) ? a & b : // AND
        (aluc[1:0] == 2'b01) ? a | b : // OR
        (aluc[1:0] == 2'b10) ? a ^ b : // XOR
        ~(a | b);                       // NOR

    // Shift Unit (Pre-decoded Barrel Shifter)
    wire [4:0] shift_amt = aluc[3] ? a[4:0] : b[4:0]; // SxV uses a[4:0]
    wire [31:0] shift_in = aluc[2] ? {32{b[31]}} : b; // SRA vs others
    wire [31:0] shift_result = 
        $signed({shift_in, shift_in}) >> (aluc[1] ? shift_amt : 32 - shift_amt);

    // Comparison Unit (Early Evaluation)
    wire comp_result = 
        (aluc == SLT) ? ($signed(a) < $signed(b)) : 
        (a < b); // SLTU

    // Result Multiplexing
    assign r = 
        is_lui    ? {b[15:0], 16'b0} :
        is_comp   ? {31'b0, comp_result} :
        is_arith  ? arith_result :
        is_logic  ? logic_result :
        is_shift  ? shift_result :
        32'b0;

    // Flag Generation (Predictive)
    assign zero = (r == 32'b0);
    assign carry = is_arith ? arith_carry : 1'b0;
    assign negative = r[31];
    assign overflow = is_arith ? arith_ovf : 1'b0;
    assign flag = is_comp ? comp_result : 1'b0;

endmodule