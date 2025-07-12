module adder_pipe_64bit (
    input              clk,
    input              rst_n,
    input              i_en,
    input      [63:0]  adda,
    input      [63:0]  addb,
    output reg [64:0]  result,
    output reg         o_en
);

    // Number of pipeline stages equals bit-width of inputs (64)
    localparam PIPELINE_STAGES = 64;

    // Pipeline registers to store operand bits per stage
    reg [PIPELINE_STAGES-1:0] adda_pipe;  // holds operand A bits per stage
    reg [PIPELINE_STAGES-1:0] addb_pipe;  // holds operand B bits per stage

    // Pipeline registers for sum bits per stage
    reg [PIPELINE_STAGES-1:0] sum_pipe;

    // Pipeline registers for carry bits per stage, one extra for initial carry-in and final carry-out
    reg [PIPELINE_STAGES:0]    carry_pipe;

    // Pipeline registers for enable signal per stage, length PIPELINE_STAGES+1 to track valid result
    reg [PIPELINE_STAGES:0]    en_pipe;

    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers
            adda_pipe  <= {PIPELINE_STAGES{1'b0}};
            addb_pipe  <= {PIPELINE_STAGES{1'b0}};
            sum_pipe   <= {PIPELINE_STAGES{1'b0}};
            carry_pipe <= {(PIPELINE_STAGES+1){1'b0}};
            en_pipe    <= {(PIPELINE_STAGES+1){1'b0}};
            result     <= 65'b0;
            o_en       <= 1'b0;
        end else begin
            // Stage 0 inputs
            adda_pipe[0] <= adda[0];
            addb_pipe[0] <= addb[0];

            // Shift in operands bits from input for stages >0
            for (i=1; i < PIPELINE_STAGES; i=i+1) begin
                adda_pipe[i] <= adda_pipe[i-1];
                addb_pipe[i] <= addb_pipe[i-1];
            end

            // Shift enable pipeline, stage 0 loaded with i_en
            en_pipe[0] <= i_en;
            for (i=1; i <= PIPELINE_STAGES; i=i+1) begin
                en_pipe[i] <= en_pipe[i-1];
            end

            // Initialize carry in at stage 0 to zero
            carry_pipe[0] <= 1'b0;

            // Process all pipeline stages: compute sum bit and carry out for each stage
            for (i=0; i < PIPELINE_STAGES; i=i+1) begin
                // Full adder logic for bit i
                // sum = A xor B xor carry_in
                sum_pipe[i] <= adda_pipe[i] ^ addb_pipe[i] ^ carry_pipe[i];
                // carry_out = majority of (A, B, carry_in)
                carry_pipe[i+1] <= (adda_pipe[i] & addb_pipe[i]) | (adda_pipe[i] & carry_pipe[i]) | (addb_pipe[i] & carry_pipe[i]);
            end

            // When carry_pipe[PIPELINE_STAGES] and sum_pipe are valid, assemble the full 65-bit result
            // The sum_pipe holds bits [0:63], carry_pipe[PIPELINE_STAGES] is MSB carry out
            result <= {carry_pipe[PIPELINE_STAGES], sum_pipe};

            // Output enable synchronized to pipeline delay (65 cycles)
            o_en <= en_pipe[PIPELINE_STAGES];
        end
    end

endmodule