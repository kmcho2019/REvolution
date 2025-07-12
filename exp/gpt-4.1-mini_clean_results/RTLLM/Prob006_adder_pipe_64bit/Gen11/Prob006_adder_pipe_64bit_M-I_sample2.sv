module adder_pipe_64bit (
    input             clk,
    input             rst_n,
    input             i_en,
    input   [63:0]    adda,
    input   [63:0]    addb,
    output reg [64:0] result,
    output reg        o_en
);

    localparam STAGES = 8;
    localparam STG_BITS = 8;

    // Pipeline registers for operand slices (8 bits each stage)
    reg [STG_BITS-1:0] adda_pipe   [0:STAGES-1];
    reg [STG_BITS-1:0] addb_pipe   [0:STAGES-1];
    // Registered sum outputs per stage (8 bits each)
    reg [STG_BITS-1:0] sum_pipe    [0:STAGES-1];
    // Registered carry signal per stage (1 bit), carry_in for stage 0 is 0
    reg                carry_pipe  [0:STAGES];
    // Enable signals per stage, to track valid data
    reg                en_pipe     [0:STAGES];

    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers and outputs
            for (i = 0; i < STAGES; i = i + 1) begin
                adda_pipe[i]   <= 8'b0;
                addb_pipe[i]   <= 8'b0;
                sum_pipe[i]    <= 8'b0;
                carry_pipe[i]  <= 1'b0;
                en_pipe[i]     <= 1'b0;
            end
            carry_pipe[STAGES] <= 1'b0;
            en_pipe[STAGES]    <= 1'b0;
            result             <= 65'b0;
            o_en               <= 1'b0;
        end else begin
            // Stage 0: latch operands and carry_in=0
            adda_pipe[0]  <= adda[7:0];
            addb_pipe[0]  <= addb[7:0];
            carry_pipe[0] <= 1'b0;
            en_pipe[0]    <= i_en;

            // For stages 1 to 7: latch operands, carry_in, enable from previous stage
            for (i = 1; i < STAGES; i = i + 1) begin
                adda_pipe[i]  <= adda[i*8 +: 8];
                addb_pipe[i]  <= addb[i*8 +: 8];
                carry_pipe[i] <= carry_pipe[i-1+1]; // carry_pipe[i-1+1] is carry out from previous stage in previous clock
                en_pipe[i]    <= en_pipe[i-1];
            end

            // Compute sums and carry_out for each stage, update sum_pipe and carry_pipe for next stage
            // Note: carry_pipe[i] is carry_in for stage i,
            // We compute sum and carry_out here and register them synchronously.

            // Temporary variables for sum and carry computation
            reg [STG_BITS:0] temp_sum [0:STAGES-1];
            // carry_out will be temp_sum[?][8]

            for (i = 0; i < STAGES; i = i + 1) begin
                temp_sum[i] = adda_pipe[i] + addb_pipe[i] + carry_pipe[i];
                sum_pipe[i] <= temp_sum[i][7:0];
            end

            // Update carry_pipe for next stage (carry_out)
            // carry_pipe[0] was assigned above (carry_in for stage 0 = 0)
            for (i = 1; i <= STAGES; i = i + 1) begin
                carry_pipe[i] <= temp_sum[i-1][8];
            end

            // Propagate enable for output stage
            en_pipe[STAGES] <= en_pipe[STAGES-1];

            // Assemble final result and output enable when valid
            if (en_pipe[STAGES]) begin
                // Concatenate sums from stage 7 down to 0 plus final carry out as MSB
                result <= {
                    carry_pipe[STAGES],
                    sum_pipe[7],
                    sum_pipe[6],
                    sum_pipe[5],
                    sum_pipe[4],
                    sum_pipe[3],
                    sum_pipe[2],
                    sum_pipe[1],
                    sum_pipe[0]
                };
                o_en <= 1'b1;
            end else begin
                o_en <= 1'b0;
                result <= 65'b0;
            end
        end
    end

endmodule