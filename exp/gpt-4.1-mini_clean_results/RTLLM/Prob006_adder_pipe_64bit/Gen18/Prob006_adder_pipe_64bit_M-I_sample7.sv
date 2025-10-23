module adder_pipe_64bit (
    input              clk,
    input              rst_n,
    input              i_en,
    input      [63:0]  adda,
    input      [63:0]  addb,
    output reg [64:0]  result,
    output reg         o_en
);

    localparam STAGES = 8;
    localparam WIDTH_PER_STAGE = 8;

    // Pipeline registers for operand slices
    reg [WIDTH_PER_STAGE-1:0] adda_pipe [0:STAGES-1];
    reg [WIDTH_PER_STAGE-1:0] addb_pipe [0:STAGES-1];

    // Pipeline registers for partial sums
    reg [WIDTH_PER_STAGE-1:0] sum_pipe [0:STAGES-1];

    // Pipeline register for carry signals: carry_pipe[i] is carry into stage i
    reg carry_pipe [0:STAGES];

    // Pipeline registers for enable signals (to track valid data)
    reg en_pipe [0:STAGES];

    integer i;

    // Combinational wires for sum and carry per stage
    wire [WIDTH_PER_STAGE:0] sum_carry [0:STAGES-1]; // [WIDTH_PER_STAGE] is carry out

    // Generate combinational sum and carry for each stage
    generate
        genvar idx;
        for (idx = 0; idx < STAGES; idx = idx + 1) begin : gen_sum_carry
            assign sum_carry[idx] = adda_pipe[idx] + addb_pipe[idx] + carry_pipe[idx];
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers
            for (i = 0; i < STAGES; i = i + 1) begin
                adda_pipe[i] <= {WIDTH_PER_STAGE{1'b0}};
                addb_pipe[i] <= {WIDTH_PER_STAGE{1'b0}};
                sum_pipe[i]  <= {WIDTH_PER_STAGE{1'b0}};
                carry_pipe[i] <= 1'b0;
                en_pipe[i] <= 1'b0;
            end
            carry_pipe[STAGES] <= 1'b0;
            en_pipe[STAGES] <= 1'b0;
            result <= 65'b0;
            o_en <= 1'b0;
        end else begin
            // Pipeline input operand slices and enable as a shift register:

            // Stage 0: load operand slices and enable only if i_en=1
            if (i_en) begin
                // Load operand slices at stage 0 registers
                for (i = 0; i < STAGES; i = i + 1) begin
                    adda_pipe[i] <= adda[i*WIDTH_PER_STAGE +: WIDTH_PER_STAGE];
                    addb_pipe[i] <= addb[i*WIDTH_PER_STAGE +: WIDTH_PER_STAGE];
                end
                en_pipe[0] <= 1'b1;
                carry_pipe[0] <= 1'b0;  // initial carry in is zero for new addition
            end else begin
                // Shift the pipeline: move operand slices forward, propagate enable and carry
                for (i = STAGES-1; i > 0; i = i - 1) begin
                    adda_pipe[i] <= adda_pipe[i-1];
                    addb_pipe[i] <= addb_pipe[i-1];
                end
                // For stage 0 operands hold old data (no new input)
                adda_pipe[0] <= adda_pipe[0];
                addb_pipe[0] <= addb_pipe[0];

                // Shift enable and carry pipeline
                for (i = STAGES; i > 0; i = i - 1) begin
                    en_pipe[i] <= en_pipe[i-1];
                    carry_pipe[i] <= carry_pipe[i-1];
                end
                en_pipe[0] <= 1'b0; // no new input this cycle
                carry_pipe[0] <= carry_pipe[0]; // hold stable or could assign 0 here but better to hold
            end

            // Compute sums and propagate carry from combinational results into pipeline registers
            for (i = 0; i < STAGES; i = i + 1) begin
                sum_pipe[i] <= sum_carry[i][WIDTH_PER_STAGE-1:0];
                carry_pipe[i+1] <= sum_carry[i][WIDTH_PER_STAGE];
            end

            // Output enable and result valid only when last stage enable is asserted
            o_en <= en_pipe[STAGES];
            if (en_pipe[STAGES]) begin
                // Concatenate sum slices from least significant to most significant stage,
                // then append final carry out as MSB.
                result <= {
                    carry_pipe[STAGES],
                    sum_pipe[STAGES-1],
                    sum_pipe[STAGES-2],
                    sum_pipe[STAGES-3],
                    sum_pipe[STAGES-4],
                    sum_pipe[STAGES-5],
                    sum_pipe[STAGES-6],
                    sum_pipe[STAGES-7],
                    sum_pipe[0]
                };
            end else begin
                // Hold previous result value if no valid output yet
                result <= result;
            end
        end
    end

endmodule