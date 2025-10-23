module adder_pipe_64bit (
    input             clk,
    input             rst_n,
    input             i_en,
    input  [63:0]     adda,
    input  [63:0]     addb,
    output reg [64:0] result,
    output reg        o_en
);

    localparam STAGES = 4;
    localparam STAGE_WIDTH = 16;

    // Pipeline registers for operands and enables for each stage
    reg [63:0] adda_pipe [0:STAGES];
    reg [63:0] addb_pipe [0:STAGES];
    reg        en_pipe   [0:STAGES];

    // Carry register between stages
    reg carry_pipe [0:STAGES];

    // Partial sums from each stage
    reg [STAGE_WIDTH-1:0] sum_pipe [0:STAGES-1];

    integer i;

    // Combinational adder output wires
    wire [STAGE_WIDTH:0] adder_sum [0:STAGES-1];

    // Compute combinational adds for each stage based on pipeline registers
    genvar stage;
    generate
        for (stage = 0; stage < STAGES; stage = stage + 1) begin : adder_stages
            wire [STAGE_WIDTH-1:0] a_part = adda_pipe[stage][stage*STAGE_WIDTH +: STAGE_WIDTH];
            wire [STAGE_WIDTH-1:0] b_part = addb_pipe[stage][stage*STAGE_WIDTH +: STAGE_WIDTH];
            assign adder_sum[stage] = a_part + b_part + carry_pipe[stage];
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers
            for (i = 0; i <= STAGES; i = i + 1) begin
                adda_pipe[i] <= 64'd0;
                addb_pipe[i] <= 64'd0;
                en_pipe[i] <= 1'b0;
                carry_pipe[i] <= 1'b0;
            end
            for (i = 0; i < STAGES; i = i + 1) begin
                sum_pipe[i] <= {STAGE_WIDTH{1'b0}};
            end
            result <= 65'd0;
            o_en <= 1'b0;
        end else begin
            // Stage 0 input loading
            adda_pipe[0] <= adda;
            addb_pipe[0] <= addb;
            en_pipe[0] <= i_en;
            carry_pipe[0] <= 1'b0;  // initial carry-in is zero

            // Capture combinational outputs from stage 0
            sum_pipe[0] <= adder_sum[0][STAGE_WIDTH-1:0];
            carry_pipe[1] <= adder_sum[0][STAGE_WIDTH];

            // For stages 1 to STAGES-1
            for (i = 1; i < STAGES; i = i + 1) begin
                // Pipeline the operands and enable
                adda_pipe[i] <= adda_pipe[i-1];
                addb_pipe[i] <= addb_pipe[i-1];
                en_pipe[i] <= en_pipe[i-1];

                // sum and carry_out registers
                sum_pipe[i] <= adder_sum[i][STAGE_WIDTH-1:0];
                carry_pipe[i+1] <= adder_sum[i][STAGE_WIDTH];
            end

            // Advance enable and operands registers after final stage
            en_pipe[STAGES] <= en_pipe[STAGES-1];
            adda_pipe[STAGES] <= adda_pipe[STAGES-1];
            addb_pipe[STAGES] <= addb_pipe[STAGES-1];

            // When output is valid, assemble final result and set output enable
            if (en_pipe[STAGES]) begin
                // Concatenate partial sums and final carry-out
                result <= {carry_pipe[STAGES],
                           sum_pipe[STAGES-1],
                           sum_pipe[STAGES-2],
                           sum_pipe[STAGES-3],
                           sum_pipe[0]};
                o_en <= 1'b1;
            end else begin
                result <= 65'd0;
                o_en <= 1'b0;
            end
        end
    end

endmodule