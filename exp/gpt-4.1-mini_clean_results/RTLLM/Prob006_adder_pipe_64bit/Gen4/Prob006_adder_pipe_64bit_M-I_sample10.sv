module adder_pipe_64bit #(
    parameter DATA_WIDTH = 64,
    parameter STAGE_WIDTH = 16
) (
    input  wire                     clk,
    input  wire                     rst_n,
    input  wire                     i_en,
    input  wire [DATA_WIDTH-1:0]   adda,
    input  wire [DATA_WIDTH-1:0]   addb,
    output reg  [DATA_WIDTH:0]     result,
    output reg                      o_en
);

    localparam NUM_STAGES = DATA_WIDTH / STAGE_WIDTH;

    // Pipeline registers for input operands per stage
    reg [STAGE_WIDTH-1:0] adda_pipe   [0:NUM_STAGES-1];
    reg [STAGE_WIDTH-1:0] addb_pipe   [0:NUM_STAGES-1];

    // Pipeline registers for sum outputs per stage
    reg [STAGE_WIDTH-1:0] sum_pipe    [0:NUM_STAGES-1];

    // Carry registers between stages: carry_in for stage 0 is 0
    reg carry_pipe [0:NUM_STAGES]; // carry_pipe[NUM_STAGES] is final carry out

    // Pipeline register for enable signals to track valid data through pipeline stages
    reg [NUM_STAGES:0] i_en_pipe;

    integer i;

    // Wires for combinational sum and carry-out per stage
    wire [STAGE_WIDTH:0] sum_and_carry [0:NUM_STAGES-1];

    // Slice inputs into stage-width chunks (combinational)
    wire [STAGE_WIDTH-1:0] adda_slices [0:NUM_STAGES-1];
    wire [STAGE_WIDTH-1:0] addb_slices [0:NUM_STAGES-1];

    genvar gi;
    generate
        for (gi = 0; gi < NUM_STAGES; gi = gi + 1) begin : SLICE_INPUTS
            assign adda_slices[gi] = adda[gi*STAGE_WIDTH +: STAGE_WIDTH];
            assign addb_slices[gi] = addb[gi*STAGE_WIDTH +: STAGE_WIDTH];
        end
    endgenerate

    // Combinational addition per stage with carry in
    generate
        for (gi = 0; gi < NUM_STAGES; gi = gi + 1) begin : COMB_ADDER
            assign sum_and_carry[gi] = {1'b0, adda_pipe[gi]} + {1'b0, addb_pipe[gi]} + carry_pipe[gi];
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset pipeline registers
            for (i = 0; i < NUM_STAGES; i = i + 1) begin
                adda_pipe[i] <= {STAGE_WIDTH{1'b0}};
                addb_pipe[i] <= {STAGE_WIDTH{1'b0}};
                sum_pipe[i]  <= {STAGE_WIDTH{1'b0}};
                carry_pipe[i] <= 1'b0;
            end
            carry_pipe[NUM_STAGES] <= 1'b0;
            i_en_pipe <= { (NUM_STAGES+1){1'b0} };
            result <= {(DATA_WIDTH+1){1'b0}};
            o_en <= 1'b0;
        end else begin
            // Shift input enable pipeline
            i_en_pipe[0] <= i_en;
            for (i = 1; i <= NUM_STAGES; i = i + 1) begin
                i_en_pipe[i] <= i_en_pipe[i-1];
            end

            // Stage 0 input latch and carry_in set to 0
            if (i_en) begin
                adda_pipe[0] <= adda_slices[0];
                addb_pipe[0] <= addb_slices[0];
                carry_pipe[0] <= 1'b0;
            end else if (!i_en_pipe[0]) begin
                // If no valid input, zero out stage 0
                adda_pipe[0] <= {STAGE_WIDTH{1'b0}};
                addb_pipe[0] <= {STAGE_WIDTH{1'b0}};
                carry_pipe[0] <= 1'b0;
            end

            // Stages 1 to NUM_STAGES-1 latch their inputs and carry
            for (i = 1; i < NUM_STAGES; i = i + 1) begin
                if (i_en_pipe[i]) begin
                    adda_pipe[i] <= adda_slices[i];
                    addb_pipe[i] <= addb_slices[i];
                end else if (!i_en_pipe[i]) begin
                    adda_pipe[i] <= {STAGE_WIDTH{1'b0}};
                    addb_pipe[i] <= {STAGE_WIDTH{1'b0}};
                end
                carry_pipe[i] <= carry_pipe[i]; // Default retain carry, updated below
            end

            // Calculate sums and carry_out, register them
            for (i = 0; i < NUM_STAGES; i = i + 1) begin
                // sum is lower STAGE_WIDTH bits
                sum_pipe[i] <= sum_and_carry[i][STAGE_WIDTH-1:0];
                // carry_out is MSB of sum_and_carry
                carry_pipe[i+1] <= sum_and_carry[i][STAGE_WIDTH];
            end

            // At the last stage output cycle, assemble final result and o_en
            if (i_en_pipe[NUM_STAGES]) begin
                result[0 +: STAGE_WIDTH] = sum_pipe[0];
                for (i = 1; i < NUM_STAGES; i = i + 1) begin
                    result[i*STAGE_WIDTH +: STAGE_WIDTH] = sum_pipe[i];
                end
                result[DATA_WIDTH] = carry_pipe[NUM_STAGES]; // Final carry out
            end

            o_en <= i_en_pipe[NUM_STAGES];
        end
    end

endmodule