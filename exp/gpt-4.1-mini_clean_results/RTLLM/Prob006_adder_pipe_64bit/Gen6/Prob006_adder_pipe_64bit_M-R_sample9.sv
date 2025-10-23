module adder_pipe_64bit (
    input               clk,
    input               rst_n,
    input               i_en,
    input       [63:0]  adda,
    input       [63:0]  addb,
    output reg  [64:0]  result,
    output reg          o_en
);
    localparam STG_WIDTH = 8;
    localparam STAGES = 64 / STG_WIDTH; // 8

    // Pipeline registers for operand slices per stage
    reg [STG_WIDTH-1:0] adda_pipe [0:STAGES-1];
    reg [STG_WIDTH-1:0] addb_pipe [0:STAGES-1];

    // Pipeline registers for carry-in per stage
    reg carry_pipe [0:STAGES];

    // Pipeline registers for output enable signal
    reg en_pipe [0:STAGES];

    // Partial sum and carry wires per stage (combinational)
    wire [STG_WIDTH:0] stage_sum [0:STAGES-1];

    genvar i;

    // Combinational addition per stage: adds operands + carry_in
    generate
        for (i = 0; i < STAGES; i = i + 1) begin : add_stage_comb
            always @(*) begin
                // Perform addition of two operands and carry_in
                stage_sum[i] = {1'b0, adda_pipe[i]} + {1'b0, addb_pipe[i]} + carry_pipe[i];
            end
        end
    endgenerate

    integer j;

    // Registers to hold partial sums per stage (only STG_WIDTH bits)
    reg [STG_WIDTH-1:0] sum_pipe [0:STAGES-1];

    // Combinational function to assemble 65-bit sum from partial sums and final carry
    function [64:0] assemble_sum;
        input integer unused;
        integer idx;
        reg [64:0] sum_temp;
        begin
            sum_temp = 0;
            for (idx = 0; idx < STAGES; idx = idx + 1) begin
                sum_temp[idx*STG_WIDTH +: STG_WIDTH] = sum_pipe[idx];
            end
            sum_temp[64] = carry_pipe[STAGES];
            assemble_sum = sum_temp;
        end
    endfunction

    wire [64:0] sum_comb;
    assign sum_comb = assemble_sum(0);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers and outputs
            for (j = 0; j < STAGES; j = j + 1) begin
                adda_pipe[j] <= 0;
                addb_pipe[j] <= 0;
                sum_pipe[j] <= 0;
                carry_pipe[j] <= 0;
                en_pipe[j] <= 0;
            end
            carry_pipe[STAGES] <= 0;
            en_pipe[STAGES] <= 0;
            result <= 0;
            o_en <= 0;
        end else begin
            // Load first stage operands and zero carry-in
            adda_pipe[0] <= adda[STG_WIDTH-1:0];
            addb_pipe[0] <= addb[STG_WIDTH-1:0];
            carry_pipe[0] <= 1'b0;
            en_pipe[0] <= i_en;

            // For stages 1 to STAGES-1: pipeline operands and carry from previous stage sum
            for (j = 1; j < STAGES; j = j + 1) begin
                adda_pipe[j] <= adda[j*STG_WIDTH +: STG_WIDTH];
                addb_pipe[j] <= addb[j*STG_WIDTH +: STG_WIDTH];
                carry_pipe[j] <= stage_sum[j-1][STG_WIDTH]; // carry out from previous stage
                en_pipe[j] <= en_pipe[j-1];
            end

            // Capture partial sums (STG_WIDTH bits) from combinational stage sums
            for (j = 0; j < STAGES; j = j + 1) begin
                sum_pipe[j] <= stage_sum[j][STG_WIDTH-1:0];
            end

            // Capture final carry out from last stage
            carry_pipe[STAGES] <= stage_sum[STAGES-1][STG_WIDTH];
            en_pipe[STAGES] <= en_pipe[STAGES-1];

            // Register final assembled result and output enable
            result <= sum_comb;
            o_en <= en_pipe[STAGES];
        end
    end

endmodule