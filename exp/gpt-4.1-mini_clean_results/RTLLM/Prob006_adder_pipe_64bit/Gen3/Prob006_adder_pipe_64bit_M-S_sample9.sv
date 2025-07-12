module adder_pipe_64bit (
    input               clk,
    input               rst_n,
    input               i_en,
    input      [63:0]   adda,
    input      [63:0]   addb,
    output reg [64:0]   result,
    output reg          o_en
);

    // Constants
    localparam STAGE_BITS = 16;
    localparam STAGES = 4;

    // Pipeline registers for inputs and enable
    reg [63:0] adda_pipe [0:STAGES];
    reg [63:0] addb_pipe [0:STAGES];
    reg        i_en_pipe [0:STAGES];

    // Pipeline registers for sums per stage
    reg [STAGE_BITS-1:0] sum_pipe [0:STAGES-1];

    // Pipeline registers for carry bits between stages
    reg carry_pipe [0:STAGES];

    integer i;

    // On reset or clock, pipeline inputs and calculate sums
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i <= STAGES; i = i + 1) begin
                adda_pipe[i] <= 64'b0;
                addb_pipe[i] <= 64'b0;
                i_en_pipe[i] <= 1'b0;
                carry_pipe[i] <= 1'b0;
            end
            for (i = 0; i < STAGES; i = i + 1) begin
                sum_pipe[i] <= {STAGE_BITS{1'b0}};
            end
            result <= 65'b0;
            o_en <= 1'b0;
        end else begin
            // Pipeline inputs and enable
            adda_pipe[0] <= adda;
            addb_pipe[0] <= addb;
            i_en_pipe[0] <= i_en;

            for (i = 1; i <= STAGES; i = i + 1) begin
                adda_pipe[i] <= adda_pipe[i-1];
                addb_pipe[i] <= addb_pipe[i-1];
                i_en_pipe[i] <= i_en_pipe[i-1];
            end

            // Initialize carry_in for stage 0
            carry_pipe[0] <= 1'b0;

            // Compute sums and carry for each stage
            for (i = 0; i < STAGES; i = i + 1) begin
                // Extract 16-bit slices for this stage
                wire [STAGE_BITS-1:0] a_part = adda_pipe[i][(i+1)*STAGE_BITS-1 -: STAGE_BITS];
                wire [STAGE_BITS-1:0] b_part = addb_pipe[i][(i+1)*STAGE_BITS-1 -: STAGE_BITS];

                // Full addition with carry in
                {carry_pipe[i+1], sum_pipe[i]} <= a_part + b_part + carry_pipe[i];
            end

            // Assemble the full 65-bit result from all stage sums and final carry
            result <= {carry_pipe[STAGES], sum_pipe[STAGES-1], sum_pipe[STAGES-2], sum_pipe[STAGES-3], sum_pipe[0]};

            // Synchronize output enable
            o_en <= i_en_pipe[STAGES];
        end
    end

endmodule