module adder_pipe_64bit (
    input              clk,
    input              rst_n,
    input              i_en,
    input      [63:0]  adda,
    input      [63:0]  addb,
    output reg [64:0]  result,
    output reg         o_en
);

    localparam STAGES = 16;
    localparam STG_BITS = 4;

    // Pipeline registers for each stage: operands, sums, carry, and enable
    reg [STG_BITS-1:0] adda_pipe  [0:STAGES-1];
    reg [STG_BITS-1:0] addb_pipe  [0:STAGES-1];
    reg [STG_BITS-1:0] sum_pipe   [0:STAGES-1];
    reg                carry_pipe [0:STAGES];      // carry_pipe[0] = initial carry_in (0)
    reg                en_pipe    [0:STAGES];      // enables tracking data validity through pipeline

    integer i;

    // Load inputs and initial carry at stage 0
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for(i = 0; i < STAGES; i = i + 1) begin
                adda_pipe[i] <= 0;
                addb_pipe[i] <= 0;
                sum_pipe[i]  <= 0;
            end
            carry_pipe[0] <= 0;
            for(i = 1; i <= STAGES; i = i + 1) begin
                carry_pipe[i] <= 0;
            end
            for(i = 0; i <= STAGES; i = i + 1) begin
                en_pipe[i] <= 0;
            end
            result <= 0;
            o_en <= 0;
        end else begin
            // Stage 0 input load and enable
            adda_pipe[0] <= adda[ 3: 0];
            addb_pipe[0] <= addb[ 3: 0];
            carry_pipe[0] <= 1'b0;      // initial carry in zero
            en_pipe[0] <= i_en;

            // Compute sum and carry for stage 0
            {carry_pipe[1], sum_pipe[0]} <= adda_pipe[0] + addb_pipe[0] + carry_pipe[0];
            en_pipe[1] <= en_pipe[0];

            // Stages 1 to STAGES-1 pipeline shift, compute sums and propagate carry
            for(i = 1; i < STAGES; i = i + 1) begin
                adda_pipe[i] <= adda[(i*STG_BITS) +: STG_BITS];
                addb_pipe[i] <= addb[(i*STG_BITS) +: STG_BITS];
                {carry_pipe[i+1], sum_pipe[i]} <= adda_pipe[i] + addb_pipe[i] + carry_pipe[i];
                en_pipe[i+1] <= en_pipe[i];
            end

            // Output assembling when last stage valid
            if(en_pipe[STAGES]) begin
                // Concatenate all sum_pipe pieces and final carry
                result <= {carry_pipe[STAGES],
                           sum_pipe[STAGES-1],
                           sum_pipe[STAGES-2],
                           sum_pipe[STAGES-3],
                           sum_pipe[STAGES-4],
                           sum_pipe[STAGES-5],
                           sum_pipe[STAGES-6],
                           sum_pipe[STAGES-7],
                           sum_pipe[STAGES-8],
                           sum_pipe[STAGES-9],
                           sum_pipe[STAGES-10],
                           sum_pipe[STAGES-11],
                           sum_pipe[STAGES-12],
                           sum_pipe[STAGES-13],
                           sum_pipe[STAGES-14],
                           sum_pipe[STAGES-15],
                           sum_pipe[0]
                          };
                o_en <= 1'b1;
            end else begin
                result <= 0;
                o_en <= 0;
            end
        end
    end

endmodule