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
    // carry_pipe width = STAGES+1 (for carry-out of last stage)
    reg [STAGES:0] carry_pipe;

    // Pipeline registers for sums from each stage (each STG_WIDTH bits)
    reg [STG_WIDTH-1:0] sum_pipe [0:STAGES-1];

    // Pipeline register to track enable signal across stages
    reg [STAGES-1:0] en_pipe;

    integer stage;

    // Combinational wires for each stage's sum and carry
    wire [STG_WIDTH:0] stage_sum [0:STAGES-1];
    wire [STG_WIDTH-1:0] a_slice [0:STAGES-1];
    wire [STG_WIDTH-1:0] b_slice [0:STAGES-1];

    // Extract operand slices for each stage (from registered inputs)
    generate
        genvar i;
        for (i = 0; i < STAGES; i = i + 1) begin : operand_slices
            assign a_slice[i] = adda_reg[(i+1)*STG_WIDTH-1 -: STG_WIDTH];
            assign b_slice[i] = addb_reg[(i+1)*STG_WIDTH-1 -: STG_WIDTH];
        end
    endgenerate

    // Combinational add_stage for each pipeline stage
    // sum = a_slice + b_slice + carry_in
    generate
        for (stage = 0; stage < STAGES; stage = stage + 1) begin : add_stages
            assign stage_sum[stage] = {1'b0, a_slice[stage]} + {1'b0, b_slice[stage]} + carry_pipe[stage];
        end
    endgenerate

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

            // Initialize carry_pipe[0]: carry-in to stage 0 is 0 when i_en_reg is high
            carry_pipe[0] <= i_en_reg ? 1'b0 : carry_pipe[0];

            // Register sum and carry pipeline for each stage if corresponding enable is high
            for (stage = 0; stage < STAGES; stage = stage + 1) begin
                if (en_pipe[stage]) begin
                    sum_pipe[stage] <= stage_sum[stage][STG_WIDTH-1:0];
                    carry_pipe[stage+1] <= stage_sum[stage][STG_WIDTH];
                end else begin
                    // Keep previous values if not enabled to maintain pipeline data
                    sum_pipe[stage] <= sum_pipe[stage];
                    carry_pipe[stage+1] <= carry_pipe[stage+1];
                end
            end

            // Output valid and assemble final result when last stage enable is high
            if (en_pipe[STAGES-1]) begin
                // Concatenate sums from all stages and final carry out
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
                result <= {(DATA_WIDTH+1){1'b0}};
                o_en <= 1'b0;
            end
        end
    end

endmodule