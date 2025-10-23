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

    // Internal signals
    wire [32:0] sum = {1'b0, a} + {1'b0, b};  // 33-bit for carry
    wire [32:0] diff = {1'b0, a} - {1'b0, b}; // 33-bit for carry
    wire [4:0] shamt = (aluc[3:0] == 4'b0100 || aluc[3:0] == 4'b0110 || aluc[3:0] == 4'b0111) ? 
                      a[4:0] : b[4:0];
    
    // Operation results (computed only when needed)
    wire [31:0] arith_result = 
        (aluc == ADD || aluc == ADDU) ? sum[31:0] :
        (aluc == SUB || aluc == SUBU) ? diff[31:0] : 32'b0;
    
    wire [31:0] logic_result =
        (aluc == AND) ? (a & b) :
        (aluc == OR)  ? (a | b) :
        (aluc == XOR) ? (a ^ b) :
        (aluc == NOR) ? ~(a | b) : 32'b0;
    
    wire [31:0] shift_result =
        (aluc == SLL || aluc == SLLV) ? (b << shamt) :
        (aluc == SRL || aluc == SRLV) ? (b >> shamt) :
        (aluc == SRA || aluc == SRAV) ? ($signed(b) >>> shamt) : 32'b0;
    
    wire [31:0] cmp_result =
        (aluc == SLT)  ? {31'b0, $signed(a) < $signed(b)} :
        (aluc == SLTU) ? {31'b0, a < b} : 32'b0;
    
    wire [31:0] lui_result = (aluc == LUI) ? {b[15:0], 16'b0} : 32'b0;

    // Final result selection
    assign r = arith_result | logic_result | shift_result | cmp_result | lui_result;

    // Flag generation
    assign zero = (r == 0);
    assign carry = 
        ((aluc == ADD || aluc == ADDU) && sum[32]) ||
        ((aluc == SUB || aluc == SUBU) && diff[32]);
    assign negative = r[31];
    assign overflow =
        (aluc == ADD && (a[31] == b[31]) && (r[31] != a[31])) ||
        (aluc == SUB && (a[31] != b[31]) && (r[31] != a[31]));
    assign flag = 
        (aluc == SLT || aluc == SLTU) ? r[0] : 1'b0;

endmodule