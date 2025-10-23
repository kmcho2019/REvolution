module adder_pipe_64bit (
    input  wire         clk,
    input  wire         rst_n,
    input  wire         i_en,
    input  wire [63:0]  adda,
    input  wire [63:0]  addb,
    output reg  [64:0]  result,
    output reg          o_en
);

    // Pipeline registers to hold slices of inputs per stage
    reg [15:0] a_stage0, b_stage0;
    reg [15:0] a_stage1, b_stage1;
    reg [15:0] a_stage2, b_stage2;
    reg [15:0] a_stage3, b_stage3;

    // Pipeline registers to hold carries between stages
    reg carry_stage0;
    reg carry_stage1;
    reg carry_stage2;
    reg carry_stage3;

    // Sum outputs per stage (16 bits sum + carry out)
    reg [16:0] sum_stage0;
    reg [16:0] sum_stage1;
    reg [16:0] sum_stage2;
    reg [16:0] sum_stage3;

    // Pipeline registers for enable signal
    reg i_en_d1, i_en_d2, i_en_d3, i_en_d4;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_stage0 <= 16'd0;
            b_stage0 <= 16'd0;
            a_stage1 <= 16'd0;
            b_stage1 <= 16'd0;
            a_stage2 <= 16'd0;
            b_stage2 <= 16'd0;
            a_stage3 <= 16'd0;
            b_stage3 <= 16'd0;

            carry_stage0 <= 1'b0;
            carry_stage1 <= 1'b0;
            carry_stage2 <= 1'b0;
            carry_stage3 <= 1'b0;

            sum_stage0 <= 17'd0;
            sum_stage1 <= 17'd0;
            sum_stage2 <= 17'd0;
            sum_stage3 <= 17'd0;

            i_en_d1 <= 1'b0;
            i_en_d2 <= 1'b0;
            i_en_d3 <= 1'b0;
            i_en_d4 <= 1'b0;

            result <= 65'd0;
            o_en <= 1'b0;
        end else begin
            // Pipeline the enable signal through 4 cycles
            i_en_d1 <= i_en;
            i_en_d2 <= i_en_d1;
            i_en_d3 <= i_en_d2;
            i_en_d4 <= i_en_d3;

            // Stage 0: latch lower 16 bits and add with carry 0
            if (i_en) begin
                a_stage0 <= adda[15:0];
                b_stage0 <= addb[15:0];
                carry_stage0 <= 1'b0; // initial carry in zero
            end
            sum_stage0 <= {1'b0, a_stage0} + {1'b0, b_stage0} + carry_stage0;

            // Stage 1: latch next 16 bits and add with carry from stage0
            if (i_en_d1) begin
                a_stage1 <= adda[31:16];
                b_stage1 <= addb[31:16];
                carry_stage1 <= sum_stage0[16];
            end
            sum_stage1 <= {1'b0, a_stage1} + {1'b0, b_stage1} + carry_stage1;

            // Stage 2: latch next 16 bits and add with carry from stage1
            if (i_en_d2) begin
                a_stage2 <= adda[47:32];
                b_stage2 <= addb[47:32];
                carry_stage2 <= sum_stage1[16];
            end
            sum_stage2 <= {1'b0, a_stage2} + {1'b0, b_stage2} + carry_stage2;

            // Stage 3: latch highest 16 bits and add with carry from stage2
            if (i_en_d3) begin
                a_stage3 <= adda[63:48];
                b_stage3 <= addb[63:48];
                carry_stage3 <= sum_stage2[16];
            end
            sum_stage3 <= {1'b0, a_stage3} + {1'b0, b_stage3} + carry_stage3;

            // Assemble final result and output enable after 4 cycles
            if (i_en_d4) begin
                result <= {sum_stage3[16], sum_stage3[15:0], sum_stage2[15:0], sum_stage1[15:0], sum_stage0[15:0]};
            end

            o_en <= i_en_d4;
        end
    end

endmodule