module adder_pipe_64bit (
    input  wire         clk,
    input  wire         rst_n,
    input  wire         i_en,
    input  wire [63:0]  adda,
    input  wire [63:0]  addb,
    output reg  [64:0]  result,
    output reg          o_en
);
    localparam STAGES = 8;
    localparam STG_WIDTH = 8;

    // Pipeline registers for operand slices, sum slices, carry, and enable
    reg [STG_WIDTH-1:0] adda_stage [0:STAGES-1];
    reg [STG_WIDTH-1:0] addb_stage [0:STAGES-1];
    reg [STG_WIDTH-1:0] sum_stage  [0:STAGES-1];
    reg carry_stage [0:STAGES];  // carry_stage[0] is initial carry-in = 0
    reg en_stage [0:STAGES];

    integer i;
    reg [STG_WIDTH:0] add_res;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            carry_stage[0] <= 1'b0;
            for (i = 0; i < STAGES; i = i + 1) begin
                adda_stage[i] <= 0;
                addb_stage[i] <= 0;
                sum_stage[i] <= 0;
                carry_stage[i+1] <= 0;
                en_stage[i] <= 0;
            end
            en_stage[STAGES] <= 0;
            result <= 0;
            o_en <= 0;
        end else begin
            // Load input slices and initial carry & enable at stage 0
            adda_stage[0] <= adda[7:0];
            addb_stage[0] <= addb[7:0];
            carry_stage[0] <= 1'b0;
            en_stage[0] <= i_en;

            // For each pipeline stage
            for (i = 0; i < STAGES; i = i + 1) begin
                // For stage > 0, load operand slices from inputs
                if (i > 0) begin
                    adda_stage[i] <= adda[i*STG_WIDTH +: STG_WIDTH];
                    addb_stage[i] <= addb[i*STG_WIDTH +: STG_WIDTH];
                    en_stage[i] <= en_stage[i-1];
                end
                // Compute sum and carry-out
                add_res = adda_stage[i] + addb_stage[i] + carry_stage[i];
                sum_stage[i] <= add_res[STG_WIDTH-1:0];
                carry_stage[i+1] <= add_res[STG_WIDTH];
            end
            // Propagate enable to last stage
            en_stage[STAGES] <= en_stage[STAGES-1];

            // Assemble final result and output enable
            o_en <= en_stage[STAGES];
            if (en_stage[STAGES]) begin
                result <= {carry_stage[STAGES],
                           sum_stage[STAGES-1],
                           sum_stage[STAGES-2],
                           sum_stage[STAGES-3],
                           sum_stage[STAGES-4],
                           sum_stage[STAGES-5],
                           sum_stage[STAGES-6],
                           sum_stage[STAGES-7],
                           sum_stage[0]};
            end else begin
                result <= 0;
            end
        end
    end
endmodule