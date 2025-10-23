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

    wire [4:0] shift_amount = (aluc[3] || aluc == SLLV || aluc == SRLV || aluc == SRAV) ? a[4:0] : b[4:0];
    wire [32:0] arith_result;
    wire is_arith = (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU);

    always @(*) begin
        case (aluc)
            // Arithmetic operations
            ADD, ADDU:  r = a + b;
            SUB, SUBU:  r = a - b;
            
            // Logical operations
            AND:  r = a & b;
            OR:   r = a | b;
            XOR:  r = a ^ b;
            NOR:  r = ~(a | b);
            
            // Comparison operations
            SLT:  r = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;
            SLTU: r = (a < b) ? 32'd1 : 32'd0;
            
            // Shift operations
            SLL, SLLV:  r = b << shift_amount;
            SRL, SRLV:  r = b >> shift_amount;
            SRA, SRAV:  r = $signed(b) >>> shift_amount;
            
            // Immediate operation
            LUI:  r = {b[15:0], 16'b0};
            
            // Default case
            default: r = 32'bz;
        endcase
    end

    // Arithmetic result for flags (computed only when needed)
    assign arith_result = (aluc == ADD || aluc == ADDU) ? {1'b0, a} + {1'b0, b} : 
                         (aluc == SUB || aluc == SUBU) ? {1'b0, a} - {1'b0, b} : 33'b0;

    // Flag generation
    assign zero = (r == 32'b0);
    assign negative = r[31];
    assign carry = is_arith ? arith_result[32] : 1'b0;
    assign overflow = (aluc == ADD) ? (a[31] == b[31] && r[31] != a[31]) :
                    (aluc == SUB) ? (a[31] != b[31] && r[31] == b[31]) : 1'b0;
    assign flag = (aluc == SLT || aluc == SLTU) ? r[0] : 1'b0;

endmodule