module adder_pipe_64bit (
    input               clk,
    input               rst_n,
    input               i_en,
    input       [63:0]  adda,
    input       [63:0]  addb,
    output reg  [64:0]  result,
    output reg          o_en
);

    // Pipeline stage count and segment width
    localparam STAGES = 4;
    localparam SEG_WIDTH = 16;

    // Registers for input operands and input enable
    reg [63:0] adda_reg;
    reg [63:0] addb_reg;
    reg        i_en_reg;

    // Registers to hold partial sums and carries between pipeline stages
    // We'll keep partial sums per segment and carry-in per stage
    reg [SEG_WIDTH-1:0] sum_stage [0:STAGES-1];
    reg carry_stage [0:STAGES]; // carry_stage[0] is carry-in to stage 0, initialized to zero

    // Pipeline registers for inputs and enable signals to synchronize stages
    reg [STAGES-1:0] en_pipeline;

    integer i;

    // Capture inputs and enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            adda_reg <= 64'd0;
            addb_reg <= 64'd0;
            i_en_reg <= 1'b0;
        end else begin
            adda_reg <= adda;
            addb_reg <= addb;
            i_en_reg <= i_en;
        end
    end

    // Carry for stage 0 is always 0 (no carry-in)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            carry_stage[0] <= 1'b0;
        end else if (i_en_reg) begin
            carry_stage[0] <= 1'b0;
        end
    end

    // Pipeline the enable signal (shift register)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            en_pipeline <= {STAGES{1'b0}};
        end else begin
            en_pipeline <= {en_pipeline[STAGES-2:0], i_en_reg};
        end
    end

    // Compute sums and carry propagation for each pipeline stage
    // Each stage gets input operands segment and carry-in from previous stage carry register
    // The calculation happens combinationally, then registered at next clock for pipeline
    reg [SEG_WIDTH-1:0] adda_seg [0:STAGES-1];
    reg [SEG_WIDTH-1:0] addb_seg [0:STAGES-1];

    always @* begin
        for (i=0; i<STAGES; i=i+1) begin
            adda_seg[i] = adda_reg[(i+1)*SEG_WIDTH-1 -: SEG_WIDTH];
            addb_seg[i] = addb_reg[(i+1)*SEG_WIDTH-1 -: SEG_WIDTH];
        end
    end

    // Registers to hold sums and carry-out at each stage (next pipeline register)
    reg [SEG_WIDTH-1:0] sum_stage_next [0:STAGES-1];
    reg carry_stage_next [0:STAGES];

    integer j;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (j=0; j<STAGES; j=j+1) begin
                sum_stage[j] <= {SEG_WIDTH{1'b0}};
                carry_stage[j+1] <= 1'b0;
            end
        end else begin
            for (j=0; j<STAGES; j=j+1) begin
                {carry_stage_next[j+1], sum_stage_next[j]} = adda_seg[j] + addb_seg[j] + carry_stage[j];
            end
            // Update pipeline registers with the computed sums and carries
            for (j=0; j<STAGES; j=j+1) begin
                sum_stage[j] <= sum_stage_next[j];
                carry_stage[j+1] <= carry_stage_next[j+1];
            end
        end
    end

    // Assemble the 65-bit result from all sum segments and final carry_out
    // Output enable o_en asserted when all pipeline stages are valid (en_pipeline[STAGES-1] == 1)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result <= 65'd0;
            o_en <= 1'b0;
        end else begin
            if (en_pipeline[STAGES-1]) begin
                result <= {carry_stage[STAGES], sum_stage[STAGES-1], sum_stage[STAGES-2], sum_stage[STAGES-3], sum_stage[STAGES-4]};
                o_en <= 1'b1;
            end else begin
                o_en <= 1'b0;
            end
        end
    end

endmodule