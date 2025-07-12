module adder_pipe_64bit #(
    parameter WIDTH = 64,
    parameter STG_WIDTH = 8,
    parameter STAGES = WIDTH / STG_WIDTH
)(
    input                   clk,
    input                   rst_n,
    input                   i_en,
    input       [WIDTH-1:0] adda,
    input       [WIDTH-1:0] addb,
    output reg  [WIDTH:0]   result,
    output reg              o_en
);

    // Pipeline registers for operand slices
    reg [STG_WIDTH-1:0] adda_pipe [0:STAGES-1];
    reg [STG_WIDTH-1:0] addb_pipe [0:STAGES-1];

    // Pipeline registers for partial sums
    reg [STG_WIDTH-1:0] sum_pipe [0:STAGES-1];

    // Pipeline registers for carry signals
    reg carry_pipe [0:STAGES];

    // Pipeline registers for enable signals
    reg en_pipe [0:STAGES];

    // Combinational wires for addition results (partial sum + carry out)
    wire [STG_WIDTH:0] add_res [0:STAGES-1];

    genvar i;
    generate
        for (i = 0; i < STAGES; i = i + 1) begin : ADD_STAGE_GEN
            assign add_res[i] = {1'b0, adda_pipe[i]} + {1'b0, addb_pipe[i]} + carry_pipe[i];
        end
    endgenerate

    integer j;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers
            for (j = 0; j < STAGES; j = j + 1) begin
                adda_pipe[j] <= {STG_WIDTH{1'b0}};
                addb_pipe[j] <= {STG_WIDTH{1'b0}};
                sum_pipe[j]  <= {STG_WIDTH{1'b0}};
                carry_pipe[j] <= 1'b0;
                en_pipe[j] <= 1'b0;
            end
            carry_pipe[STAGES] <= 1'b0;
            en_pipe[STAGES] <= 1'b0;
            result <= {(WIDTH+1){1'b0}};
            o_en <= 1'b0;
        end else begin
            // Load stage 0 operands and carry-in
            adda_pipe[0] <= adda[STG_WIDTH-1:0];
            addb_pipe[0] <= addb[STG_WIDTH-1:0];
            carry_pipe[0] <= 1'b0;
            en_pipe[0] <= i_en;

            // Load next stages operands, carry and enable
            for (j = 1; j < STAGES; j = j + 1) begin
                adda_pipe[j] <= adda[j*STG_WIDTH +: STG_WIDTH];
                addb_pipe[j] <= addb[j*STG_WIDTH +: STG_WIDTH];
                carry_pipe[j] <= add_res[j-1][STG_WIDTH]; // carry out from previous stage
                en_pipe[j] <= en_pipe[j-1];
            end

            // Store partial sums from current stage results
            for (j = 0; j < STAGES; j = j + 1) begin
                sum_pipe[j] <= add_res[j][STG_WIDTH-1:0];
            end

            // Final carry out and enable
            carry_pipe[STAGES] <= add_res[STAGES-1][STG_WIDTH];
            en_pipe[STAGES] <= en_pipe[STAGES-1];

            // Output registers updated below (result assembled combinationally)
            o_en <= en_pipe[STAGES];
        end
    end

    // Combine partial sums and final carry out into final 65-bit result combinationally
    wire [WIDTH:0] result_comb;
    generate
        // Concatenate partial sums and carry out into result_comb
        // sum_pipe[0] is lowest bits, sum_pipe[STAGES-1] highest
        if (STAGES == 8) begin : CONCAT_8_STAGES
            assign result_comb = {carry_pipe[STAGES],
                                  sum_pipe[7], sum_pipe[6], sum_pipe[5], sum_pipe[4],
                                  sum_pipe[3], sum_pipe[2], sum_pipe[1], sum_pipe[0]};
        end else begin : CONCAT_GENERIC
            // For generic STAGES, use a function to concatenate
            function [WIDTH:0] concat_sums;
                input integer n;
                integer idx;
                begin
                    concat_sums = carry_pipe[n];
                    for (idx = n-1; idx >= 0; idx = idx - 1)
                        concat_sums = (concat_sums << STG_WIDTH) | sum_pipe[idx];
                end
            endfunction
            assign result_comb = concat_sums(STAGES);
        end
    endgenerate

    // Register final result (updated synchronously to ensure timing)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            result <= {(WIDTH+1){1'b0}};
        else
            result <= result_comb;
    end

endmodule