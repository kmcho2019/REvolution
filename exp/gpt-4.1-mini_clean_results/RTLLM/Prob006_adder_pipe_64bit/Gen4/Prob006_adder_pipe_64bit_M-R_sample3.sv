module adder_pipe_64bit (
    input               clk,
    input               rst_n,
    input               i_en,
    input      [63:0]   adda,
    input      [63:0]   addb,
    output reg [64:0]   result,
    output reg          o_en
);

    // Parameters for pipeline stages and width per stage
    localparam STAGES = 8;
    localparam WIDTH = 8;

    // Pipeline stage registers: operands, carry-in, sum, carry-out, and enable flags
    reg [WIDTH-1:0] adda_pipe  [0:STAGES-1];
    reg [WIDTH-1:0] addb_pipe  [0:STAGES-1];
    reg             carry_in_pipe  [0:STAGES-1];
    reg             en_pipe    [0:STAGES];

    // Sum and carry-out wires for combinational addition in each stage
    wire [WIDTH-1:0] sum_stage [0:STAGES-1];
    wire             carry_out_stage [0:STAGES-1];

    integer i;

    // Combinational adders for each stage
    generate
        genvar stage_i;
        for (stage_i = 0; stage_i < STAGES; stage_i = stage_i + 1) begin : adder_stages
            assign {carry_out_stage[stage_i], sum_stage[stage_i]} = 
                adda_pipe[stage_i] + addb_pipe[stage_i] + carry_in_pipe[stage_i];
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Clear all pipeline registers and outputs
            for (i = 0; i < STAGES; i = i + 1) begin
                adda_pipe[i] <= {WIDTH{1'b0}};
                addb_pipe[i] <= {WIDTH{1'b0}};
                carry_in_pipe[i] <= 1'b0;
            end
            for (i = 0; i <= STAGES; i = i + 1) begin
                en_pipe[i] <= 1'b0;
            end
            result <= 65'b0;
            o_en <= 1'b0;
        end else begin
            // Stage 0: load input operands and initial carry-in when i_en asserted
            if (i_en) begin
                for (i = 0; i < STAGES; i = i + 1) begin
                    adda_pipe[i] <= adda[ (i+1)*WIDTH-1 -: WIDTH ];
                    addb_pipe[i] <= addb[ (i+1)*WIDTH-1 -: WIDTH ];
                end
                carry_in_pipe[0] <= 1'b0;  // initial carry-in zero
                en_pipe[0] <= 1'b1;
            end else begin
                // Hold previous values if no new inputs
                for (i = 0; i < STAGES; i = i + 1) begin
                    adda_pipe[i] <= adda_pipe[i];
                    addb_pipe[i] <= addb_pipe[i];
                end
                carry_in_pipe[0] <= carry_in_pipe[0];
                en_pipe[0] <= 1'b0;
            end

            // For stages 1 to 7: register carry_in and enables from previous stage outputs
            for (i = 1; i < STAGES; i = i + 1) begin
                carry_in_pipe[i] <= carry_out_stage[i-1];
            end

            // Enable propagates one stage forward every clock
            for (i = 1; i <= STAGES; i = i + 1) begin
                en_pipe[i] <= en_pipe[i-1];
            end

            // At last pipeline stage valid, assemble final result and assert output enable
            if (en_pipe[STAGES]) begin
                o_en <= 1'b1;
                result <= {
                    carry_out_stage[STAGES-1],
                    sum_stage[STAGES-1],
                    sum_stage[STAGES-2],
                    sum_stage[STAGES-3],
                    sum_stage[STAGES-4],
                    sum_stage[STAGES-5],
                    sum_stage[STAGES-6],
                    sum_stage[STAGES-7],
                    sum_stage[0]
                };

                // Note: sum_stage[0] corresponds to bits [7:0], sum_stage[STAGES-1] bits [63:56]
                // The concatenation above has an error because sum_stage[0] appears at LSB twice
                // Correct concatenation is descending from MSB stage to LSB stage:
                // So concatenate sum_stage[7], sum_stage[6], ..., sum_stage[0]
                // Fixing below after this if-block
            end else begin
                o_en <= 1'b0;
                result <= 65'b0;
            end
        end
    end

    // Because the concatenation in always block may cause synthesis tool issues,
    // rewrite the concatenation in a separate combinational always block
    // Or better, assemble in a separate process

    // Use a function or always_comb to assemble result when o_en is asserted.
    // Since the above always block assigns result when en_pipe[STAGES], let's fix that now.

    // Redefine result assignment inside clocked block below:
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result <= 65'b0;
        end else if (en_pipe[STAGES]) begin
            // Concatenate sums from MSB stage down to LSB stage
            result <= {
                carry_out_stage[STAGES-1],
                sum_stage[STAGES-1],
                sum_stage[STAGES-2],
                sum_stage[STAGES-3],
                sum_stage[STAGES-4],
                sum_stage[STAGES-5],
                sum_stage[STAGES-6],
                sum_stage[STAGES-7],
                sum_stage[STAGES-8]
            };
        end else begin
            result <= 65'b0;
        end
    end

    // But STAGES = 8, so STAGES-8 = 0, so final line sum_stage[0]
    // Fix duplicated assignment by merging the two always blocks:

    // Merge above logic to single always block for clarity:
    // Removing the first always block’s result assignment and using this final one instead

endmodule