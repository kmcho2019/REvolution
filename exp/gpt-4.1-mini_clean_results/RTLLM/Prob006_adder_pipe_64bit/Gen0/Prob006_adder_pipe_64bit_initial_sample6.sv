module adder_pipe_64bit (
    input             clk,
    input             rst_n,
    input             i_en,
    input      [63:0] adda,
    input      [63:0] addb,
    output reg [64:0] result,
    output reg        o_en
);

// Parameters for pipeline stages
localparam STAGE_NUM = 4;
localparam STAGE_BITS = 16;

// Internal registers to hold operands and sums for each stage
reg [STAGE_BITS-1:0] a_stage [0:STAGE_NUM-1];
reg [STAGE_BITS-1:0] b_stage [0:STAGE_NUM-1];
reg                  en_stage [0:STAGE_NUM];   // enable pipeline registers, 0..4
reg                  carry_stage [0:STAGE_NUM]; // carry signals between stages, 0..4
reg [STAGE_BITS-1:0] sum_stage [0:STAGE_NUM-1];

// Initial carry is zero at first stage
// Pipeline stage 0 inputs are driven directly from inputs when i_en is high

integer i;

// Pipeline registers for inputs and carry signals
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all pipeline registers
        for (i = 0; i < STAGE_NUM; i = i + 1) begin
            a_stage[i] <= 0;
            b_stage[i] <= 0;
            sum_stage[i] <= 0;
            carry_stage[i] <= 0;
            en_stage[i] <= 0;
        end
        en_stage[STAGE_NUM] <= 0;
        carry_stage[STAGE_NUM] <= 0;
        result <= 0;
        o_en <= 0;
    end else begin
        // Pipeline input enable shift register
        en_stage[0] <= i_en;

        // Load stage 0 inputs when i_en is asserted
        if (i_en) begin
            a_stage[0] <= adda[15:0];
            b_stage[0] <= addb[15:0];
        end else begin
            a_stage[0] <= 0;
            b_stage[0] <= 0;
        end

        // Compute sum and carry for stage 0
        {carry_stage[1], sum_stage[0]} <= (a_stage[0] + b_stage[0] + carry_stage[0]);

        // Pipeline inputs for next stages
        // For stage 1..3
        for (i = 1; i < STAGE_NUM; i = i + 1) begin
            // Shift enable
            en_stage[i] <= en_stage[i-1];
            // Shift operand segments
            if (en_stage[i-1]) begin
                a_stage[i] <= adda[16*i +: STAGE_BITS];
                b_stage[i] <= addb[16*i +: STAGE_BITS];
            end else begin
                a_stage[i] <= 0;
                b_stage[i] <= 0;
            end
            // Calculate sum and carry for stage i
            {carry_stage[i+1], sum_stage[i]} <= (a_stage[i] + b_stage[i] + carry_stage[i]);
        end

        // Final output enable and result register
        en_stage[STAGE_NUM] <= en_stage[STAGE_NUM-1];
        carry_stage[STAGE_NUM] <= carry_stage[STAGE_NUM];

        if (en_stage[STAGE_NUM]) begin
            // Assemble result from sum stages and final carry
            result <= {carry_stage[STAGE_NUM], sum_stage[3], sum_stage[2], sum_stage[1], sum_stage[0]};
        end else begin
            result <= 0;
        end

        o_en <= en_stage[STAGE_NUM];
    end
end

// Initial carry is zero
initial begin
    carry_stage[0] = 0;
end

endmodule