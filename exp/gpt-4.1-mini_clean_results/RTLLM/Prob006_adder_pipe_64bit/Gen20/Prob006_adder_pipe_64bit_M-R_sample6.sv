module adder_pipe_64bit (
    input               clk,
    input               rst_n,
    input               i_en,
    input      [63:0]   adda,
    input      [63:0]   addb,
    output reg [64:0]   result,
    output reg          o_en
);

    // Parameters for width and pipeline stages
    parameter DATA_WIDTH = 64;
    parameter STG_WIDTH  = 16;
    parameter STAGES     = DATA_WIDTH / STG_WIDTH;

    // Pipeline registers for operands and enable signal per stage
    reg [DATA_WIDTH-1:0] adda_pipe [0:STAGES];
    reg [DATA_WIDTH-1:0] addb_pipe [0:STAGES];
    reg                  en_pipe   [0:STAGES];

    // Carry signals per stage (carry_pipe[0] is initial carry in = 0)
    reg                  carry_pipe [0:STAGES];

    // Partial sums per stage (16-bit)
    reg [STG_WIDTH-1:0]  sum_pipe [0:STAGES-1];

    integer i;

    // Combinational adders per stage: sum + carry out
    wire [STG_WIDTH:0] adder_sum [0:STAGES-1];

    generate
        genvar stage;
        for(stage = 0; stage < STAGES; stage = stage + 1) begin : gen_adder_stages
            wire [STG_WIDTH-1:0] a_part = adda_pipe[stage][stage*STG_WIDTH +: STG_WIDTH];
            wire [STG_WIDTH-1:0] b_part = addb_pipe[stage][stage*STG_WIDTH +: STG_WIDTH];
            assign adder_sum[stage] = a_part + b_part + carry_pipe[stage];
        end
    endgenerate

    // Sequential pipeline logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset pipeline registers and outputs
            for (i = 0; i <= STAGES; i = i + 1) begin
                adda_pipe[i] <= {DATA_WIDTH{1'b0}};
                addb_pipe[i] <= {DATA_WIDTH{1'b0}};
                en_pipe[i]   <= 1'b0;
                carry_pipe[i]<= 1'b0;
            end
            for (i = 0; i < STAGES; i = i + 1) begin
                sum_pipe[i] <= {STG_WIDTH{1'b0}};
            end
            result <= {(DATA_WIDTH+1){1'b0}};
            o_en <= 1'b0;
        end else begin
            // Stage 0: load inputs and enable, init carry in to 0
            adda_pipe[0] <= adda;
            addb_pipe[0] <= addb;
            en_pipe[0] <= i_en;
            carry_pipe[0] <= 1'b0;

            // Compute sums and carry out for stage 0
            sum_pipe[0] <= adder_sum[0][STG_WIDTH-1:0];
            carry_pipe[1] <= adder_sum[0][STG_WIDTH];

            // Pipeline stages 1 to STAGES-1
            for (i = 1; i < STAGES; i = i + 1) begin
                // Advance pipeline registers for operands and enable
                adda_pipe[i] <= adda_pipe[i-1];
                addb_pipe[i] <= addb_pipe[i-1];
                en_pipe[i]   <= en_pipe[i-1];

                // Capture sum and carry out
                sum_pipe[i] <= adder_sum[i][STG_WIDTH-1:0];
                carry_pipe[i+1] <= adder_sum[i][STG_WIDTH];
            end

            // Propagate final pipeline stage registers for synchronization
            adda_pipe[STAGES] <= adda_pipe[STAGES-1];
            addb_pipe[STAGES] <= addb_pipe[STAGES-1];
            en_pipe[STAGES]   <= en_pipe[STAGES-1];

            // Update output enable
            o_en <= en_pipe[STAGES];

            // Update result when output is valid
            if (en_pipe[STAGES]) begin
                // Concatenate partial sums LSB first, plus final carry out MSB
                result <= {carry_pipe[STAGES],
                           sum_pipe[STAGES-1],
                           sum_pipe[STAGES-2],
                           sum_pipe[STAGES-3],
                           sum_pipe[STAGES-4]};
            end else begin
                result <= {(DATA_WIDTH+1){1'b0}};
            end
        end
    end

endmodule