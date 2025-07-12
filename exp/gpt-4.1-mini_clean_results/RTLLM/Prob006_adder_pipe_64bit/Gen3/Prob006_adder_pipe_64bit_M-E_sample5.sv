module adder_pipe_64bit (
    input  wire          clk,
    input  wire          rst_n,
    input  wire          i_en,
    input  wire [63:0]   adda,
    input  wire [63:0]   addb,
    output reg  [64:0]   result,
    output reg           o_en
);

    // Define pipeline parameters
    localparam STAGE_WIDTH = 16;
    localparam NUM_STAGES  = 64 / STAGE_WIDTH; // 4 stages

    // Stage inputs (registered slices of adda and addb)
    reg [STAGE_WIDTH-1:0] adda_stage [0:NUM_STAGES-1];
    reg [STAGE_WIDTH-1:0] addb_stage [0:NUM_STAGES-1];

    // Sum registers for each stage (STAGE_WIDTH bits)
    reg [STAGE_WIDTH-1:0] sum_stage [0:NUM_STAGES-1];

    // Carry registers between stages (carry[0] is input carry to stage 0)
    reg carry [0:NUM_STAGES];

    // Pipeline register for input enable signal delayed through stages +1 for result
    reg [NUM_STAGES:0] i_en_pipe;

    integer i;

    // Combinational slices of input operands for next input capture
    wire [STAGE_WIDTH-1:0] adda_slices [0:NUM_STAGES-1];
    wire [STAGE_WIDTH-1:0] addb_slices [0:NUM_STAGES-1];

    // Slice the inputs combinationally
    generate
        genvar gi;
        for (gi = 0; gi < NUM_STAGES; gi = gi + 1) begin : SLICE_INPUTS
            assign adda_slices[gi] = adda[ (gi+1)*STAGE_WIDTH-1 : gi*STAGE_WIDTH ];
            assign addb_slices[gi] = addb[ (gi+1)*STAGE_WIDTH-1 : gi*STAGE_WIDTH ];
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            for (i = 0; i < NUM_STAGES; i = i + 1) begin
                adda_stage[i] <= {STAGE_WIDTH{1'b0}};
                addb_stage[i] <= {STAGE_WIDTH{1'b0}};
                sum_stage[i]  <= {STAGE_WIDTH{1'b0}};
            end
            for (i = 0; i <= NUM_STAGES; i = i + 1) begin
                carry[i] <= 1'b0;
                i_en_pipe[i] <= 1'b0;
            end
            result <= 65'b0;
            o_en <= 1'b0;
        end else begin
            // Shift enable pipeline
            i_en_pipe[0] <= i_en;
            for (i = 1; i <= NUM_STAGES; i = i + 1) begin
                i_en_pipe[i] <= i_en_pipe[i-1];
            end

            // Stage 0 input latch and addition
            if (i_en) begin
                adda_stage[0] <= adda_slices[0];
                addb_stage[0] <= addb_slices[0];
                carry[0]      <= 1'b0; // carry-in is 0 for LSB stage
            end
            // Perform addition for stage 0
            sum_stage[0] <= adda_stage[0] + addb_stage[0] + carry[0];
            carry[1]     <= (adda_stage[0] + addb_stage[0] + carry[0]) > 16'hFFFF;

            // Subsequent stages
            for (i = 1; i < NUM_STAGES; i = i + 1) begin
                if (i_en_pipe[i]) begin
                    adda_stage[i] <= adda_slices[i];
                    addb_stage[i] <= addb_slices[i];
                end
                sum_stage[i] <= adda_stage[i] + addb_stage[i] + carry[i];
                carry[i+1]   <= (adda_stage[i] + addb_stage[i] + carry[i]) > 16'hFFFF;
            end

            // When the final stage's result is valid, assemble the full sum
            if (i_en_pipe[NUM_STAGES]) begin
                result[64] <= carry[NUM_STAGES]; // final carry out

                // Concatenate the 16-bit sums from highest to lowest stage
                result[63:48] <= sum_stage[3];
                result[47:32] <= sum_stage[2];
                result[31:16] <= sum_stage[1];
                result[15:0]  <= sum_stage[0];
            end

            // Output enable is the delayed input enable after pipeline latency
            o_en <= i_en_pipe[NUM_STAGES];
        end
    end

endmodule