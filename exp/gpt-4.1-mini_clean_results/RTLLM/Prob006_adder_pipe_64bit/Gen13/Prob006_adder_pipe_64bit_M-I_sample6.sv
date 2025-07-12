module adder_pipe_64bit (
    input             clk,
    input             rst_n,
    input             i_en,
    input      [63:0] adda,
    input      [63:0] addb,
    output reg [64:0] result,
    output reg        o_en
);

    localparam STAGES = 8;
    localparam STG_BITS = 8;

    integer i;

    // Pipeline registers for operand slices (8 bits each stage)
    reg [STG_BITS-1:0] adda_pipe   [0:STAGES-1];
    reg [STG_BITS-1:0] addb_pipe   [0:STAGES-1];

    // Registered sum outputs per stage (8 bits each)
    reg [STG_BITS-1:0] sum_pipe    [0:STAGES-1];

    // Carry_in for each stage (1 bit)
    reg carry_pipe  [0:STAGES]; // carry_pipe[0] is carry_in for stage 0

    // Enable signals per stage to track valid data
    reg en_pipe     [0:STAGES];

    // Temporary sum (9 bits) wires for each stage (combinational)
    wire [STG_BITS:0] temp_sum [0:STAGES-1];

    // Combinational addition per stage: operands + carry_in
    genvar gv;
    generate
        for (gv = 0; gv < STAGES; gv = gv + 1) begin : ADD_STAGES
            assign temp_sum[gv] = adda_pipe[gv] + addb_pipe[gv] + carry_pipe[gv];
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Initialize pipeline registers and outputs to zero
            for (i = 0; i < STAGES; i = i + 1) begin
                adda_pipe[i]  <= {STG_BITS{1'b0}};
                addb_pipe[i]  <= {STG_BITS{1'b0}};
                sum_pipe[i]   <= {STG_BITS{1'b0}};
                carry_pipe[i] <= 1'b0;
                en_pipe[i]    <= 1'b0;
            end
            carry_pipe[STAGES] <= 1'b0;
            en_pipe[STAGES]    <= 1'b0;
            result             <= {65{1'b0}};
            o_en               <= 1'b0;
        end else begin
            // Pipeline data movement and computation

            // Stage 0: load operands and input enable when i_en is high
            if (i_en) begin
                adda_pipe[0] <= adda[7:0];
                addb_pipe[0] <= addb[7:0];
                en_pipe[0]   <= 1'b1;
            end else begin
                // If no input enable, invalidate stage 0 data
                adda_pipe[0] <= {STG_BITS{1'b0}};
                addb_pipe[0] <= {STG_BITS{1'b0}};
                en_pipe[0]   <= 1'b0;
            end
            carry_pipe[0] <= 1'b0; // No carry-in at stage 0

            // Stages 1 to 7: propagate operands, enable, and carry from previous stage
            for (i = 1; i < STAGES; i = i + 1) begin
                adda_pipe[i] <= adda_pipe[i-1];
                addb_pipe[i] <= addb_pipe[i-1];
                carry_pipe[i] <= temp_sum[i-1][STG_BITS]; // carry out from previous stage sum
                en_pipe[i] <= en_pipe[i-1];
            end

            // Compute sums for all stages and register results
            for (i = 0; i < STAGES; i = i + 1) begin
                sum_pipe[i] <= temp_sum[i][STG_BITS-1:0];
            end

            // Final carry (carry out of stage 7) to carry_pipe[STAGES]
            carry_pipe[STAGES] <= temp_sum[STAGES-1][STG_BITS];

            // Propagate enable to output stage
            en_pipe[STAGES] <= en_pipe[STAGES-1];

            // When output stage enable asserted, assemble full 65-bit sum
            if (en_pipe[STAGES]) begin
                // Concatenate sums MSB to LSB plus final carry out
                // Using a for loop for assembling result vector
                reg [64:0] sum_assembled;
                for (i = 0; i < STAGES; i = i + 1) begin
                    sum_assembled[i*STG_BITS +: STG_BITS] = sum_pipe[i];
                end
                sum_assembled[64] = carry_pipe[STAGES];

                result <= sum_assembled;
                o_en   <= 1'b1;
            end else begin
                result <= {65{1'b0}};
                o_en   <= 1'b0;
            end
        end
    end

endmodule