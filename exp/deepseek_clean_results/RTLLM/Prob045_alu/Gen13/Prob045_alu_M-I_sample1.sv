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

    // Operation group detection
    wire arith_op = (aluc == ADD) | (aluc == ADDU) | (aluc == SUB) | (aluc == SUBU);
    wire logic_op = (aluc == AND) | (aluc == OR) | (aluc == XOR) | (aluc == NOR);
    wire shift_op = (aluc == SLL) | (aluc == SRL) | (aluc == SRA) | 
                   (aluc == SLLV) | (aluc == SRLV) | (aluc == SRAV);
    wire comp_op = (aluc == SLT) | (aluc == SLTU);

    // Shared Arithmetic Unit
    wire add_sub = (aluc == SUB) | (aluc == SUBU);
    wire [32:0] arith_result;
    assign arith_result = add_sub ? ({1'b0, a} - {1'b0, b}) : ({1'b0, a} + {1'b0, b});

    // Unified Logic Unit
    reg [31:0] logic_result;
    always @(*) begin
        case (aluc[1:0])
            2'b00: logic_result = a & b;
            2'b01: logic_result = a | b;
            2'b10: logic_result = a ^ b;
            2'b11: logic_result = ~(a | b);
        endcase
    end

    // Barrel Shifter Unit
    wire [4:0] shift_amt = (aluc[3]) ? a[4:0] : b[4:0];
    wire [31:0] shift_result;
    assign shift_result = 
        (aluc[1:0] == 2'b00) ? (b << shift_amt) :             // SLL/SLLV
        (aluc[1:0] == 2'b10) ? (b >> shift_amt) :             // SRL/SRLV
        ($signed(b) >>> shift_amt);                           // SRA/SRAV

    // Comparison Unit
    wire comp_result = (aluc == SLT) ? ($signed(a) < $signed(b)) : (a < b);

    // LUI Operation
    wire [31:0] lui_result = {b[15:0], 16'b0};

    // First-stage result selection
    wire [31:0] stage1_result;
    assign stage1_result = 
        arith_op ? arith_result[31:0] :
        logic_op ? logic_result :
        shift_op ? shift_result :
        comp_op  ? {31'b0, comp_result} :
        lui_result;

    // Final result
    assign r = stage1_result;

    // Flag Generation
    assign zero = (stage1_result == 32'b0);
    assign negative = stage1_result[31];
    assign carry = arith_op ? arith_result[32] : 1'b0;
    
    wire add_overflow = (~a[31] & ~b[31] & stage1_result[31]) | 
                       (a[31] & b[31] & ~stage1_result[31]);
    wire sub_overflow = (~a[31] & b[31] & stage1_result[31]) | 
                       (a[31] & ~b[31] & ~stage1_result[31]);
    assign overflow = (aluc == ADD) ? add_overflow : 
                     (aluc == SUB) ? sub_overflow : 1'b0;
    
    assign flag = comp_op ? comp_result : 1'b0;

endmodule