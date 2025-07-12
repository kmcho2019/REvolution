module adder_pipe_64bit #(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH  = 16,
    parameter STAGES     = DATA_WIDTH / STG_WIDTH
)(
    input                       clk,
    input                       rst_n,
    input                       i_en,
    input       [DATA_WIDTH-1:0] adda,
    input       [DATA_WIDTH-1:0] addb,
    output reg  [DATA_WIDTH:0]  result,
    output reg                  o_en
);

    // Pipeline registers for sliced operands, sums, enables
    reg [STG_WIDTH-1:0] add_a_s [0:STAGES-1];
    reg [STG_WIDTH-1:0] add_b_s [0:STAGES-1];

    reg [STG_WIDTH-1:0] sum_s   [0:STAGES-1];
    reg                 en_s    [0:STAGES-1];

    // Carry registers:
    // carry_in for stage 0 is always zero for each addition start.
    // carry_out for each stage feeds carry_in for next stage.
    reg                 carry_in  [0:STAGES];
    reg                 carry_out [0:STAGES-1];

    // Enable pipeline to produce output valid (o_en)
    reg [STAGES-1:0] en_pipeline;

    integer i;

    // On reset, clear all registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < STAGES; i = i + 1) begin
                add_a_s[i] <= {STG_WIDTH{1'b0}};
                add_b_s[i] <= {STG_WIDTH{1'b0}};
                sum_s[i]   <= {STG_WIDTH{1'b0}};
                en_s[i]    <= 1'b0;
                carry_out[i] <= 1'b0;
            end
            for (i = 0; i <= STAGES; i = i + 1) begin
                carry_in[i] <= 1'b0;
            end
            en_pipeline <= {STAGES{1'b0}};
            result <= {(DATA_WIDTH+1){1'b0}};
            o_en <= 1'b0;
        end else begin
            // Enable pipeline shift register
            en_pipeline <= {en_pipeline[STAGES-2:0], i_en};

            // Stage 0: latch lower STG_WIDTH bits of inputs on i_en
            if (i_en) begin
                add_a_s[0] <= adda[STG_WIDTH-1:0];
                add_b_s[0] <= addb[STG_WIDTH-1:0];
                en_s[0]    <= 1'b1;
                carry_in[0] <= 1'b0; // carry_in for first stage always zero at addition start
            end else begin
                en_s[0] <= 1'b0;
                // carry_in[0] hold its value (or zero)
            end

            // Subsequent pipeline stages latch input slices from the original inputs
            for (i = 1; i < STAGES; i = i + 1) begin
                add_a_s[i] <= adda[(i+1)*STG_WIDTH-1 -: STG_WIDTH];
                add_b_s[i] <= addb[(i+1)*STG_WIDTH-1 -: STG_WIDTH];
                en_s[i] <= en_s[i-1]; // propagate enable down the pipeline
            end

            // Perform addition and carry propagation for all stages where enable is set
            for (i = 0; i < STAGES; i = i + 1) begin
                if (en_s[i]) begin
                    {carry_out[i], sum_s[i]} <= add_a_s[i] + add_b_s[i] + carry_in[i];
                end else begin
                    sum_s[i] <= {STG_WIDTH{1'b0}};
                    carry_out[i] <= 1'b0;
                end
            end

            // Update carry_in for next stage (carry_out of current stage)
            for (i = 1; i <= STAGES; i = i + 1) begin
                carry_in[i] <= carry_out[i-1];
            end

            // Assemble the final result on clock edge using concatenation of sums and final carry_out
            // The MSB of result is the carry_out from last stage (STAGES-1)
            // Followed by concatenation of sum_s slices from MSB stage down to LSB stage
            // sum_s[STAGES-1] ... sum_s[0]
            reg [DATA_WIDTH:0] result_assembled;
            integer j;
            result_assembled = {carry_out[STAGES-1], sum_s[STAGES-1]};
            for (j = STAGES-2; j >= 0; j = j - 1) begin
                result_assembled = {result_assembled, sum_s[j]};
            end

            result <= result_assembled;
            o_en <= en_pipeline[STAGES-1];
        end
    end

endmodule