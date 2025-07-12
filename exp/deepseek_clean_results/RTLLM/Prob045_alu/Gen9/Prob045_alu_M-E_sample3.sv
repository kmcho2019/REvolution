module alu(
    input clk,
    input rst,
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
    wire is_arith = (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU);
    wire is_logic = (aluc == AND || aluc == OR || aluc == XOR || aluc == NOR);
    wire is_shift = (aluc == SLL || aluc == SRL || aluc == SRA || 
                    aluc == SLLV || aluc == SRLV || aluc == SRAV);
    wire is_compare = (aluc == SLT || aluc == SLTU);
    wire is_lui = (aluc == LUI);

    // Hybrid adder (4-bit carry-lookahead groups with carry-select between groups)
    wire [31:0] arith_result;
    wire arith_carry, arith_overflow;
    
    genvar i;
    generate
        for (i = 0; i < 8; i = i+1) begin: adder_block
            wire [3:0] a_seg = stage1_a[(i*4)+3:i*4];
            wire [3:0] b_seg = stage1_b[(i*4)+3:i*4];
            wire cin = (i == 0) ? (stage1_aluc == SUB || stage1_aluc == SUBU) : 
                       adder_block[i-1].cout;
            
            wire [3:0] sum;
            wire g, p, cout;
            
            // Carry-lookahead within 4-bit block
            assign g = (a_seg & b_seg) != 0;
            assign p = (a_seg | b_seg) != 0;
            assign sum = a_seg ^ b_seg ^ {4{cin}};
            assign cout = g | (p & cin);
            
            assign arith_result[(i*4)+3:i*4] = sum;
            
            if (i == 7) begin
                assign arith_carry = cout;
                assign arith_overflow = adder_block[6].cout ^ cout;
            end
        end
    endgenerate

    // Logarithmic shifter with power gating
    wire [31:0] shift_result;
    wire [4:0] shift_amt = (stage1_aluc[3:1] == 3'b000) ? stage1_a[4:0] : stage1_b[4:0];
    
    generate
        if (is_shift) begin
            // 5-stage logarithmic shifter
            wire [31:0] shift_stage1 = shift_amt[0] ? 
                (stage1_aluc[0] ? {stage1_b[30:0], 1'b0} : 
                 stage1_aluc[1] ? {1'b0, stage1_b[31:1]} : 
                 {stage1_b[31], stage1_b[31:1]}) : stage1_b;
            
            wire [31:0] shift_stage2 = shift_amt[1] ? 
                (stage1_aluc[0] ? {shift_stage1[29:0], 2'b0} : 
                 stage1_aluc[1] ? {2'b0, shift_stage1[31:2]} : 
                 {{2{shift_stage1[31]}}, shift_stage1[31:2]}) : shift_stage1;
            
            wire [31:0] shift_stage4 = shift_amt[2] ? 
                (stage1_aluc[0] ? {shift_stage2[27:0], 4'b0} : 
                 stage1_aluc[1] ? {4'b0, shift_stage2[31:4]} : 
                 {{4{shift_stage2[31]}}, shift_stage2[31:4]}) : shift_stage2;
            
            wire [31:0] shift_stage8 = shift_amt[3] ? 
                (stage1_aluc[0] ? {shift_stage4[23:0], 8'b0} : 
                 stage1_aluc[1] ? {8'b0, shift_stage4[31:8]} : 
                 {{8{shift_stage4[31]}}, shift_stage4[31:8]}) : shift_stage4;
            
            assign shift_result = shift_amt[4] ? 
                (stage1_aluc[0] ? {shift_stage8[15:0], 16'b0} : 
                 stage1_aluc[1] ? {16'b0, shift_stage8[31:16]} : 
                 {{16{shift_stage8[31]}}, shift_stage8[31:16]}) : shift_stage8;
        end else begin
            assign shift_result = 32'b0;
        end
    endgenerate

    // Stage 1: Operation decode and operand preparation
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage1_a <= 32'b0;
            stage1_b <= 32'b0;
            stage1_aluc <= 6'b0;
        end else begin
            stage1_a <= a;
            stage1_b <= (aluc == SUB || aluc == SUBU) ? ~b : b;
            stage1_aluc <= aluc;
        end
    end

    // Stage 2: Execution and flag generation
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage2_result <= 32'b0;
            stage2_zero <= 1'b0;
            stage2_carry <= 1'b0;
            stage2_negative <= 1'b0;
            stage2_overflow <= 1'b0;
            stage2_flag <= 1'b0;
        end else begin
            case (stage1_aluc)
                ADD, ADDU, SUB, SUBU: begin
                    stage2_result <= arith_result;
                    stage2_carry <= arith_carry;
                    stage2_overflow <= (stage1_aluc == ADD || stage1_aluc == SUB) ? 
                                      arith_overflow : 1'b0;
                end
                AND:       stage2_result <= stage1_a & stage1_b;
                OR:        stage2_result <= stage1_a | stage1_b;
                XOR:       stage2_result <= stage1_a ^ stage1_b;
                NOR:       stage2_result <= ~(stage1_a | stage1_b);
                SLT:       begin 
                    stage2_result <= {31'b0, $signed(stage1_a) < $signed(stage1_b)};
                    stage2_flag <= $signed(stage1_a) < $signed(stage1_b);
                end
                SLTU:      begin 
                    stage2_result <= {31'b0, stage1_a < stage1_b};
                    stage2_flag <= stage1_a < stage1_b;
                end
                SLL, SLLV, SRL, SRLV, SRA, SRAV: 
                    stage2_result <= shift_result;
                LUI:       stage2_result <= {stage1_b[15:0], 16'b0};
                default:   stage2_result <= 32'b0;
            endcase
            
            stage2_zero <= ~|stage2_result;
            stage2_negative <= stage2_result[31];
        end
    end

    // Output assignments
    always @(*) begin
        r = stage2_result;
        zero = stage2_zero;
        carry = stage2_carry;
        negative = stage2_negative;
        overflow = stage2_overflow;
        flag = stage2_flag;
    end

endmodule