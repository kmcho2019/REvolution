module adder_pipe_64bit #(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH  = 8
)(
    input                       clk,
    input                       rst_n,
    input                       i_en,
    input  [DATA_WIDTH-1:0]     adda,
    input  [DATA_WIDTH-1:0]     addb,
    output reg [DATA_WIDTH:0]   result,
    output reg                  o_en
);

    localparam NUM_STAGES = DATA_WIDTH / STG_WIDTH;

    integer idx;

    // Pipeline registers for operands and sums:
    // Using packed 2D arrays: stage index first dimension
    reg [STG_WIDTH-1:0] adda_pipe   [0:NUM_STAGES-1];
    reg [STG_WIDTH-1:0] addb_pipe   [0:NUM_STAGES-1];
    reg [STG_WIDTH-1:0] sum_pipe    [0:NUM_STAGES-1];

    // Carry signals between stages: one extra for final carry out
    reg carry_pipe [0:NUM_STAGES];

    // Pipeline enable registers to track validity of pipeline stages + output
    reg en_pipe [0:NUM_STAGES];

    // Combinational signal for assembling output
    reg [DATA_WIDTH:0] assembled_result;

    // Pipeline registers update and sum calculation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset pipeline registers
            for (idx = 0; idx < NUM_STAGES; idx = idx + 1) begin
                adda_pipe[idx] <= {STG_WIDTH{1'b0}};
                addb_pipe[idx] <= {STG_WIDTH{1'b0}};
                sum_pipe[idx]  <= {STG_WIDTH{1'b0}};
                en_pipe[idx]   <= 1'b0;
                carry_pipe[idx] <= 1'b0;
            end
            carry_pipe[NUM_STAGES] <= 1'b0;
            en_pipe[NUM_STAGES] <= 1'b0;

            result <= {(DATA_WIDTH+1){1'b0}};
            o_en <= 1'b0;
        end else begin
            // Shift enable pipeline forward; load i_en into stage 0 enable
            en_pipe[0] <= i_en;
            for (idx = 1; idx <= NUM_STAGES; idx = idx + 1) begin
                en_pipe[idx] <= en_pipe[idx - 1];
            end

            // Shift operand pipeline registers:
            // Load operands at stage 0 only when i_en is asserted
            if (i_en) begin
                for (idx = 0; idx < NUM_STAGES; idx = idx + 1) begin
                    adda_pipe[idx] <= adda[ idx*STG_WIDTH +: STG_WIDTH ];
                    addb_pipe[idx] <= addb[ idx*STG_WIDTH +: STG_WIDTH ];
                end
            end else begin
                // Shift operands down pipeline stages
                for (idx = NUM_STAGES-1; idx > 0; idx = idx - 1) begin
                    adda_pipe[idx] <= adda_pipe[idx -1];
                    addb_pipe[idx] <= addb_pipe[idx -1];
                end
                // For stage 0, hold previous operands to preserve data flow
                // (Alternatively, zero stage 0 to indicate no new input)
                // Choosing to hold data to maintain continuous pipeline flow
                adda_pipe[0] <= adda_pipe[0];
                addb_pipe[0] <= addb_pipe[0];
            end

            // Carry pipeline:
            // At stage 0: reset carry_in to 0 when new input arrives, else shift carry from last stage
            if (i_en) begin
                carry_pipe[0] <= 1'b0;
            end else begin
                carry_pipe[0] <= carry_pipe[NUM_STAGES];
            end

            // For stages 1 to NUM_STAGES: shift carry forward
            for (idx = 1; idx <= NUM_STAGES; idx = idx + 1) begin
                // We'll assign carry_pipe[idx] after sum calculation below
                // This is done in sum calculation loop to avoid combinational feedback
            end

            // Calculate sum and carry for each stage
            // sum_pipe and carry_pipe updated synchronously on clock
            for (idx = 0; idx < NUM_STAGES; idx = idx + 1) begin
                // Use addition with carry_pipe[idx] as carry-in
                {carry_pipe[idx + 1], sum_pipe[idx]} <= adda_pipe[idx] + addb_pipe[idx] + carry_pipe[idx];
            end

            // Output logic: output enable is valid when last stage enable is asserted
            o_en <= en_pipe[NUM_STAGES];

            // Update result output only when valid
            if (en_pipe[NUM_STAGES]) begin
                result <= assembled_result;
            end else begin
                result <= result; // Hold previous result if no new valid output
            end
        end
    end

    // Assemble final 65-bit result combinationally from sums and final carry
    always @(*) begin
        // Concatenate sums starting from MSB stage down to LSB stage
        // Then prepend final carry out as MSB bit
        assembled_result = {carry_pipe[NUM_STAGES], 
                            sum_pipe[NUM_STAGES-1]};
        for (idx = NUM_STAGES-2; idx >= 0; idx = idx - 1) begin
            assembled_result = {assembled_result, sum_pipe[idx]};
        end
    end

endmodule