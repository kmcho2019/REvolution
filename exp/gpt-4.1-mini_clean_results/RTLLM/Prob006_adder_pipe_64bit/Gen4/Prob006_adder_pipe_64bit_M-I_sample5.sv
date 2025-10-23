module adder_pipe_64bit (
    input               clk,
    input               rst_n,
    input               i_en,
    input      [63:0]   adda,
    input      [63:0]   addb,
    output reg [64:0]   result,
    output reg          o_en
);

    // Parameters
    localparam STAGES = 8;          // Number of pipeline stages
    localparam WIDTH  = 8;          // Width per stage

    // Pipeline registers: shift registers for operands, sum, carry, enable
    reg [WIDTH-1:0] adda_pipe   [0:STAGES-1];
    reg [WIDTH-1:0] addb_pipe   [0:STAGES-1];
    reg             carry_pipe  [0:STAGES];     // carry_pipe[0] is carry-in to stage 0
    reg [WIDTH-1:0] sum_pipe    [0:STAGES-1];
    reg             en_pipe     [0:STAGES];

    integer i;

    // Wires for combinational sum and carry-out per stage
    wire [WIDTH-1:0] sum_comb  [0:STAGES-1];
    wire             carry_out_comb [0:STAGES-1];

    // Combinational addition for each stage
    genvar stage;
    generate
        for (stage = 0; stage < STAGES; stage = stage + 1) begin : gen_add_stage
            assign {carry_out_comb[stage], sum_comb[stage]} = adda_pipe[stage] + addb_pipe[stage] + carry_pipe[stage];
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers and outputs
            for (i = 0; i < STAGES; i = i + 1) begin
                adda_pipe[i] <= 0;
                addb_pipe[i] <= 0;
                sum_pipe[i]  <= 0;
                en_pipe[i]   <= 0;
            end
            for (i = 0; i <= STAGES; i = i + 1)
                carry_pipe[i] <= 0;
            result <= 0;
            o_en <= 0;
        end else begin
            // Pipeline stage 0 input loading when i_en asserted
            if (i_en) begin
                // Load stage 0 operands from input buses
                adda_pipe[0] <= adda[  7:0];
                addb_pipe[0] <= addb[  7:0];
                en_pipe[0]   <= 1'b1;    // Enable for stage 0
                carry_pipe[0] <= 1'b0;   // Initial carry-in zero for stage 0
            end else begin
                // If no valid input, disable stage 0 enable and hold carry_in zero
                en_pipe[0] <= 1'b0;
                carry_pipe[0] <= 1'b0;
                // We can hold operands or clear them; clearing reduces unnecessary switching
                adda_pipe[0] <= 0;
                addb_pipe[0] <= 0;
            end

            // For stages 1 to STAGES-1:
            // Shift pipeline registers forward
            for (i = 1; i < STAGES; i = i + 1) begin
                adda_pipe[i] <= adda_pipe[i-1];
                addb_pipe[i] <= addb_pipe[i-1];
                en_pipe[i]   <= en_pipe[i-1];
                carry_pipe[i] <= carry_out_comb[i-1];  // carry_out of previous stage becomes carry_in of current stage
            end

            // Register sum outputs for each stage when stage is enabled
            for (i = 0; i < STAGES; i = i + 1) begin
                if (en_pipe[i]) begin
                    sum_pipe[i] <= sum_comb[i];
                end else begin
                    sum_pipe[i] <= sum_pipe[i]; // Hold previous sum
                end
            end

            // carry_pipe[STAGES] holds carry-out of last stage
            carry_pipe[STAGES] <= en_pipe[STAGES-1] ? carry_out_comb[STAGES-1] : carry_pipe[STAGES];

            // Shift enable for output stage (STAGES)
            en_pipe[STAGES] <= en_pipe[STAGES-1];

            // Output assignment
            o_en <= en_pipe[STAGES];
            if (en_pipe[STAGES]) begin
                // Concatenate sums in correct order: sum_pipe[STAGES-1] is bits [63:56], sum_pipe[0] is bits [7:0]
                result <= { carry_pipe[STAGES],
                            sum_pipe[STAGES-1],
                            sum_pipe[STAGES-2],
                            sum_pipe[STAGES-3],
                            sum_pipe[STAGES-4],
                            sum_pipe[STAGES-5],
                            sum_pipe[STAGES-6],
                            sum_pipe[STAGES-7],
                            sum_pipe[STAGES-8]
                          };
                // sum_pipe[STAGES-8] is sum_pipe[0]
            end else begin
                result <= 0;
            end
        end
    end

endmodule