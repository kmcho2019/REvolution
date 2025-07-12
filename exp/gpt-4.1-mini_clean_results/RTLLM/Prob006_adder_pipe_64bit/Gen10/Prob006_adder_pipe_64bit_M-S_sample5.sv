module adder_pipe_64bit (
    input               clk,
    input               rst_n,
    input               i_en,
    input   [63:0]      adda,
    input   [63:0]      addb,
    output reg [64:0]   result,
    output reg          o_en
);

    localparam STG_WIDTH = 8;
    localparam STAGES = 64 / STG_WIDTH;

    // Pipeline registers for operand slices, carry-in, and enable signals
    reg [STG_WIDTH-1:0] adda_pipe [0:STAGES-1];
    reg [STG_WIDTH-1:0] addb_pipe [0:STAGES-1];
    reg                 carry_pipe [0:STAGES];
    reg                 en_pipe [0:STAGES];

    // Wires for sums from each pipeline stage
    wire [STG_WIDTH:0] sum_stage [0:STAGES-1]; // {carry_out, sum_bits}

    integer i;

    // Combinational adders for each pipeline stage
    generate
        genvar stage;
        for (stage = 0; stage < STAGES; stage = stage + 1) begin : gen_adders
            assign sum_stage[stage] = adda_pipe[stage] + addb_pipe[stage] + carry_pipe[stage];
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset pipeline registers
            for (i = 0; i < STAGES; i = i + 1) begin
                adda_pipe[i] <= 0;
                addb_pipe[i] <= 0;
                carry_pipe[i] <= 0;
                en_pipe[i] <= 0;
            end
            carry_pipe[STAGES] <= 0;
            en_pipe[STAGES] <= 0;
            result <= 0;
            o_en <= 0;
        end else begin
            // Stage 0: load operands and carry_in = 0
            adda_pipe[0] <= adda[STG_WIDTH-1:0];
            addb_pipe[0] <= addb[STG_WIDTH-1:0];
            carry_pipe[0] <= 0;
            en_pipe[0] <= i_en;

            // Subsequent stages: load operand slices, carry from previous sum, propagate enable
            for (i = 1; i < STAGES; i = i + 1) begin
                adda_pipe[i] <= adda[i*STG_WIDTH +: STG_WIDTH];
                addb_pipe[i] <= addb[i*STG_WIDTH +: STG_WIDTH];
                carry_pipe[i] <= sum_stage[i-1][STG_WIDTH];  // carry out from previous stage
                en_pipe[i] <= en_pipe[i-1];
            end

            // Final carry_out and enable
            carry_pipe[STAGES] <= sum_stage[STAGES-1][STG_WIDTH];
            en_pipe[STAGES] <= en_pipe[STAGES-1];

            // Assemble result from sums and final carry
            result <= {carry_pipe[STAGES],
                       sum_stage[STAGES-1][STG_WIDTH-1:0],
                       sum_stage[STAGES-2][STG_WIDTH-1:0],
                       sum_stage[STAGES-3][STG_WIDTH-1:0],
                       sum_stage[STAGES-4][STG_WIDTH-1:0],
                       sum_stage[STAGES-5][STG_WIDTH-1:0],
                       sum_stage[STAGES-6][STG_WIDTH-1:0],
                       sum_stage[STAGES-7][STG_WIDTH-1:0]};
            o_en <= en_pipe[STAGES];
        end
    end

endmodule