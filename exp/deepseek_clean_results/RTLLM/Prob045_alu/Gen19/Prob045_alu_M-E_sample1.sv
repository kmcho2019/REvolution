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

    // Pipeline registers
    reg [31:0] stage1_out, stage2_out, stage3_out;
    reg stage1_zero, stage2_zero, stage3_zero;
    reg stage1_neg, stage2_neg, stage3_neg;
    reg stage1_carry, stage1_ovf;

    // Early zero prediction (bitwise OR reduction)
    wire zero_pred = ~(|a) | ~(|b);

    // Shared arithmetic unit
    wire [31:0] arith_b = (aluc == SUB || aluc == SUBU) ? ~b : b;
    wire [32:0] arith_full = {1'b0, a} + {1'b0, arith_b} + ((aluc == SUB || aluc == SUBU) ? 1 : 0);
    wire arith_ovf = (a[31] == arith_b[31]) && (arith_full[31] != a[31]);

    // Shared comparator
    wire signed_lt = $signed(a) < $signed(b);
    wire unsigned_lt = a < b;

    // Configurable shifter
    wire [4:0] shift_amt = aluc[3] ? a[4:0] : b[4:0];
    wire [31:0] shift_out = 
        (aluc[1:0] == 2'b00) ? b << shift_amt :
        (aluc[1:0] == 2'b10) ? b >> shift_amt :
        $signed(b) >>> shift_amt;

    // Pipeline Stage 1: Arithmetic operations
    always @(*) begin
        if (aluc[5:4] == 2'b10) begin // ADD/ADDU/SUB/SUBU
            stage1_out = arith_full[31:0];
            stage1_zero = zero_pred;
            stage1_neg = arith_full[31];
            stage1_carry = arith_full[32];
            stage1_ovf = (aluc[0] ? 1'b0 : arith_ovf); // Only for signed ops
        end else begin
            stage1_out = 32'b0;
            {stage1_zero, stage1_neg, stage1_carry, stage1_ovf} = 4'b0;
        end
    end

    // Pipeline Stage 2: Logical operations
    always @(*) begin
        case (aluc[3:0])
            4'b0100: stage2_out = a & b;  // AND
            4'b0101: stage2_out = a | b;  // OR
            4'b0110: stage2_out = a ^ b;  // XOR
            4'b0111: stage2_out = ~(a | b); // NOR
            default: stage2_out = stage1_out;
        endcase
        stage2_zero = ~(|stage2_out);
        stage2_neg = stage2_out[31];
    end

    // Pipeline Stage 3: Shift operations
    always @(*) begin
        if (aluc[5:3] == 3'b000) begin // All shifts
            stage3_out = shift_out;
            stage3_zero = ~(|shift_out);
            stage3_neg = shift_out[31];
        end else begin
            stage3_out = stage2_out;
            stage3_zero = stage2_zero;
            stage3_neg = stage2_neg;
        end
    end

    // Final output selection
    assign r = (aluc == LUI) ? {b[15:0], 16'b0} :
               (aluc == SLT) ? {31'b0, signed_lt} :
               (aluc == SLTU) ? {31'b0, unsigned_lt} :
               stage3_out;

    // Flag outputs
    assign zero = (aluc == SLT || aluc == SLTU) ? ~flag : 
                 (aluc == LUI) ? ~(|b[15:0]) : 
                 stage3_zero;
    assign carry = stage1_carry;
    assign negative = (aluc == SLT || aluc == SLTU) ? flag : 
                     (aluc == LUI) ? 1'b0 : 
                     stage3_neg;
    assign overflow = stage1_ovf;
    assign flag = (aluc == SLT) ? signed_lt :
                 (aluc == SLTU) ? unsigned_lt :
                 1'b0;

endmodule