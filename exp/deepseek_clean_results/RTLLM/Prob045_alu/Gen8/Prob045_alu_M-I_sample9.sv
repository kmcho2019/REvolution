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

    wire signed [31:0] a_signed = a;
    wire signed [31:0] b_signed = b;
    wire [4:0] shift_amount = (aluc == SLLV || aluc == SRLV || aluc == SRAV) ? a[4:0] : b[4:0];
    
    // Arithmetic operations (shared between signed/unsigned)
    wire [32:0] add_result = {1'b0, a} + {1'b0, b};
    wire [32:0] sub_result = {1'b0, a} - {1'b0, b};
    
    // Comparison results (computed only when needed)
    wire slt_result = (aluc == SLT) ? (a_signed < b_signed) : 1'b0;
    wire sltu_result = (aluc == SLTU) ? (a < b) : 1'b0;
    
    // Main result selection
    reg [31:0] result;
    always @(*) begin
        case (aluc)
            ADD, ADDU:  result = add_result[31:0];
            SUB, SUBU:  result = sub_result[31:0];
            AND:        result = a & b;
            OR:         result = a | b;
            XOR:        result = a ^ b;
            NOR:        result = ~(a | b);
            SLT:        result = {31'b0, slt_result};
            SLTU:       result = {31'b0, sltu_result};
            SLL, SLLV:  result = b << shift_amount;
            SRL, SRLV:  result = b >> shift_amount;
            SRA, SRAV:  result = $signed(b) >>> shift_amount;
            LUI:        result = {b[15:0], 16'b0};
            default:    result = 32'b0;
        endcase
    end
    
    assign r = result;
    
    // Flag generation
    assign zero = (result == 32'b0);
    assign carry = (aluc == ADD || aluc == ADDU) ? add_result[32] : 
                  (aluc == SUB || aluc == SUBU) ? sub_result[32] : 1'b0;
    assign negative = result[31];
    assign overflow = (aluc == ADD) ? (~a[31] & ~b[31] & result[31]) | (a[31] & b[31] & ~result[31]) :
                     (aluc == SUB) ? (~a[31] & b[31] & result[31]) | (a[31] & ~b[31] & ~result[31]) : 1'b0;
    assign flag = (aluc == SLT) ? slt_result : 
                 (aluc == SLTU) ? sltu_result : 1'b0;

endmodule