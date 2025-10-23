module adder_pipe_64bit (
    input              clk,
    input              rst_n,
    input              i_en,
    input      [63:0]  adda,
    input      [63:0]  addb,
    output reg [64:0]  result,
    output reg         o_en
);

    // Parameters for pipeline stages and bit width per stage
    localparam STAGES = 8;
    localparam WIDTH_PER_STAGE = 8;

    // Pipeline registers for operand slices
    reg [WIDTH_PER_STAGE-1:0] adda_pipe [0:STAGES-1];
    reg [WIDTH_PER_STAGE-1:0] addb_pipe [0:STAGES-1];

    // Pipeline registers for partial sums
    reg [WIDTH_PER_STAGE-1:0] sum_pipe [0:STAGES-1];

    // Pipeline register for carry signals, length STAGES+1 for carry in and final carry out
    reg carry_pipe [0:STAGES];

    // Pipeline registers for enable signals (to track valid data)
    reg en_pipe [0:STAGES];

    integer i;

    // Combinational wires for sum and carry per stage
    wire [WIDTH_PER_STAGE:0] sum_carry [0:STAGES-1]; // [WIDTH_PER_STAGE] bit is carry out

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
            result <= {65{1'b0}};
            o_en <= 1'b0;
        end else begin
            // Stage 0: latch inputs slices only when i_en is high
            if (i_en) begin
                for (i = 0; i < STAGES; i = i + 1) begin
                    adda_pipe[i] <= adda[i*WIDTH_PER_STAGE +: WIDTH_PER_STAGE];
                    addb_pipe[i] <= addb[i*WIDTH_PER_STAGE +: WIDTH_PER_STAGE];
                end
            end else begin
                // Hold previous values if no input enable
                for (i = 0; i < STAGES; i = i + 1) begin
                    adda_pipe[i] <= adda_pipe[i];
                    addb_pipe[i] <= addb_pipe[i];
                end
            end

            // Initialize carry at start of pipeline to 0
            carry_pipe[0] <= 1'b0;
            // Propagate enable signal into pipeline stage 0
            en_pipe[0] <= i_en;

            // Capture sums, propagate carry and enable through pipeline stages
            for (i = 0; i < STAGES; i = i + 1) begin
                sum_pipe[i] <= sum_carry[i][WIDTH_PER_STAGE-1:0];
                carry_pipe[i+1] <= sum_carry[i][WIDTH_PER_STAGE];
                en_pipe[i+1] <= en_pipe[i];
            end

            // Output result and enable when last pipeline stage valid
            o_en <= en_pipe[STAGES];
            if (en_pipe[STAGES]) begin
                // Concatenate sums from MSB stage to LSB stage and append carry out
                // sum_pipe[STAGES-1] is most significant 8 bits slice
                result <= {carry_pipe[STAGES],
                           sum_pipe[STAGES-1],
                           sum_pipe[STAGES-2],
                           sum_pipe[STAGES-3],
                           sum_pipe[STAGES-4],
                           sum_pipe[STAGES-5],
                           sum_pipe[STAGES-6],
                           sum_pipe[STAGES-7],
                           sum_pipe[0]};
            end else begin
                result <= result; // hold previous value
            end
        end
    end

endmodule