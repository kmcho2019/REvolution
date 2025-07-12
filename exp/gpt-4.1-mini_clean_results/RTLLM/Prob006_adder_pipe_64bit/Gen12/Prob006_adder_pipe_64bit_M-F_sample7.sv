module adder_pipe_64bit #(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH  = 16
)(
    input                    clk,
    input                    rst_n,
    input                    i_en,
    input       [DATA_WIDTH-1:0] adda,
    input       [DATA_WIDTH-1:0] addb,
    output reg  [DATA_WIDTH:0]   result,
    output reg               o_en
);

    // Calculate number of pipeline stages from parameters
    localparam NUM_STAGES = DATA_WIDTH / STG_WIDTH;

    // Pipeline registers for operands, sums, and carries
    reg [STG_WIDTH-1:0] a_reg [0:NUM_STAGES-1];
    reg [STG_WIDTH-1:0] b_reg [0:NUM_STAGES-1];
    reg                carry_in_reg [0:NUM_STAGES-1];
    reg [STG_WIDTH-1:0] sum_reg [0:NUM_STAGES-1];
    reg                carry_out_reg [0:NUM_STAGES-1];

    // Pipeline register for enable signal, one stage per pipeline plus output
    reg [NUM_STAGES:0] en_pipeline;

    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers
            for (i = 0; i < NUM_STAGES; i = i + 1) begin
                a_reg[i]        <= {STG_WIDTH{1'b0}};
                b_reg[i]        <= {STG_WIDTH{1'b0}};
                carry_in_reg[i] <= 1'b0;
                sum_reg[i]      <= {STG_WIDTH{1'b0}};
                carry_out_reg[i]<= 1'b0;
            end
            en_pipeline <= {NUM_STAGES+1{1'b0}};
            result      <= {(DATA_WIDTH+1){1'b0}};
            o_en        <= 1'b0;
        end else begin
            // Shift enable pipeline and insert current input enable
            en_pipeline <= {en_pipeline[NUM_STAGES-1:0], i_en};

            // Stage 0 input registers and carry_in = 0
            if (i_en) begin
                a_reg[0]        <= adda[STG_WIDTH-1:0];
                b_reg[0]        <= addb[STG_WIDTH-1:0];
                carry_in_reg[0] <= 1'b0;
            end

            // Compute sum and carry for stage 0
            {carry_out_reg[0], sum_reg[0]} <= a_reg[0] + b_reg[0] + carry_in_reg[0];

            // Subsequent stages
            for (i = 1; i < NUM_STAGES; i = i + 1) begin
                // On en_pipeline stage i input enable, register operands and carry_in
                if (en_pipeline[i]) begin
                    a_reg[i]        <= adda[STG_WIDTH*i +: STG_WIDTH];
                    b_reg[i]        <= addb[STG_WIDTH*i +: STG_WIDTH];
                    carry_in_reg[i] <= carry_out_reg[i-1];
                end
                // Compute sum and carry
                {carry_out_reg[i], sum_reg[i]} <= a_reg[i] + b_reg[i] + carry_in_reg[i];
            end

            // Assemble result when output enable stage is high
            if (en_pipeline[NUM_STAGES]) begin
                // Concatenate sums and final carry_out
                result <= {
                    carry_out_reg[NUM_STAGES-1], // MSB carry out
                    sum_reg[NUM_STAGES-1],
                    // Middle sums
                    (NUM_STAGES > 2 ? 
                        // Generate middle sums in descending order
                        {sum_reg[NUM_STAGES-2:1]} : 
                        // If only 2 stages, just sum_reg[1]
                        (NUM_STAGES == 2 ? sum_reg[1] : )
                    ),
                    sum_reg[0]
                };
                // Above needs modification because concatenation expects fixed bits:
                // We will generate the concatenation in a loop or manually.
                // Since Verilog does not allow concatenation of array slices easily,
                // manually concatenate sums in order from highest stage to lowest:
                // So build a temporary vector for middle sums:

                // We'll implement the concatenation explicitly below.
            end

            o_en <= en_pipeline[NUM_STAGES];
        end
    end

    // Because Verilog does not allow slicing packed arrays easily for concatenation,
    // create a function to assemble the sum bits concatenated in pipeline order.
    // Alternatively, use a combinational block to assign partial sums to a temporary reg.

    // Create a combinational concatenation of sum_reg from MSB stage down to stage 0
    // This is outside always block, use a function or a generate loop.

    // We'll use a function returning [DATA_WIDTH-1:0] vector.

    function [DATA_WIDTH-1:0] concat_sums;
        integer idx;
        begin
            concat_sums = {DATA_WIDTH{1'b0}};
            for (idx = 0; idx < NUM_STAGES; idx = idx +1) begin
                concat_sums[STG_WIDTH*idx +: STG_WIDTH] = sum_reg[idx];
            end
        end
    endfunction

    // Use a small always_comb block to update result for better clarity:
    always @* begin
        // Default keep current result
        // But since result is registered, only update when o_en is high
        // So assign partial sums for output
    end

    // To update result correctly at clock edge, rewrite result assignment
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result <= {(DATA_WIDTH+1){1'b0}};
        end else begin
            if (en_pipeline[NUM_STAGES]) begin
                // Build final result: concatenation of sums + final carry_out
                result <= {carry_out_reg[NUM_STAGES-1], concat_sums()};
            end
        end
    end

endmodule