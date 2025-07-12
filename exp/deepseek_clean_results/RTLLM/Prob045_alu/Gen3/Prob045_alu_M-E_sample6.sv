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

    // Pipeline stage 1: Operation decoding
    wire is_arith = (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU);
    wire is_logic = (aluc == AND || aluc == OR || aluc == XOR || aluc == NOR);
    wire is_shift = (aluc == SLL || aluc == SRL || aluc == SRA || 
                    aluc == SLLV || aluc == SRLV || aluc == SRAV);
    wire is_special = (aluc == SLT || aluc == SLTU || aluc == LUI);
    
    // Shift amount preparation
    wire [4:0] shamt = (aluc == SLLV || aluc == SRLV || aluc == SRAV) ? a[4:0] : b[4:0];
    wire [31:0] shift_operand = (aluc == SLLV || aluc == SRLV || aluc == SRAV) ? b : a;

    // Arithmetic pre-calculation
    wire [32:0] arith_sum = (aluc == ADD || aluc == ADDU) ? {1'b0, a} + {1'b0, b} : 
                                                           {1'b0, a} - {1'b0, b};
    wire arith_overflow = (aluc == ADD) ? (~a[31] & ~b[31] & arith_sum[31]) | 
                                        (a[31] & b[31] & ~arith_sum[31]) :
                         (aluc == SUB) ? (~a[31] & b[31] & arith_sum[31]) | 
                                        (a[31] & ~b[31] & ~arith_sum[31]) : 1'b0;

    // Pipeline stage 2: Operation execution
    reg [31:0] stage2_result;
    always @(*) begin
        case (1'b1)
            is_arith: stage2_result = arith_sum[31:0];
            is_logic: 
                case (aluc)
                    AND: stage2_result = a & b;
                    OR:  stage2_result = a | b;
                    XOR: stage2_result = a ^ b;
                    NOR: stage2_result = ~(a | b);
                    default: stage2_result = 32'b0;
                endcase
            is_shift:
                case (aluc)
                    SLL, SLLV: stage2_result = shift_operand << shamt;
                    SRL, SRLV: stage2_result = shift_operand >> shamt;
                    SRA, SRAV: stage2_result = $signed(shift_operand) >>> shamt;
                    default: stage2_result = 32'b0;
                endcase
            is_special:
                case (aluc)
                    SLT:  stage2_result = ($signed(a) < $signed(b)) ? 1 : 0;
                    SLTU: stage2_result = (a < b) ? 1 : 0;
                    LUI:  stage2_result = {b[15:0], 16'b0};
                    default: stage2_result = 32'b0;
                endcase
            default: stage2_result = 32'b0;
        endcase
    end

    // Pipeline stage 3: Result and flag generation
    always @(*) r = stage2_result;
    
    assign zero = (stage2_result == 32'b0);
    assign carry = (is_arith && (aluc == ADDU || aluc == SUBU)) ? arith_sum[32] : 1'b0;
    assign negative = stage2_result[31];
    assign overflow = is_arith ? arith_overflow : 1'b0;
    assign flag = (aluc == SLT) ? ($signed(a) < $signed(b)) :
                 (aluc == SLTU) ? (a < b) : 1'b0;

endmodule