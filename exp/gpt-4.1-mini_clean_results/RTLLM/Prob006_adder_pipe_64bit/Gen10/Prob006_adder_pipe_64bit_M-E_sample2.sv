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

    // Sequential pipeline update
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
            // Stage 0: load input operands and initialize carry_in=0
            adda_pipe[0]  <= adda[ 7: 0];
            addb_pipe[0]  <= addb[ 7: 0];
            carry_pipe[0] <= 1'b0;   // carry_in to first stage is zero
            en_pipe[0]    <= i_en;

            // For subsequent stages (1 to 7), register operand slices, carry_in and enable
            for (i = 1; i < STAGES; i = i + 1) begin
                adda_pipe[i]  <= adda[(i*8) +: 8];
                addb_pipe[i]  <= addb[(i*8) +: 8];
                carry_pipe[i] <= carry_pipe[i-1 +:1]; // placeholder, will be updated below
                en_pipe[i]    <= en_pipe[i-1];
            end

            // Calculate sums and carry-out for each stage, update sum_pipe and carry_pipe for next stage
            // This has to be combinational but registered, so we pipeline the calculation inside the always block with blocking assignments to get correct carry propagation

            // First compute sums for each stage based on registered operands and carry_pipe inputs
            // To keep code clean and synchronous, compute sums and carry in a temporary variable here, then update registers after loop

            reg [STG_BITS:0] sum_with_carry [0:STAGES-1]; // 9-bit for sum + carry

            // Calculate sum_with_carry for stage 0 using registered inputs and carry_pipe[0]
            sum_with_carry[0] = adda_pipe[0] + addb_pipe[0] + carry_pipe[0];

            // For stages 1 to 7, calculate sum_with_carry based on operands and carry from previous stage
            for (i = 1; i < STAGES; i = i + 1) begin
                sum_with_carry[i] = adda_pipe[i] + addb_pipe[i] + carry_pipe[i];
            end

            // Now update sum_pipe and carry_pipe[1:STAGES] with the result
            // carry_pipe[0] already updated above (set to 0 for stage 0 carry_in)
            for (i = 0; i < STAGES; i = i + 1) begin
                sum_pipe[i] <= sum_with_carry[i][7:0];        // sum bits
            end
            for (i = 1; i <= STAGES; i = i + 1) begin
                carry_pipe[i] <= sum_with_carry[i-1][8];     // carry out to next stage
            end

            // Propagate enable from last stage to output stage
            en_pipe[STAGES] <= en_pipe[STAGES-1];

            // Assemble result and output enable when last stage valid
            if (en_pipe[STAGES]) begin
                // Concatenate sums and final carry out
                result <= {
                    carry_pipe[STAGES],
                    sum_pipe[STAGES-1],
                    sum_pipe[STAGES-2],
                    sum_pipe[STAGES-3],
                    sum_pipe[STAGES-4],
                    sum_pipe[STAGES-5],
                    sum_pipe[STAGES-6],
                    sum_pipe[STAGES-7]
                };
                o_en <= 1'b1;
            end else begin
                o_en <= 1'b0;
            end
        end
    end

endmodule