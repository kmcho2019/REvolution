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
    reg [4:0] stage1_shift_amt;

    // Operation detection (combinational)
    wire is_add  = (aluc == ADD || aluc == ADDU);
    wire is_sub  = (aluc == SUB || aluc == SUBU);
    wire is_arith = is_add || is_sub;
    wire is_logic = (aluc == AND || aluc == OR || aluc == XOR || aluc == NOR);
    wire is_shift = (aluc == SLL || aluc == SRL || aluc == SRA || 
                    aluc == SLLV || aluc == SRLV || aluc == SRAV);
    wire is_comp = (aluc == SLT || aluc == SLTU);
    wire is_lui = (aluc == LUI);

    // Stage 1: Decode and Prepare
    always @(posedge clk) begin
        stage1_a <= a;
        stage1_b <= b;
        stage1_aluc <= aluc;
        
        // Calculate shift amount in parallel
        stage1_shift_amt <= (aluc == SLLV || aluc == SRLV || aluc == SRAV) ? 
                           a[4:0] : b[4:0];
    end

    // Stage 2: Execute
    always @(posedge clk) begin
        // Arithmetic Unit with carry-save optimization
        reg [32:0] arith_result;
        arith_result = {1'b0, stage1_a} + 
                      {1'b0, (stage1_aluc[0] ? ~stage1_b : stage1_b)} + 
                      {32'b0, (stage1_aluc[1] && !stage1_aluc[0])};

        // Logarithmic Barrel Shifter
        reg [31:0] shift_result;
        integer i;
        shift_result = stage1_b;
        for (i = 0; i < 5; i = i+1) begin
            if (stage1_shift_amt[i]) begin
                case (stage1_aluc[2:0])
                    3'b000: shift_result = shift_result << (1<<i);  // SLL
                    3'b010: shift_result = shift_result >> (1<<i);  // SRL
                    3'b011: shift_result = $signed(shift_result) >>> (1<<i); // SRA
                endcase
            end
        end

        // Logic Unit
        reg [31:0] logic_result;
        case (stage1_aluc[2:0])
            3'b100: logic_result = stage1_a & stage1_b;  // AND
            3'b101: logic_result = stage1_a | stage1_b;  // OR
            3'b110: logic_result = stage1_a ^ stage1_b;  // XOR
            3'b111: logic_result = ~(stage1_a | stage1_b); // NOR
            default: logic_result = 32'b0;
        endcase

        // Result Selection with operation-aware forwarding
        case (1'b1)
            is_arith: r <= arith_result[31:0];
            is_logic: r <= logic_result;
            is_shift: r <= shift_result;
            is_comp: r <= {31'b0, 
                          (stage1_aluc[0] ? (stage1_a < stage1_b) : 
                          ($signed(stage1_a) < $signed(stage1_b)))};
            is_lui: r <= {stage1_b[15:0], 16'b0};
            default: r <= 32'b0;
        endcase

        // Flag Generation
        zero <= (r == 32'b0);
        carry <= is_arith ? arith_result[32] : 1'b0;
        negative <= r[31];
        overflow <= (stage1_aluc == ADD || stage1_aluc == SUB) ? 
                   ((stage1_a[31] == stage1_b[31] ^ stage1_aluc[1]) && 
                    (r[31] != stage1_a[31])) : 1'b0;
        flag <= is_comp ? r[0] : 1'b0;
    end

endmodule