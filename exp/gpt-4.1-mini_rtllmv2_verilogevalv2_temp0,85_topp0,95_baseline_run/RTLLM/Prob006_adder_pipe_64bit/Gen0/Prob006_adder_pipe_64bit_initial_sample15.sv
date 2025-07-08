module adder_pipe_64bit (
    input             clk,
    input             rst_n,
    input             i_en,
    input      [63:0] adda,
    input      [63:0] addb,
    output reg [64:0] result,
    output reg        o_en
);

// Pipeline configuration:
// Let's use 8 pipeline stages, each handling 8 bits addition with ripple carry.
// We keep registers for operands, carries, sums, and enable signals across stages.

// Parameters
localparam STAGES = 8;
localparam WIDTH_PER_STAGE = 8;

// Pipeline registers for operands and carry-in signals
reg [63:0] adda_pipe [0:STAGES];
reg [63:0] addb_pipe [0:STAGES];
reg        en_pipe   [0:STAGES];
reg [STAGES:0] carry_pipe; // carry_pipe[i] is carry in for stage i

// Partial sums per stage stored in registers
reg [7:0] sum_pipe [0:STAGES-1];

// Wires for current stage addition
wire [8:0] add_stage [0:STAGES-1]; // 8 bits + carry

integer i;

// Combinational addition for each stage
// Since we use registers for pipeline stages, the addition is combinational based on pipeline registers
generate
    genvar stage;
    for(stage = 0; stage < STAGES; stage = stage + 1) begin : STAGE_ADDER
        wire [7:0] a_part = adda_pipe[stage][(stage+1)*WIDTH_PER_STAGE-1 -: WIDTH_PER_STAGE];
        wire [7:0] b_part = addb_pipe[stage][(stage+1)*WIDTH_PER_STAGE-1 -: WIDTH_PER_STAGE];
        wire c_in = carry_pipe[stage];
        assign add_stage[stage] = a_part + b_part + c_in;
    end
endgenerate

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // reset all pipeline registers and outputs
        for (i = 0; i <= STAGES; i = i + 1) begin
            adda_pipe[i] <= 64'b0;
            addb_pipe[i] <= 64'b0;
            en_pipe[i]   <= 1'b0;
        end
        carry_pipe <= 0;
        for (i = 0; i < STAGES; i = i + 1) begin
            sum_pipe[i] <= 8'b0;
        end
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Shift input operands and enable into pipeline registers
        adda_pipe[0] <= adda;
        addb_pipe[0] <= addb;
        en_pipe[0]   <= i_en;

        // Propagate pipeline registers for operands and enable signals
        for (i = 1; i <= STAGES; i = i + 1) begin
            adda_pipe[i] <= adda_pipe[i-1];
            addb_pipe[i] <= addb_pipe[i-1];
            en_pipe[i]   <= en_pipe[i-1];
        end

        // Set carry_in for stage 0 to 0 when input enabled, else 0
        carry_pipe[0] <= 1'b0;

        // For each stage, latch sum and propagate carry to next stage
        for (i = 0; i < STAGES; i = i + 1) begin
            // Register the sum of current stage
            sum_pipe[i] <= add_stage[i][7:0];
            // Propagate carry-out to next stage carry_in if enable is high, else keep 0
            carry_pipe[i+1] <= en_pipe[i] ? add_stage[i][8] : 1'b0;
        end

        // After last stage, assemble final result and output enable
        // result = concatenation of all stage sums + last carry
        // Build the result by concatenating sum_pipe[7] ... sum_pipe[0] plus carry_pipe[STAGES]
        // Because pipeline registers delay sum_pipe and carry_pipe by one clock cycle,
        // we assign result from the previous cycle's sums and carry_pipe.

        // Use a temporary variable to form result
        reg [64:0] temp_result;
        temp_result = {carry_pipe[STAGES],
                       sum_pipe[7], sum_pipe[6], sum_pipe[5], sum_pipe[4],
                       sum_pipe[3], sum_pipe[2], sum_pipe[1], sum_pipe[0]};
        result <= temp_result;

        // Output enable is the enable signal delayed STAGES+1 cycles
        // This corresponds to en_pipe[STAGES]
        o_en <= en_pipe[STAGES];
    end
end

endmodule