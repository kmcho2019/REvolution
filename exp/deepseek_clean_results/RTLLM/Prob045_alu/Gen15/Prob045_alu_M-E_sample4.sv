module alu(
    input clk,          // Clock for pipelining
    input reset,        // Reset signal
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output reg [31:0] r,
    output reg zero,
    output reg carry,
    output reg negative,
    output reg overflow,
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

    // Pipeline registers
    reg [31:0] stage1_a, stage1_b;
    reg [5:0] stage1_aluc;
    reg [31:0] stage2_result;
    reg stage2_zero, stage2_carry, stage2_negative, stage2_overflow, stage2_flag;

    // Operation classification
    wire is_arith = |{aluc == ADD, aluc == ADDU, aluc == SUB, aluc == SUBU};
    wire is_logic = |{aluc == AND, aluc == OR, aluc == XOR, aluc == NOR};
    wire is_shift = |{aluc == SLL, aluc == SRL, aluc == SRA, 
                     aluc == SLLV, aluc == SRLV, aluc == SRAV};
    wire is_comp = |{aluc == SLT, aluc == SLTU};
    wire is_lui = (aluc == LUI);

    // Stage 1: Input preparation
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            stage1_a <= 32'b0;
            stage1_b <= 32'b0;
            stage1_aluc <= 6'b0;
        end else begin
            stage1_a <= a;
            stage1_b <= b;
            stage1_aluc <= aluc;
        end
    end

    // Stage 2: Parallel execution units
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            stage2_result <= 32'b0;
            {stage2_zero, stage2_carry, stage2_negative, stage2_overflow, stage2_flag} <= 5'b0;
        end else begin
            // Default values
            stage2_result <= 32'b0;
            stage2_zero <= 1'b0;
            stage2_carry <= 1'b0;
            stage2_negative <= 1'b0;
            stage2_overflow <= 1'b0;
            stage2_flag <= 1'b0;

            // Arithmetic Unit (Hybrid CLA/CS)
            if (is_arith) begin
                wire add_sub = |{stage1_aluc == SUB, stage1_aluc == SUBU};
                wire [31:0] arith_b = add_sub ? ~stage1_b : stage1_b;
                wire [32:0] full_result = {1'b0, stage1_a} + {1'b0, arith_b} + {31'b0, add_sub};
                
                stage2_result <= full_result[31:0];
                stage2_carry <= full_result[32];
                
                // Overflow detection
                if (stage1_aluc == ADD || stage1_aluc == SUB) begin
                    stage2_overflow <= 
                        (~stage1_a[31] & ~arith_b[31] & full_result[31]) |
                        (stage1_a[31] & arith_b[31] & ~full_result[31]);
                end
            end

            // Logic Unit
            else if (is_logic) begin
                case (stage1_aluc[1:0])
                    2'b00: stage2_result <= stage1_a & stage1_b;
                    2'b01: stage2_result <= stage1_a | stage1_b;
                    2'b10: stage2_result <= stage1_a ^ stage1_b;
                    2'b11: stage2_result <= ~(stage1_a | stage1_b);
                endcase
            end

            // Shift/Compare Unit
            else if (is_shift || is_comp) begin
                if (is_shift) begin
                    wire [4:0] shift_amt = (stage1_aluc[3]) ? stage1_a[4:0] : stage1_b[4:0];
                    case (stage1_aluc[2:0])
                        3'b000: stage2_result <= stage1_b << shift_amt;  // SLL/SLLV
                        3'b010: stage2_result <= stage1_b >> shift_amt;  // SRL/SRLV
                        3'b011: stage2_result <= $signed(stage1_b) >>> shift_amt; // SRA/SRAV
                    endcase
                end else begin
                    // Comparison operations
                    stage2_result <= {31'b0, 
                        (stage1_aluc == SLT) ? ($signed(stage1_a) < $signed(stage1_b)) :
                        (stage1_a < stage1_b)};
                    stage2_flag <= 1'b1;
                end
            end

            // LUI operation
            else if (is_lui) begin
                stage2_result <= {stage1_b[15:0], 16'b0};
            end
        end
    end

    // Stage 3: Flag generation and output
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            r <= 32'b0;
            {zero, carry, negative, overflow, flag} <= 5'b0;
        end else begin
            r <= stage2_result;
            zero <= (stage2_result == 32'b0);
            carry <= stage2_carry;
            negative <= stage2_result[31];
            overflow <= stage2_overflow;
            flag <= stage2_flag;
        end
    end

endmodule