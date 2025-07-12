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
    localparam STAGES = 64 / STG_WIDTH; // 8 stages

    // Pipeline registers for operands slices per stage
    reg [STG_WIDTH-1:0] adda_pipe    [0:STAGES-1];
    reg [STG_WIDTH-1:0] addb_pipe    [0:STAGES-1];
    // Carry-in pipeline: carry into each stage
    reg carry_pipe [0:STAGES];
    // Enable pipeline
    reg en_pipe [0:STAGES];

    // Partial sum wires for each stage (combinational result)
    wire [STG_WIDTH:0] add_res [0:STAGES-1];

    genvar i;

    // Assign combinational adders for each stage
    generate
        for (i = 0; i < STAGES; i = i + 1) begin : ADD_STAGE
            assign add_res[i] = {1'b0, adda_pipe[i]} + {1'b0, addb_pipe[i]} + carry_pipe[i];
        end
    endgenerate

    integer j;

    // Partial sums pipeline registers, each stage stores STG_WIDTH bits of sum
    reg [STG_WIDTH-1:0] sum_pipe [0:STAGES-1];

    // For assembling final result bits from sum_pipe registers
    wire [64:0] sum_concat;

    // Concatenate partial sums in order: least significant sum_pipe[0] at lowest bits, sum_pipe[7] at highest bits
    generate
        wire [64:0] temp_concat;
        // Concatenate sum_pipe from MSB stage down to LSB stage into one wire
        // 8 stages * 8 bits = 64 bits; plus 1 bit for carry out
        assign temp_concat = {
            sum_pipe[STAGES-1],
            sum_pipe[STAGES-2],
            sum_pipe[STAGES-3],
            sum_pipe[STAGES-4],
            sum_pipe[STAGES-5],
            sum_pipe[STAGES-6],
            sum_pipe[STAGES-7],
            sum_pipe[0]
        };
        // But the above is hardcoded and misses sum_pipe[1], sum_pipe[2], sum_pipe[3], sum_pipe[4], sum_pipe[5]
        // Let's fix with a loop in a function

        function [64:0] concat_sum_pipe;
            input integer unused;
            integer idx;
            begin
                concat_sum_pipe = 0;
                for (idx=0; idx<STAGES; idx=idx+1) begin
                    concat_sum_pipe = concat_sum_pipe | (sum_pipe[idx] << (idx*STG_WIDTH));
                end
            end
        endfunction
    endgenerate

    // We'll assign sum_concat in a procedural block because sum_pipe is registers

    always @* begin
        sum_concat = {65{1'b0}};
        for (j = 0; j < STAGES; j = j + 1) begin
            sum_concat[j*STG_WIDTH +: STG_WIDTH] = sum_pipe[j];
        end
        sum_concat[64] = carry_pipe[STAGES];
    end

    // Pipeline registers update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (j = 0; j < STAGES; j = j + 1) begin
                adda_pipe[j] <= 0;
                addb_pipe[j] <= 0;
                sum_pipe[j]  <= 0;
                carry_pipe[j] <= 0;
                en_pipe[j] <= 0;
            end
            carry_pipe[STAGES] <= 0;
            en_pipe[STAGES] <= 0;
            result <= 0;
            o_en <= 0;
        end else begin
            // Stage 0 operand slices and initial carry
            adda_pipe[0] <= adda[STG_WIDTH-1:0];
            addb_pipe[0] <= addb[STG_WIDTH-1:0];
            carry_pipe[0] <= 1'b0; // initial carry in is zero
            en_pipe[0] <= i_en;

            // Stages 1 to STAGES-1 pipeline operands and carry from previous stage
            for (j = 1; j < STAGES; j = j + 1) begin
                adda_pipe[j] <= adda[j*STG_WIDTH +: STG_WIDTH];
                addb_pipe[j] <= addb[j*STG_WIDTH +: STG_WIDTH];
                carry_pipe[j] <= add_res[j-1][STG_WIDTH]; // carry out from previous stage
                en_pipe[j] <= en_pipe[j-1];
            end

            // Partial sums registers: capture lower bits of combinational adders
            for (j = 0; j < STAGES; j = j + 1) begin
                sum_pipe[j] <= add_res[j][STG_WIDTH-1:0];
            end

            // Final carry out after last stage
            carry_pipe[STAGES] <= add_res[STAGES-1][STG_WIDTH];
            en_pipe[STAGES] <= en_pipe[STAGES-1];

            // Register the assembled result
            result <= sum_concat;

            // Output enable is the enable delayed through pipeline stages
            o_en <= en_pipe[STAGES];
        end
    end
endmodule