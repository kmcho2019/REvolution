module adder_pipe_64bit (
    input               clk,
    input               rst_n,
    input               i_en,
    input      [63:0]   adda,
    input      [63:0]   addb,
    output reg [64:0]   result,
    output reg          o_en
);

// Parameters for pipeline stage widths
localparam STAGE_WIDTH = 16;
localparam NUM_STAGES  = 4;

// Pipeline registers for partial sums
reg [STAGE_WIDTH-1:0] sum_stage   [0:NUM_STAGES-1];
// Pipeline registers for carry signals between stages
reg carry_stage  [0:NUM_STAGES]; // carry_stage[0] is carry in (always 0)

// Pipeline registers for input enable synchronization
reg en_stage    [0:NUM_STAGES];

// Pipeline registers for input operands segmented per stage
reg [STAGE_WIDTH-1:0] adda_stage [0:NUM_STAGES-1];
reg [STAGE_WIDTH-1:0] addb_stage [0:NUM_STAGES-1];

integer i;

// Combinational logic to compute sum and carry for each stage
// but since the pipeline must register outputs, do calculations in always block.

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all pipeline registers
        for (i=0; i<NUM_STAGES; i=i+1) begin
            sum_stage[i] <= 0;
            adda_stage[i] <= 0;
            addb_stage[i] <= 0;
            en_stage[i] <= 0;
        end
        for (i=0; i<=NUM_STAGES; i=i+1) begin
            carry_stage[i] <= 0;
        end
        result <= 0;
        o_en <= 0;
    end else begin
        // Stage 0: capture inputs and initial carry=0
        // Carry-in for first stage is always 0
        carry_stage[0] <= 1'b0;
        if(i_en) begin
            // Latch inputs segmented to pipeline registers
            for (i=0; i<NUM_STAGES; i=i+1) begin
                adda_stage[i] <= adda[i*STAGE_WIDTH +: STAGE_WIDTH];
                addb_stage[i] <= addb[i*STAGE_WIDTH +: STAGE_WIDTH];
            end
            en_stage[0] <= 1'b1;
        end else begin
            en_stage[0] <= 1'b0;
        end

        // For each pipeline stage, perform addition of 16 bits plus carry-in
        for (i=0; i<NUM_STAGES; i=i+1) begin
            if (i == 0) begin
                // First stage sum and carry out
                {carry_stage[1], sum_stage[0]} <= adda_stage[0] + addb_stage[0] + carry_stage[0];
                // Propagate enable
                if (!i_en)
                    en_stage[1] <= 1'b0;
                else
                    en_stage[1] <= en_stage[0];
            end else begin
                {carry_stage[i+1], sum_stage[i]} <= adda_stage[i] + addb_stage[i] + carry_stage[i];
                en_stage[i+1] <= en_stage[i];
            end
        end

        // Output the final result and output enable when last stage data is ready
        if (en_stage[NUM_STAGES]) begin
            // Concatenate sums from stages and final carry
            result <= {carry_stage[NUM_STAGES], sum_stage[NUM_STAGES-1], sum_stage[NUM_STAGES-2], sum_stage[NUM_STAGES-3], sum_stage[NUM_STAGES-4]};
            o_en <= 1'b1;
        end else begin
            o_en <= 1'b0;
        end
    end
end

endmodule