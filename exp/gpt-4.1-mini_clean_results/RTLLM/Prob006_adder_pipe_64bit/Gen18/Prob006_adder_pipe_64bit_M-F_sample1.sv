module adder_pipe_64bit #(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH  = 16
)(
    input                   clk,
    input                   rst_n,
    input                   i_en,
    input  [DATA_WIDTH-1:0] adda,
    input  [DATA_WIDTH-1:0] addb,
    output reg [DATA_WIDTH:0] result,  // DATA_WIDTH+1 bits to include carry out
    output reg              o_en
);

    localparam STAGES = DATA_WIDTH / STG_WIDTH;

    // Pipeline registers for operands and enable for each stage including input stage
    reg [DATA_WIDTH-1:0] adda_pipe [0:STAGES];
    reg [DATA_WIDTH-1:0] addb_pipe [0:STAGES];
    reg                  en_pipe   [0:STAGES];

    // Carry registers between stages (carry_pipe[0] is initial carry-in)
    reg carry_pipe [0:STAGES];

    // Partial sums per stage (STG_WIDTH bits each)
    reg [STG_WIDTH-1:0] sum_pipe [0:STAGES-1];

    integer i;

    // Combinational adder outputs for each stage (STG_WIDTH+1 bits: sum + carry out)
    wire [STG_WIDTH:0] adder_sum [0:STAGES-1];

    genvar stage;
    generate
        for (stage = 0; stage < STAGES; stage = stage + 1) begin : adder_stages
            wire [STG_WIDTH-1:0] a_part = adda_pipe[stage][stage*STG_WIDTH +: STG_WIDTH];
            wire [STG_WIDTH-1:0] b_part = addb_pipe[stage][stage*STG_WIDTH +: STG_WIDTH];
            assign adder_sum[stage] = a_part + b_part + carry_pipe[stage];
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers
            for (i = 0; i <= STAGES; i = i + 1) begin
                adda_pipe[i] <= {DATA_WIDTH{1'b0}};
                addb_pipe[i] <= {DATA_WIDTH{1'b0}};
                en_pipe[i]   <= 1'b0;
                carry_pipe[i] <= 1'b0;
            end
            for (i = 0; i < STAGES; i = i + 1) begin
                sum_pipe[i] <= {STG_WIDTH{1'b0}};
            end
            result <= {(DATA_WIDTH+1){1'b0}};
            o_en <= 1'b0;
        end else begin
            // Stage 0 input load and initial carry_in=0
            adda_pipe[0] <= adda;
            addb_pipe[0] <= addb;
            en_pipe[0]   <= i_en;
            carry_pipe[0] <= 1'b0;

            // Compute sum and carry_out for stage 0 and store in registers
            sum_pipe[0] <= adder_sum[0][STG_WIDTH-1:0];
            carry_pipe[1] <= adder_sum[0][STG_WIDTH];

            // For stages 1 to STAGES-1
            for (i = 1; i < STAGES; i = i + 1) begin
                // Pipeline registers advance inputs and enable
                adda_pipe[i] <= adda_pipe[i-1];
                addb_pipe[i] <= addb_pipe[i-1];
                en_pipe[i]   <= en_pipe[i-1];

                // Sum and carry_out update
                sum_pipe[i] <= adder_sum[i][STG_WIDTH-1:0];
                carry_pipe[i+1] <= adder_sum[i][STG_WIDTH];
            end

            // Advance enable and operands registers after last stage for final output timing
            adda_pipe[STAGES] <= adda_pipe[STAGES-1];
            addb_pipe[STAGES] <= addb_pipe[STAGES-1];
            en_pipe[STAGES]   <= en_pipe[STAGES-1];

            // Output assignment when last stage enable is high
            if (en_pipe[STAGES]) begin
                // Concatenate partial sums [STAGES-1 down to 0] in order LSB to MSB plus final carry_out
                // sum_pipe[0] is least significant 16 bits, sum_pipe[STAGES-1] is most significant block
                result <= {carry_pipe[STAGES], 
                           sum_pipe[STAGES-1],
                           sum_pipe[STAGES-2],
                           sum_pipe[STAGES-3],
                           sum_pipe[STAGES-4]};
                // Since STAGES is parameter, concat all stages via loop for flexibility:
                // We'll build in code below to cover all stages dynamically

                // The above fixed concat for 4 stages only; replace with loop below:

                // To replace previous assignment with a loop-generated vector:
                // We'll create a temporary reg vector to hold concatenated sums

                // But loops are not allowed in always block for concatenation, so we do this outside always block

                // To avoid complexity, rewrite result assignment after always block using a task or separate combinational block

                // For now, workaround is to unroll manually or use a generate statement for final concat outside always block
                // But since it's inside always, we must do manual concat for any number of stages, or declare an intermediate wire and register.

                // We fix by using a combinational wire to hold concatenated sums:
            end else begin
                result <= {(DATA_WIDTH+1){1'b0}};
                o_en <= 1'b0;
            end

            // o_en tracks final stage enable
            o_en <= en_pipe[STAGES];
        end
    end

    // To properly assign the result by concatenating sum_pipe elements in order,
    // we use a combinational function outside always block

    // Create a wire for concatenated sums, then registered to result when o_en is asserted
    wire [DATA_WIDTH-1:0] sum_concat;
    genvar s;
    generate
        wire [DATA_WIDTH-1:0] sum_temp;
        for (s=0; s < STAGES; s=s+1) begin : sum_concat_gen
            // Place each stage's sum at its correct bit position
            assign sum_temp[s*STG_WIDTH +: STG_WIDTH] = sum_pipe[s];
        end
        assign sum_concat = sum_temp;
    endgenerate

    // Register the final result at each clock when o_en asserted (to avoid combinational assignment inside always)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result <= {(DATA_WIDTH+1){1'b0}};
        end else if (o_en) begin
            result <= {carry_pipe[STAGES], sum_concat};
        end else begin
            result <= {(DATA_WIDTH+1){1'b0}};
        end
    end

endmodule