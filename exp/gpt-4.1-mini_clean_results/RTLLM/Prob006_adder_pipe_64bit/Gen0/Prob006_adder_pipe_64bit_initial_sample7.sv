module adder_pipe_64bit (
    input           clk,
    input           rst_n,
    input           i_en,
    input   [63:0]  adda,
    input   [63:0]  addb,
    output  reg [64:0] result,
    output  reg      o_en
);

    // We choose 4 pipeline stages, each 16 bits, to implement the ripple carry adder pipeline.
    // Stage width
    localparam STAGE_WIDTH = 16;
    localparam STAGES = 4;

    // Pipeline registers for inputs
    reg [63:0] adda_pipe [0:STAGES];
    reg [63:0] addb_pipe [0:STAGES];
    reg        i_en_pipe [0:STAGES];

    // Carry signals between stages (carry out of stage n is carry in of stage n+1)
    reg carry_pipe [0:STAGES]; // carry_pipe[0] is carry-in to stage 0, fixed 0

    // Partial sums for each stage
    reg [STAGE_WIDTH-1:0] sum_pipe [0:STAGES-1];

    integer i;

    // Initialize pipeline registers at reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset input pipelines
            for (i = 0; i <= STAGES; i = i + 1) begin
                adda_pipe[i] <= 64'd0;
                addb_pipe[i] <= 64'd0;
                i_en_pipe[i] <= 1'b0;
            end

            // Reset carries, partial sums, output
            for (i = 0; i < STAGES; i = i + 1) begin
                sum_pipe[i] <= {STAGE_WIDTH{1'b0}};
                carry_pipe[i] <= 1'b0;
            end
            carry_pipe[STAGES] <= 1'b0;

            result <= 65'd0;
            o_en <= 1'b0;
        end else begin
            // Shift inputs through pipeline registers
            // Stage 0 input is current inputs
            adda_pipe[0] <= adda;
            addb_pipe[0] <= addb;
            i_en_pipe[0] <= i_en;
            carry_pipe[0] <= 1'b0; // initial carry-in is zero for addition

            // Propagate pipeline registers for input operands, i_en, and carry signals
            for (i = 1; i <= STAGES; i = i + 1) begin
                adda_pipe[i] <= adda_pipe[i-1];
                addb_pipe[i] <= addb_pipe[i-1];
                i_en_pipe[i] <= i_en_pipe[i-1];
                carry_pipe[i] <= carry_pipe[i]; // carry_pipe[i] is updated below
            end

            // Compute partial sums and carry out for each stage in pipeline register stage i
            // We do this combinationally from inputs stored in adda_pipe and addb_pipe at each pipeline stage, and propagate carry_out to carry_pipe of next stage

            // Stage 0 addition (bits 0 to 15)
            {carry_pipe[1], sum_pipe[0]} <= adda_pipe[0][15:0] + addb_pipe[0][15:0] + carry_pipe[0];

            // Stage 1 addition (bits 16 to 31)
            {carry_pipe[2], sum_pipe[1]} <= adda_pipe[1][31:16] + addb_pipe[1][31:16] + carry_pipe[1];

            // Stage 2 addition (bits 32 to 47)
            {carry_pipe[3], sum_pipe[2]} <= adda_pipe[2][47:32] + addb_pipe[2][47:32] + carry_pipe[2];

            // Stage 3 addition (bits 48 to 63)
            {carry_pipe[4], sum_pipe[3]} <= adda_pipe[3][63:48] + addb_pipe[3][63:48] + carry_pipe[3];

            // When stage 4 inputs are ready (adda_pipe[4], addb_pipe[4], but not used here),
            // The sum_pipe registers hold partial sums from stage 0 to 3 from previous cycle.
            // Assemble final result with partial sums and final carry_out carry_pipe[4].

            // The output 'result' and 'o_en' are registered at stage 4 pipeline stage.
            // o_en reflects that the output result is valid.

            // Concatenate all partial sums and carry_out in order
            result <= {carry_pipe[4], sum_pipe[3], sum_pipe[2], sum_pipe[1], sum_pipe[0]};
            o_en <= i_en_pipe[4];
        end
    end

endmodule