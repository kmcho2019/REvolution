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
    reg [31:0] result;
    wire [32:0] arith_result;
    wire [4:0] shift_amt;
    wire signed [31:0] signed_a = a;
    wire signed [31:0] signed_b = b;
    wire is_arith = (aluc[5:4] == 2'b10);
    wire is_shift = (aluc[5:3] == 3'b000);
    wire is_compare = (aluc == SLT || aluc == SLTU);

    // Arithmetic unit
    assign arith_result = {1'b0, a} + {1'b0, (aluc[1] ? ~b : b)} + aluc[1];

    // Shift amount selection
    assign shift_amt = aluc[3] ? a[4:0] : b[4:0];

    // Main operation selection
    always @(*) begin
        case (aluc)
            // Arithmetic operations
            ADD, ADDU, SUB, SUBU: result = arith_result[31:0];
            
            // Logical operations
            AND:       result = a & b;
            OR:        result = a | b;
            XOR:       result = a ^ b;
            NOR:       result = ~(a | b);
            
            // Comparison operations
            SLT:       result = signed_a < signed_b;
            SLTU:      result = a < b;
            
            // Shift operations
            SLL, SLLV: result = b << shift_amt;
            SRL, SRLV: result = b >> shift_amt;
            SRA, SRAV: result = signed_b >>> shift_amt;
            
            // Immediate operations
            LUI:       result = {b[15:0], 16'b0};
            
            default:   result = 32'b0;
        endcase
    end

    // Flag generation
    assign zero = (result == 32'b0);
    assign negative = result[31];
    assign carry = is_arith ? arith_result[32] : 1'b0;
    
    // Overflow detection for ADD/SUB only
    assign overflow = is_arith & ~aluc[0] & 
                     (a[31] == (aluc[1] ? ~b[31] : b[31])) & 
                     (result[31] != a[31]);
    
    // Flag output for SLT/SLTU only
    assign flag = is_compare ? result[0] : 1'b0;

    // Final output
    assign r = result;

endmodule