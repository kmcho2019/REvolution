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
    localparam STAGES = 4;
    localparam WIDTH_PER_STAGE = 16;

    // Registers to hold operands per stage
    reg [WIDTH_PER_STAGE-1:0] adda_pipe  [0:STAGES-1];
    reg [WIDTH_PER_STAGE-1:0] addb_pipe  [0:STAGES-1];

    // Registers to hold sum per stage
    reg [WIDTH_PER_STAGE-1:0] sum_pipe   [0:STAGES-1];

    // Registers to hold carry out per stage
    reg carry_pipe [0:STAGES];

    // Pipeline register for i_en to generate o_en aligned with result
    reg [STAGES:0] i_en_pipe;

    integer i;

    // Split inputs into 16-bit chunks and pipeline them
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < STAGES; i = i + 1) begin
                adda_pipe[i] <= 0;
                addb_pipe[i] <= 0;
                sum_pipe[i]  <= 0;
            end
            for (i = 0; i <= STAGES; i = i + 1)
                carry_pipe[i] <= 0;
            i_en_pipe <= 0;
            result <= 0;
            o_en <= 0;
        end else begin
            // Shift enable through pipeline
            i_en_pipe <= {i_en_pipe[STAGES-1:0], i_en};

            // Stage 0: load inputs slices and add with carry_pipe[0] (carry in=0)
            if (i_en) begin
                adda_pipe[0] <= adda[WIDTH_PER_STAGE*1-1 : WIDTH_PER_STAGE*0];
                addb_pipe[0] <= addb[WIDTH_PER_STAGE*1-1 : WIDTH_PER_STAGE*0];
            end
            // Compute stage 0 sum and carry
            {carry_pipe[1], sum_pipe[0]} <= adda_pipe[0] + addb_pipe[0] + carry_pipe[0];

            // Stages 1 to STAGES-1
            for (i = 1; i < STAGES; i = i + 1) begin
                if (i_en_pipe[i-1]) begin
                    adda_pipe[i] <= adda[WIDTH_PER_STAGE*(i+1)-1 : WIDTH_PER_STAGE*i];
                    addb_pipe[i] <= addb[WIDTH_PER_STAGE*(i+1)-1 : WIDTH_PER_STAGE*i];
                end
                {carry_pipe[i+1], sum_pipe[i]} <= adda_pipe[i] + addb_pipe[i] + carry_pipe[i];
            end

            // Assemble final result when output is valid (last stage carry out)
            if (i_en_pipe[STAGES]) begin
                result <= {carry_pipe[STAGES], sum_pipe[STAGES-1], sum_pipe[STAGES-2], sum_pipe[STAGES-3], sum_pipe[0]};
            end

            o_en <= i_en_pipe[STAGES];
        end
    end

endmodule