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

    // Operation codes (same as before)
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

    // Pipeline registers
    reg [31:0] pipe_stage1;
    reg [31:0] pipe_stage2;
    reg pipe_carry, pipe_overflow;

    // Operation classification
    wire is_arith = (aluc == ADD) | (aluc == ADDU) | (aluc == SUB) | (aluc == SUBU);
    wire is_logic = (aluc == AND) | (aluc == OR) | (aluc == XOR) | (aluc == NOR);
    wire is_shift = (aluc == SLL) | (aluc == SRL) | (aluc == SRA) | 
                   (aluc == SLLV) | (aluc == SRLV) | (aluc == SRAV);
    wire is_comp = (aluc == SLT) | (aluc == SLTU);

    // Dynamic Arithmetic/Comparison Unit
    wire [32:0] arith_result;
    wire do_sub = (aluc == SUB) | (aluc == SUBU);
    assign arith_result = do_sub ? ({1'b0, a} - {1'b0, b}) : ({1'b0, a} + {1'b0, b});

    // Predictive Flag Generation
    wire predicted_zero = (arith_result[31:0] == 32'b0);
    wire predicted_neg = arith_result[31];
    wire predicted_carry = arith_result[32];
    wire predicted_overflow = (aluc == ADD) ? (~a[31] & ~b[31] & arith_result[31]) | 
                                              (a[31] & b[31] & ~arith_result[31]) :
                             (aluc == SUB) ? (~a[31] & b[31] & arith_result[31]) | 
                                              (a[31] & ~b[31] & ~arith_result[31]) : 1'b0;

    // Configurable Logic Unit
    wire [31:0] logic_result;
    assign logic_result = (aluc == AND) ? (a & b) :
                         (aluc == OR)  ? (a | b) :
                         (aluc == XOR) ? (a ^ b) :
                         (aluc == NOR) ? ~(a | b) : 32'b0;

    // Universal Shifter
    wire [4:0] shift_amount = (aluc[3]) ? a[4:0] : b[4:0];
    wire [31:0] shift_result;
    assign shift_result = (aluc == SLL || aluc == SLLV) ? (b << shift_amount) :
                         (aluc == SRL || aluc == SRLV) ? (b >> shift_amount) :
                         ($signed(b) >>> shift_amount);

    // Comparison Result
    wire comp_result = (aluc == SLT) ? ($signed(a) < $signed(b)) : (a < b);

    // Pipeline Stage 1
    always @(*) begin
        if (is_arith) begin
            pipe_stage1 = arith_result[31:0];
            pipe_carry = predicted_carry;
            pipe_overflow = predicted_overflow;
        end
        else if (is_logic) begin
            pipe_stage1 = logic_result;
        end
        else if (is_shift) begin
            pipe_stage1 = shift_result;
        end
        else if (is_comp) begin
            pipe_stage1 = {31'b0, comp_result};
        end
        else if (aluc == LUI) begin
            pipe_stage1 = {b[15:0], 16'b0};
        end
        else begin
            pipe_stage1 = 32'b0;
        end
    end

    // Pipeline Stage 2 (Result Formation)
    always @(*) begin
        r = pipe_stage1;
    end

    // Output Flags
    assign zero = (r == 32'b0);
    assign negative = r[31];
    assign carry = is_arith ? pipe_carry : 1'b0;
    assign overflow = is_arith ? pipe_overflow : 1'b0;
    assign flag = is_comp ? comp_result : 1'b0;

    // Power Gating Control (conceptual)
    // In real implementation would use power gating cells
    wire arith_pg = ~is_arith;
    wire logic_pg = ~is_logic;
    wire shift_pg = ~is_shift;

endmodule