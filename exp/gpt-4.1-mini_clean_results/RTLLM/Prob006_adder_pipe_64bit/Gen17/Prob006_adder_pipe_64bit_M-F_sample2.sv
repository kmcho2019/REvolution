module adder_pipe_64bit #(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH  = 8
)(
    input                      clk,
    input                      rst_n,
    input                      i_en,
    input      [DATA_WIDTH-1:0] adda,
    input      [DATA_WIDTH-1:0] addb,
    output reg [DATA_WIDTH:0]   result,
    output reg                 o_en
);

    // Number of pipeline stages
    localparam NUM_STAGES = DATA_WIDTH / STG_WIDTH;

    // Pipeline registers for sums (STG_WIDTH bits each) and carries (1 bit)
    reg [STG_WIDTH-1:0] sum [0:NUM_STAGES-1];
    reg carry [1:NUM_STAGES];
    reg en_pipeline [0:NUM_STAGES];

    integer i;

    // Wires for stage sum outputs
    wire [STG_WIDTH:0] stage_sum [0:NUM_STAGES-1];

    // Generate wires for each stage sum
    generate
        genvar gi;
        for (gi = 0; gi < NUM_STAGES; gi = gi + 1) begin : gen_stage_sum
            wire carry_in = (gi == 0) ? 1'b0 : carry[gi];
            assign stage_sum[gi] = {1'b0, adda[(gi+1)*STG_WIDTH-1 -: STG_WIDTH]} 
                                  + {1'b0, addb[(gi+1)*STG_WIDTH-1 -: STG_WIDTH]} 
                                  + carry_in;
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset pipeline registers
            for (i = 0; i < NUM_STAGES; i = i + 1) begin
                sum[i]     <= {STG_WIDTH{1'b0}};
                carry[i+1] <= 1'b0;
                en_pipeline[i] <= 1'b0;
            end
            carry[0] <= 1'b0;
            en_pipeline[NUM_STAGES] <= 1'b0;
            result <= {(DATA_WIDTH+1){1'b0}};
            o_en <= 1'b0;
        end else begin
            // Stage 0
            sum[0]     <= stage_sum[0][STG_WIDTH-1:0];
            carry[1]   <= stage_sum[0][STG_WIDTH];
            en_pipeline[0] <= i_en;

            // Remaining stages
            for (i = 1; i < NUM_STAGES; i = i + 1) begin
                sum[i]   <= stage_sum[i][STG_WIDTH-1:0];
                carry[i+1] <= stage_sum[i][STG_WIDTH];
                en_pipeline[i] <= en_pipeline[i-1];
            end

            // Final enable propagation
            en_pipeline[NUM_STAGES] <= en_pipeline[NUM_STAGES-1];

            // Output assignment when valid
            if (en_pipeline[NUM_STAGES]) begin
                // Concatenate all sums and final carry out
                result <= {carry[NUM_STAGES], 
                           sum[NUM_STAGES-1], sum[NUM_STAGES-2], sum[NUM_STAGES-3], sum[NUM_STAGES-4],
                           sum[NUM_STAGES-5], sum[NUM_STAGES-6], sum[NUM_STAGES-7], sum[NUM_STAGES-8]};
                o_en <= 1'b1;
            end else begin
                result <= {(DATA_WIDTH+1){1'b0}};
                o_en <= 1'b0;
            end
        end
    end

endmodule