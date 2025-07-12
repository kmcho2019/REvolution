module adder_pipe_64bit (
    input               clk,
    input               rst_n,
    input               i_en,
    input       [63:0]  adda,
    input       [63:0]  addb,
    output reg  [64:0]  result,
    output reg          o_en
);

    localparam STG_BITS = 16;
    localparam NUM_STG  = 4;

    // Pipeline registers for operand slices
    reg [STG_BITS-1:0] adda_pipe [0:NUM_STG-1];
    reg [STG_BITS-1:0] addb_pipe [0:NUM_STG-1];

    // Pipeline registers for sum slices
    reg [STG_BITS-1:0] sum_pipe [0:NUM_STG-1];

    // Carry registers between stages (NUM_STG+1)
    reg carry_pipe [0:NUM_STG];

    // Enable pipeline registers (NUM_STG+1)
    reg en_pipe [0:NUM_STG];

    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < NUM_STG; i = i + 1) begin
                adda_pipe[i] <= {STG_BITS{1'b0}};
                addb_pipe[i] <= {STG_BITS{1'b0}};
                sum_pipe[i]  <= {STG_BITS{1'b0}};
                carry_pipe[i] <= 1'b0;
                en_pipe[i]    <= 1'b0;
            end
            carry_pipe[NUM_STG] <= 1'b0;
            en_pipe[NUM_STG]    <= 1'b0;
            result <= 65'b0;
            o_en   <= 1'b0;
        end else begin
            // Stage 0: latch inputs slices, carry_in=0, enable = i_en
            if (i_en) begin
                for (i = 0; i < NUM_STG; i = i + 1) begin
                    adda_pipe[i] <= adda[STG_BITS*i +: STG_BITS];
                    addb_pipe[i] <= addb[STG_BITS*i +: STG_BITS];
                end
            end else begin
                for (i = 0; i < NUM_STG; i = i + 1) begin
                    adda_pipe[i] <= adda_pipe[i];
                    addb_pipe[i] <= addb_pipe[i];
                end
            end
            carry_pipe[0] <= 1'b0;
            en_pipe[0] <= i_en;

            // Compute sum and carry out stage by stage
            // Each stage uses the registered carry in
            for (i = 0; i < NUM_STG; i = i + 1) begin
                {carry_pipe[i+1], sum_pipe[i]} <= adda_pipe[i] + addb_pipe[i] + carry_pipe[i];
            end

            // Pipeline enable signal
            for (i = 1; i <= NUM_STG; i = i + 1) begin
                en_pipe[i] <= en_pipe[i-1];
            end

            // When last stage enable is high, assemble final result
            if (en_pipe[NUM_STG]) begin
                // Concatenate sums from MSB stage to LSB stage with final carry out
                // sum_pipe[0] = bits [15:0], sum_pipe[1] = bits [31:16], etc.
                result <= {carry_pipe[NUM_STG],
                           sum_pipe[NUM_STG-1],
                           sum_pipe[NUM_STG-2],
                           sum_pipe[NUM_STG-3],
                           sum_pipe[0]};
            end else begin
                result <= result; // hold previous value
            end

            o_en <= en_pipe[NUM_STG];
        end
    end

endmodule