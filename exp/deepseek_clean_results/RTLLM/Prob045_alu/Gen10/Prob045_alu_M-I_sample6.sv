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

    // Operation classification
    wire is_arith = (aluc == ADD) || (aluc == ADDU) || (aluc == SUB) || (aluc == SUBU);
    wire is_logic = (aluc == AND) || (aluc == OR) || (aluc == XOR) || (aluc == NOR);
    wire is_shift = (aluc == SLL) || (aluc == SRL) || (aluc == SRA) || 
                   (aluc == SLLV) || (aluc == SRLV) || (aluc == SRAV);
    wire is_comp = (aluc == SLT) || (aluc == SLTU);

    // Optimized carry-lookahead adder
    wire [31:0] b_operand = (aluc[0] ? ~b : b);  // Invert for subtraction
    wire [32:0] adder_result;
    assign adder_result = {1'b0, a} + {1'b0, b_operand} + aluc[0];

    // Logarithmic barrel shifter
    wire [4:0] shift_amount = (aluc[2:0] == 3'b100) ? a[4:0] : b[4:0];
    wire [31:0] shifted_val;
    
    // First stage: shift by 0/1/2/4/8/16
    wire [31:0] stage1 = (shift_amount[0]) ? (aluc[1] ? {b[31], b[31:1]} : {b[30:0], 1'b0}) : b;
    wire [31:0] stage2 = (shift_amount[1]) ? (aluc[1] ? {{2{stage1[31]}}, stage1[31:2]} : {stage1[29:0], 2'b0}) : stage1;
    wire [31:0] stage3 = (shift_amount[2]) ? (aluc[1] ? {{4{stage2[31]}}, stage2[31:4]} : {stage2[27:0], 4'b0}) : stage2;
    wire [31:0] stage4 = (shift_amount[3]) ? (aluc[1] ? {{8{stage3[31]}}, stage3[31:8]} : {stage3[23:0], 8'b0}) : stage3;
    assign shifted_val = (shift_amount[4]) ? (aluc[1] ? {{16{stage4[31]}}, stage4[31:16]} : {stage4[15:0], 16'b0}) : stage4;

    // Shared comparator using adder result
    wire signed [31:0] a_signed = a;
    wire signed [31:0] b_signed = b;
    wire comp_result = (aluc == SLTU) ? (a < b) : (a_signed < b_signed);

    always @(*) begin
        flag = 1'b0;  // Default value
        case (1'b1)  // Priority encoder style
            is_arith: r = adder_result[31:0];
            is_logic: begin
                case (aluc[1:0])
                    2'b00: r = a & b;
                    2'b01: r = a | b;
                    2'b10: r = a ^ b;
                    2'b11: r = ~(a | b);
                endcase
            end
            is_comp: begin 
                r = {31'b0, comp_result}; 
                flag = comp_result; 
            end
            (aluc == LUI): r = {b[15:0], 16'b0};
            is_shift: r = shifted_val;
            default: r = 32'b0;
        endcase
    end

    // Optimized flag outputs
    assign zero = (r == 32'b0);
    assign carry = is_arith ? adder_result[32] : 1'b0;
    assign negative = r[31];
    assign overflow = ((aluc == ADD) || (aluc == SUB)) ? 
                    (adder_result[32] ^ adder_result[31]) : 1'b0;

endmodule