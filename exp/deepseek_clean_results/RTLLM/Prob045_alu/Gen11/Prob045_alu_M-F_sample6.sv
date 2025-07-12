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
    wire [4:0] shift_amount = (aluc[3] && aluc[1:0] != 2'b00) ? a[4:0] : b[4:0]; // SLLV/SRLV/SRAV share same mux
    
    // Shared arithmetic logic
    wire do_add = (aluc == ADD || aluc == ADDU);
    wire do_sub = (aluc == SUB || aluc == SUBU);
    wire [32:0] arith_result = do_add ? ({1'b0, a} + {1'b0, b}) : 
                                do_sub ? ({1'b0, a} - {1'b0, b}) : 
                                33'b0;
    
    // Shift operations (computed only when needed)
    reg [31:0] shift_result;
    always @(*) begin
        if (aluc[5:3] == 3'b000) begin // Shift operations
            case (aluc[2:0])
                3'b000: shift_result = b << shift_amount;  // SLL/SLLV
                3'b010: shift_result = b >> shift_amount;  // SRL/SRLV
                3'b011: shift_result = $signed(b) >>> shift_amount; // SRA/SRAV
                default: shift_result = 32'b0;
            endcase
        end
    end
    
    // Comparison operations (computed only when needed)
    reg cmp_result;
    always @(*) begin
        if (aluc == SLT) begin
            cmp_result = a_signed < b_signed;
        end
        else if (aluc == SLTU) begin
            cmp_result = a < b;
        end
    end
    
    // Logical operations
    reg [31:0] logic_result;
    always @(*) begin
        case (aluc[2:0])
            3'b100: logic_result = a & b;  // AND
            3'b101: logic_result = a | b;  // OR
            3'b110: logic_result = a ^ b;  // XOR
            3'b111: logic_result = ~(a | b); // NOR
            default: logic_result = 32'b0;
        endcase
    end
    
    // Result selection
    assign r = (aluc == LUI) ? {b[15:0], 16'b0} :
               (aluc == SLT || aluc == SLTU) ? {31'b0, cmp_result} :
               (aluc[5:3] == 3'b100) ? arith_result[31:0] : // Arithmetic
               (aluc[5:3] == 3'b000) ? shift_result : // Shift
               logic_result; // Logical
    
    // Flag generation
    assign zero = (r == 32'b0);
    assign carry = (do_add || do_sub) ? arith_result[32] : 1'b0;
    assign negative = r[31];
    assign overflow = (aluc == ADD) ? (~a[31] & ~b[31] & r[31]) | (a[31] & b[31] & ~r[31]) :
                      (aluc == SUB) ? (~a[31] & b[31] & r[31]) | (a[31] & ~b[31] & ~r[31]) :
                      1'b0;
    assign flag = (aluc == SLT || aluc == SLTU) ? cmp_result : 1'b0;

endmodule