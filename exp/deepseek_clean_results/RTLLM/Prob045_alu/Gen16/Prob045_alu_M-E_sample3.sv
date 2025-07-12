module alu(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output reg [31:0] r,
    output zero,
    output carry,
    output negative,
    output overflow,
    output reg flag
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

    // Shared arithmetic unit
    wire [32:0] arith_result;
    wire arith_ovf;
    wire arith_carry;
    
    assign arith_result = (aluc == ADD || aluc == ADDU) ? (a + b) :
                         (aluc == SUB || aluc == SUBU) ? (a - b) : 33'b0;
    assign arith_ovf = (aluc == ADD) ? ((a[31] == b[31]) && (arith_result[31] != a[31])) :
                      (aluc == SUB) ? ((a[31] != b[31]) && (arith_result[31] != a[31])) : 1'b0;
    assign arith_carry = arith_result[32];

    // Unified shift unit
    wire [4:0] shift_amount = (aluc == SLLV || aluc == SRLV || aluc == SRAV) ? a[4:0] : b[4:0];
    wire [31:0] shift_result;
    
    assign shift_result = (aluc == SLL || aluc == SLLV) ? (b << shift_amount) :
                         (aluc == SRL || aluc == SRLV) ? (b >> shift_amount) :
                         (aluc == SRA || aluc == SRAV) ? ($signed(b) >>> shift_amount) : 32'b0;

    // Comparison unit
    wire [31:0] cmp_result;
    assign cmp_result = (aluc == SLT) ? ($signed(a) < $signed(b)) :
                       (aluc == SLTU) ? (a < b) : 32'b0;

    // Parallel zero detection
    wire [31:0] result_bus;
    assign zero = (result_bus == 32'b0);

    // Main operation selection
    always @(*) begin
        case (aluc)
            ADD, ADDU, SUB, SUBU: r = arith_result[31:0];
            AND:       r = a & b;
            OR:        r = a | b;
            XOR:       r = a ^ b;
            NOR:       r = ~(a | b);
            SLT, SLTU: r = cmp_result;
            SLL, SLLV, SRL, SRLV, SRA, SRAV: r = shift_result;
            LUI:       r = {b[15:0], 16'b0};
            default:    r = 32'b0;
        endcase
        
        // Dynamic flag generation
        flag = (aluc == SLT || aluc == SLTU) ? r[0] : 1'b0;
        result_bus = r;
    end

    // Flag outputs
    assign carry = (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU) ? arith_carry : 1'b0;
    assign negative = r[31];
    assign overflow = (aluc == ADD || aluc == SUB) ? arith_ovf : 1'b0;

endmodule