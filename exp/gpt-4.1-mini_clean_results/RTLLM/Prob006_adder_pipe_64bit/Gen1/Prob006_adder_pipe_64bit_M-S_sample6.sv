module adder_pipe_64bit (
    input              clk,
    input              rst_n,
    input              i_en,
    input      [63:0]  adda,
    input      [63:0]  addb,
    output reg [64:0]  result,
    output reg         o_en
);

localparam STAGE_NUM = 4;
localparam STAGE_WIDTH = 16;

// Stage registers for operands, sums and carry signals
reg [STAGE_WIDTH-1:0] a_reg [0:STAGE_NUM-1];
reg [STAGE_WIDTH-1:0] b_reg [0:STAGE_NUM-1];
reg [STAGE_WIDTH-1:0] sum_reg [0:STAGE_NUM-1];
reg carry_reg [0:STAGE_NUM];        // carry_reg[0] is initial carry-in (0)

reg en_pipe [0:STAGE_NUM];          // pipeline enable signals

integer i;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all pipeline registers and outputs
        for (i = 0; i < STAGE_NUM; i = i + 1) begin
            a_reg[i] <= 0;
            b_reg[i] <= 0;
            sum_reg[i] <= 0;
            carry_reg[i] <= 0;
            en_pipe[i] <= 0;
        end
        carry_reg[STAGE_NUM] <= 0;
        en_pipe[STAGE_NUM] <= 0;
        result <= 0;
        o_en <= 0;
    end else begin
        // Stage 0: capture input operands when i_en asserted
        en_pipe[0] <= i_en;
        if (i_en) begin
            a_reg[0] <= adda[15:0];
            b_reg[0] <= addb[15:0];
        end else begin
            a_reg[0] <= 0;
            b_reg[0] <= 0;
        end

        // Perform addition for stage 0
        {carry_reg[1], sum_reg[0]} <= a_reg[0] + b_reg[0] + carry_reg[0];

        // Pipeline subsequent stages
        for (i = 1; i < STAGE_NUM; i = i + 1) begin
            // Shift enable pipeline
            en_pipe[i] <= en_pipe[i-1];

            // Capture operand segments when previous stage enable is high
            if (en_pipe[i-1]) begin
                a_reg[i] <= adda[16*i +: STAGE_WIDTH];
                b_reg[i] <= addb[16*i +: STAGE_WIDTH];
            end else begin
                a_reg[i] <= 0;
                b_reg[i] <= 0;
            end

            // Add operands and carry-in from previous stage
            {carry_reg[i+1], sum_reg[i]} <= a_reg[i] + b_reg[i] + carry_reg[i];
        end

        // Pipeline final carry and enable signals
        carry_reg[0] <= 0; // initial carry-in is always zero

        en_pipe[STAGE_NUM] <= en_pipe[STAGE_NUM-1];

        // Output result and o_en when final pipeline stage is valid
        if (en_pipe[STAGE_NUM]) begin
            result <= {carry_reg[STAGE_NUM], sum_reg[3], sum_reg[2], sum_reg[1], sum_reg[0]};
        end else begin
            result <= 0;
        end
        o_en <= en_pipe[STAGE_NUM];
    end
end

endmodule