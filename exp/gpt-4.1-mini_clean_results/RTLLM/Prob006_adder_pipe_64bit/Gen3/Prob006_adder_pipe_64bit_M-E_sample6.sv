module adder_pipe_64bit (
    input              clk,
    input              rst_n,
    input              i_en,
    input      [63:0]  adda,
    input      [63:0]  addb,
    output reg [64:0]  result,
    output reg         o_en
);

    localparam STAGES = 16;          // Number of pipeline stages
    localparam CHUNK = 4;            // Bits processed per stage
    integer i;

    // Pipeline registers for 4-bit chunks of input operands per stage
    reg [CHUNK-1:0] adda_pipe [0:STAGES-1];
    reg [CHUNK-1:0] addb_pipe [0:STAGES-1];

    // Partial sums for each stage (4 bits)
    reg [CHUNK-1:0] sum_pipe [0:STAGES-1];

    // Carry signals between stages
    // carry_pipe[0] is input carry (always zero)
    reg carry_pipe [0:STAGES];

    // Pipeline register for input enable
    reg [STAGES-1:0] en_pipe;

    // Extract and register input chunks at stage 0
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers
            for (i = 0; i < STAGES; i = i +1) begin
                adda_pipe[i] <= 0;
                addb_pipe[i] <= 0;
                sum_pipe[i]  <= 0;
                carry_pipe[i] <= 0;
            end
            carry_pipe[STAGES] <= 0;

            en_pipe <= 0;
            result <= 0;
            o_en <= 0;
        end else begin
            // Shift enable pipeline and input enable new value
            en_pipe <= {en_pipe[STAGES-2:0], i_en};

            // Stage 0 input chunks
            if(i_en) begin
                adda_pipe[0] <= adda[CHUNK-1:0];
                addb_pipe[0] <= addb[CHUNK-1:0];
            end else begin
                // If not enabled, zero inputs to avoid false sums
                adda_pipe[0] <= 0;
                addb_pipe[0] <= 0;
            end

            // Initial carry-in is zero every cycle
            carry_pipe[0] <= 1'b0;

            // For stages 1 to STAGES-1: latch the operand chunks for next 4 bits if previous stage was enabled
            for (i = 1; i < STAGES; i = i + 1) begin
                if (en_pipe[i-1]) begin
                    adda_pipe[i] <= adda[CHUNK*(i+1)-1 -: CHUNK];
                    addb_pipe[i] <= addb[CHUNK*(i+1)-1 -: CHUNK];
                end else begin
                    adda_pipe[i] <= 0;
                    addb_pipe[i] <= 0;
                end
            end

            // Perform the addition in each stage with carry-in
            for (i = 0; i < STAGES; i = i + 1) begin
                if ( (i == 0 && i_en) || (i > 0 && en_pipe[i-1]) ) begin
                    {carry_pipe[i+1], sum_pipe[i]} <= adda_pipe[i] + addb_pipe[i] + carry_pipe[i];
                end else begin
                    sum_pipe[i] <= 0;
                    carry_pipe[i+1] <= 0;
                end
            end

            // Output enable delayed by STAGES cycles
            o_en <= en_pipe[STAGES-1];

            // When output is valid, concatenate sums and final carry to produce result
            if(en_pipe[STAGES-1]) begin
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
                           sum_pipe[STAGES-16]
                          };
            end else begin
                result <= 0;
            end
        end
    end

endmodule