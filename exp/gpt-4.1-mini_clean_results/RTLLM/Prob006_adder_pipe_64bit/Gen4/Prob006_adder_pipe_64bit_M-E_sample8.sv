module adder_pipe_64bit #(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH = 8,                     // Bits per pipeline stage (must divide DATA_WIDTH)
    parameter STAGES = DATA_WIDTH / STG_WIDTH    // Number of pipeline stages
)(
    input                          clk,
    input                          rst_n,
    input                          i_en,
    input      [DATA_WIDTH-1:0]    adda,
    input      [DATA_WIDTH-1:0]    addb,
    output reg [DATA_WIDTH:0]      result,
    output reg                     o_en
);
    // Input registers to hold input operands and enable
    reg [DATA_WIDTH-1:0] adda_reg;
    reg [DATA_WIDTH-1:0] addb_reg;
    reg                  i_en_reg;

    // Pipeline registers for carry between stages
    // carry pipeline registers: STAGES + 1 elements (0 to STAGES)
    reg [STAGES:0] carry_pipe;

    // Pipeline registers for sums from each stage (each STG_WIDTH bits)
    reg [STG_WIDTH-1:0] sum_pipe [0:STAGES-1];

    // Pipeline register to track enable signal across stages
    reg [STAGES-1:0] en_pipe;

    integer stage;

    // Helper function: adder stage
    // Inputs: bits of operands and carry_in
    // Outputs: sum bits and carry_out
    function automatic [STG_WIDTH:0] add_stage;
        input [STG_WIDTH-1:0] a;
        input [STG_WIDTH-1:0] b;
        input carry_in;
        reg [STG_WIDTH:0] full_sum;
    begin
        full_sum = {1'b0, a} + {1'b0, b} + carry_in;
        add_stage = full_sum;  // [STG_WIDTH] is carry out, [STG_WIDTH-1:0] sum
    end
    endfunction

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            adda_reg <= {DATA_WIDTH{1'b0}};
            addb_reg <= {DATA_WIDTH{1'b0}};
            i_en_reg <= 1'b0;

            carry_pipe <= {(STAGES+1){1'b0}};
            en_pipe <= {STAGES{1'b0}};

            for (stage = 0; stage < STAGES; stage = stage + 1) begin
                sum_pipe[stage] <= {STG_WIDTH{1'b0}};
            end

            result <= {(DATA_WIDTH+1){1'b0}};
            o_en <= 1'b0;
        end else begin
            // Capture inputs and enable
            adda_reg <= adda;
            addb_reg <= addb;
            i_en_reg <= i_en;

            // Shift enable pipeline: insert current enable at stage 0
            en_pipe <= {en_pipe[STAGES-2:0], i_en_reg};

            // Initialize carry pipeline stage 0 at the same cycle when inputs are registered
            // Stage 0 carry-in is zero if i_en_reg is high, else keep previous value
            carry_pipe[0] <= i_en_reg ? 1'b0 : carry_pipe[0];

            // Pipeline the adder stages
            for (stage = 0; stage < STAGES; stage = stage + 1) begin
                // Extract slice of operands for this stage
                // Indices: [ (stage+1)*STG_WIDTH -1 : stage*STG_WIDTH ]
                // Inputs to adder stage:
                // a_slice and b_slice from registered inputs
                // carry_in from carry_pipe[stage]
                // Outputs: sum_slice and carry_out for next stage

                // Only compute if enable was asserted at the appropriate cycle (en_pipe[stage] high)
                if (en_pipe[stage]) begin
                    // Operand slices
                    wire [STG_WIDTH-1:0] a_slice = adda_reg[(stage+1)*STG_WIDTH-1 -: STG_WIDTH];
                    wire [STG_WIDTH-1:0] b_slice = addb_reg[(stage+1)*STG_WIDTH-1 -: STG_WIDTH];

                    // Perform addition for this stage
                    // Use add_stage function
                    wire [STG_WIDTH:0] stage_sum = add_stage(a_slice, b_slice, carry_pipe[stage]);

                    sum_pipe[stage] <= stage_sum[STG_WIDTH-1:0];
                    carry_pipe[stage+1] <= stage_sum[STG_WIDTH];
                end else begin
                    // If not enabled, keep previous or clear
                    sum_pipe[stage] <= sum_pipe[stage];
                    carry_pipe[stage+1] <= carry_pipe[stage+1];
                end
            end

            // When the final stage's enable bit is high, output is valid
            if (en_pipe[STAGES-1]) begin
                // Assemble full sum from all sum_pipe segments plus final carry out
                // result = {carry_pipe[STAGES], sum_pipe[STAGES-1], ..., sum_pipe[0]}
                // Concatenate the sum_pipe segments from highest to lowest stage
                result <= {carry_pipe[STAGES], 
                    sum_pipe[STAGES-1],
                    sum_pipe[STAGES-2],
                    sum_pipe[STAGES-3],
                    sum_pipe[STAGES-4],
                    sum_pipe[STAGES-5],
                    sum_pipe[STAGES-6],
                    sum_pipe[STAGES-7]
                };
                o_en <= 1'b1;
            end else begin
                // Output not valid yet
                result <= {(DATA_WIDTH+1){1'b0}};
                o_en <= 1'b0;
            end
        end
    end

endmodule