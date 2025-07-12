module alu(
    input clk,          // Clock for pipelining
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
    reg [31:0] a_reg, b_reg;
    reg [5:0] aluc_reg;
    reg [31:0] stage1_result;
    reg stage1_zero, stage1_carry, stage1_negative, stage1_overflow, stage1_flag;

    // Operation prediction (simple last-operation predictor)
    reg [5:0] last_op;
    wire predicted_arith = (last_op >= ADD && last_op <= SUBU);
    wire predicted_logic = (last_op >= AND && last_op <= NOR);
    wire predicted_shift = (last_op >= SLL && last_op <= SRAV);

    // Speculative execution units (clock gated based on prediction)
    wire [32:0] spec_arith_result = predicted_arith ? 
        ((aluc == SUB || aluc == SUBU) ? ({1'b0, a} - {1'b0, b}) : ({1'b0, a} + {1'b0, b})) : 
        33'b0;
    
    wire [31:0] spec_logic_result;
    always @(*) begin
        if (predicted_logic) begin
            case (last_op[1:0])
                2'b00: spec_logic_result = a & b;
                2'b01: spec_logic_result = a | b;
                2'b10: spec_logic_result = a ^ b;
                2'b11: spec_logic_result = ~(a | b);
            endcase
        end else begin
            spec_logic_result = 32'b0;
        end
    end

    wire [31:0] spec_shift_result = predicted_shift ? 
        ((aluc[1:0] == 2'b00) ? (b << a[4:0]) :
        ((aluc[1:0] == 2'b10) ? (b >> a[4:0]) :
        ($signed(b) >>> a[4:0]) : 32'b0;

    // Pipeline Stage 1: Decode and prepare
    always @(posedge clk) begin
        a_reg <= a;
        b_reg <= b;
        aluc_reg <= aluc;
        last_op <= aluc;
    end

    // Pipeline Stage 2: Execute and select
    always @(posedge clk) begin
        case (aluc_reg)
            ADD, ADDU, SUB, SUBU: begin
                r <= spec_arith_result[31:0];
                carry <= spec_arith_result[32];
                // Overflow detection
                if (aluc_reg == ADD) begin
                    overflow <= (~a_reg[31] & ~b_reg[31] & r[31]) | 
                               (a_reg[31] & b_reg[31] & ~r[31]);
                end else if (aluc_reg == SUB) begin
                    overflow <= (~a_reg[31] & b_reg[31] & r[31]) | 
                               (a_reg[31] & ~b_reg[31] & ~r[31]);
                end else begin
                    overflow <= 1'b0;
                end
            end
            AND, OR, XOR, NOR: begin
                r <= spec_logic_result;
                carry <= 1'b0;
                overflow <= 1'b0;
            end
            SLT: begin
                r <= {31'b0, $signed(a_reg) < $signed(b_reg)};
                carry <= 1'b0;
                overflow <= 1'b0;
            end
            SLTU: begin
                r <= {31'b0, a_reg < b_reg};
                carry <= 1'b0;
                overflow <= 1'b0;
            end
            SLL, SRL, SRA, SLLV, SRLV, SRAV: begin
                r <= spec_shift_result;
                carry <= 1'b0;
                overflow <= 1'b0;
            end
            LUI: begin
                r <= {b_reg[15:0], 16'b0};
                carry <= 1'b0;
                overflow <= 1'b0;
            end
            default: begin
                r <= 32'b0;
                carry <= 1'b0;
                overflow <= 1'b0;
            end
        endcase

        // Common flag calculations
        zero <= (r == 32'b0);
        negative <= r[31];
        flag <= (aluc_reg == SLT || aluc_reg == SLTU) ? r[0] : 1'b0;
    end

endmodule