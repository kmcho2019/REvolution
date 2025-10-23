module adder_pipe_64bit (
    input              clk,
    input              rst_n,
    input              i_en,
    input       [63:0] adda,
    input       [63:0] addb,
    output reg [64:0]  result,
    output reg         o_en
);

    localparam STG_BITS = 4;
    localparam NUM_STG  = 64 / STG_BITS; // 16 stages

    // Pipeline registers for operands slices
    reg [STG_BITS-1:0] adda_pipe  [0:NUM_STG-1];
    reg [STG_BITS-1:0] addb_pipe  [0:NUM_STG-1];

    // Sum registers per stage
    reg [STG_BITS-1:0] sum_pipe   [0:NUM_STG-1];

    // Carry registers between stages, one more than stages
    reg carry_pipe [0:NUM_STG];

    // Pipeline enable signals to track valid data through pipeline
    reg en_pipe [0:NUM_STG];

    integer i;

    // Synchronous logic for pipelined ripple carry addition
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers
            for (i = 0; i < NUM_STG; i = i + 1) begin
                adda_pipe[i]  <= {STG_BITS{1'b0}};
                addb_pipe[i]  <= {STG_BITS{1'b0}};
                sum_pipe[i]   <= {STG_BITS{1'b0}};
                carry_pipe[i] <= 1'b0;
                en_pipe[i]    <= 1'b0;
            end
            carry_pipe[NUM_STG] <= 1'b0;
            en_pipe[NUM_STG]    <= 1'b0;
            result             <= {65{1'b0}};
            o_en               <= 1'b0;
        end else begin
            // Stage 0: Load first 4 bits of inputs and start carry=0, enable=i_en
            if (i_en) begin
                adda_pipe[0] <= adda[STG_BITS*0 +: STG_BITS];
                addb_pipe[0] <= addb[STG_BITS*0 +: STG_BITS];
            end else begin
                // Hold previous values if no enable
                adda_pipe[0] <= adda_pipe[0];
                addb_pipe[0] <= addb_pipe[0];
            end
            carry_pipe[0] <= 1'b0; // carry in to stage 0 is zero
            en_pipe[0]    <= i_en;

            // Pipeline operands slices from inputs for stages 1..15
            for (i = 1; i < NUM_STG; i = i + 1) begin
                if (en_pipe[i-1]) begin
                    adda_pipe[i] <= adda[STG_BITS*i +: STG_BITS];
                    addb_pipe[i] <= addb[STG_BITS*i +: STG_BITS];
                end else begin
                    adda_pipe[i] <= adda_pipe[i];
                    addb_pipe[i] <= addb_pipe[i];
                end
                // propagate enable through pipeline
                en_pipe[i] <= en_pipe[i-1];
            end

            // Compute sum and carry for all stages based on previous carry_pipe
            for (i = 0; i < NUM_STG; i = i + 1) begin
                {carry_pipe[i+1], sum_pipe[i]} <= adda_pipe[i] + addb_pipe[i] + carry_pipe[i];
            end

            // Propagate enable to last carry pipeline register
            en_pipe[NUM_STG] <= en_pipe[NUM_STG-1];

            // Assemble final 65-bit result when output is valid
            if (en_pipe[NUM_STG]) begin
                // Concatenate sums from MSB stage to LSB stage plus final carry
                result <= {carry_pipe[NUM_STG],
                           sum_pipe[NUM_STG-1], sum_pipe[NUM_STG-2],
                           sum_pipe[NUM_STG-3], sum_pipe[NUM_STG-4],
                           sum_pipe[NUM_STG-5], sum_pipe[NUM_STG-6],
                           sum_pipe[NUM_STG-7], sum_pipe[NUM_STG-8],
                           sum_pipe[NUM_STG-9], sum_pipe[NUM_STG-10],
                           sum_pipe[NUM_STG-11], sum_pipe[NUM_STG-12],
                           sum_pipe[NUM_STG-13], sum_pipe[NUM_STG-14],
                           sum_pipe[NUM_STG-15], sum_pipe[0]};
            end else begin
                // Hold previous result if no output enable
                result <= result;
            end

            // Output enable reflects pipeline status
            o_en <= en_pipe[NUM_STG];
        end
    end

endmodule