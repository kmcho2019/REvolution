module alu(
    input clk,          // Added for pipelining
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
    
    // Operation grouping signals
    wire is_arith = (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU);
    wire is_logic = (aluc == AND || aluc == OR || aluc == XOR || aluc == NOR);
    wire is_shift = (aluc == SLL || aluc == SRL || aluc == SRA || 
                    aluc == SLLV || aluc == SRLV || aluc == SRAV);
    wire is_comp = (aluc == SLT || aluc == SLTU);
    
    // Operation-specific enables
    wire arith_en = is_arith;
    wire logic_en = is_logic;
    wire shift_en = is_shift;
    wire comp_en = is_comp;
    wire lui_en = (aluc == LUI);

    // Unified barrel shifter
    wire [4:0] shift_amount = (aluc[2:0] == 3'b100) ? a[4:0] : b[4:0];
    wire [31:0] shift_in = b;
    wire [1:0] shift_mode = 
        (aluc == SLL || aluc == SLLV) ? 2'b00 :
        (aluc == SRL || aluc == SRLV) ? 2'b01 : 2'b10;
    
    reg [31:0] barrel_shift_result;
    always @(*) begin
        case(shift_mode)
            2'b00: barrel_shift_result = shift_in << shift_amount;
            2'b01: barrel_shift_result = shift_in >> shift_amount;
            2'b10: barrel_shift_result = $signed(shift_in) >>> shift_amount;
            default: barrel_shift_result = 32'b0;
        endcase
    end

    // Optimized arithmetic unit
    wire [31:0] arith_b = (aluc[1]) ? ~b : b;
    wire [31:0] arith_sum = a + arith_b + aluc[1];
    wire arith_carry = (a[31] & arith_b[31]) | 
                      ((a[31] ^ arith_b[31]) & ~arith_sum[31]);
    
    // Simplified overflow detection
    wire arith_overflow = (a[31] == arith_b[31]) && (a[31] != arith_sum[31]);

    // Shared comparator
    wire signed [31:0] a_signed = a;
    wire signed [31:0] b_signed = b;
    wire comp_result = (aluc[0]) ? (a < b) : (a_signed < b_signed);

    // Pipeline stage 1
    always @(posedge clk) begin
        stage1_a <= a;
        stage1_b <= b;
        stage1_aluc <= aluc;
    end

    // Pipeline stage 2 (result computation)
    always @(posedge clk) begin
        case(stage1_aluc)
            ADD, ADDU, SUB, SUBU: begin
                r <= arith_sum;
                carry <= arith_carry;
                overflow <= arith_overflow;
            end
            AND:    r <= stage1_a & stage1_b;
            OR:     r <= stage1_a | stage1_b;
            XOR:    r <= stage1_a ^ stage1_b;
            NOR:    r <= ~(stage1_a | stage1_b);
            SLT, SLTU: r <= {31'b0, comp_result};
            SLL, SRL, SRA, SLLV, SRLV, SRAV: r <= barrel_shift_result;
            LUI:    r <= {stage1_b[15:0], 16'b0};
            default: r <= 32'b0;
        endcase
        
        // Flag generation
        zero <= (r == 32'b0);
        negative <= r[31];
        flag <= (stage1_aluc == SLT || stage1_aluc == SLTU) ? r[0] : 1'b0;
    end

endmodule