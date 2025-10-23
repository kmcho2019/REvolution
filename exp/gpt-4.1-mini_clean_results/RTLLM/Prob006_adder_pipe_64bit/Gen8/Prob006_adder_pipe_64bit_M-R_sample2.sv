module adder_pipe_64bit(
    input  wire         clk,
    input  wire         rst_n,
    input  wire         i_en,
    input  wire [63:0]  adda,
    input  wire [63:0]  addb,
    output reg  [64:0]  result,
    output reg          o_en
);

    // Pipeline registers for operands, carry-in, sum bits
    reg [63:0]  adda_pipe   [0:64]; // operand A pipeline stages (stages 0 to 64)
    reg [63:0]  addb_pipe   [0:64]; // operand B pipeline stages
    reg [64:0]  carry_pipe;          // carry pipeline (bit per stage)
    reg [63:0]  sum_pipe    [0:64]; // sum bits pipeline stages

    // Enable pipeline: delay i_en 65 cycles to sync output validity
    reg [64:0]  en_pipe;

    integer i;

    // Initialize pipeline stage 0 with input on i_en
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers
            for (i = 0; i <= 64; i = i + 1) begin
                adda_pipe[i] <= 64'b0;
                addb_pipe[i] <= 64'b0;
                sum_pipe[i]  <= 64'b0;
            end
            carry_pipe <= 65'b0;
            en_pipe <= 65'b0;
            result <= 65'b0;
            o_en <= 1'b0;
        end else begin
            // Shift input operands through pipeline stages
            adda_pipe[0] <= i_en ? adda : adda_pipe[0];
            addb_pipe[0] <= i_en ? addb : addb_pipe[0];
            for (i = 1; i <= 64; i = i + 1) begin
                adda_pipe[i] <= adda_pipe[i-1];
                addb_pipe[i] <= addb_pipe[i-1];
                sum_pipe[i]  <= sum_pipe[i-1];
            end

            // Pipeline carry and sum computation for each bit stage
            // Implement ripple carry stages in a generate-like style
            // Carry_in for stage 0 is always zero
            carry_pipe[0] <= 1'b0;

            for (i = 0; i < 64; i = i + 1) begin
                // Extract bit i of operands at stage i
                wire a_bit = adda_pipe[i][i];
                wire b_bit = addb_pipe[i][i];
                wire c_in = carry_pipe[i];

                // Compute sum and carry-out
                wire s_bit = a_bit ^ b_bit ^ c_in;
                wire c_out = (a_bit & b_bit) | (a_bit & c_in) | (b_bit & c_in);

                // Register sum bit in stage i+1's sum_pipe[i]
                sum_pipe[i+1][i] <= s_bit;

                // Propagate unchanged sum bits for other bits in next stage
                // For bits != i, sum bits remain the same as previous stage
                // This is done below after the loop

                // Register carry_out to next stage
                carry_pipe[i+1] <= c_out;
            end

            // For bits other than i, copy sum bits forward unchanged
            // This is done for each bit at each stage (except the newly computed bit)
            // Implemented by copying the previous stage's sum_pipe except at index i updated above
            for (i = 0; i < 64; i = i + 1) begin
                integer b;
                for (b = 0; b < 64; b = b + 1) begin
                    if (b != i) begin
                        sum_pipe[i+1][b] <= sum_pipe[i][b];
                    end
                end
            end

            // Delay i_en signal through pipeline
            en_pipe <= {en_pipe[63:0], i_en};

            // Output assignment when last pipeline stage valid
            if (en_pipe[64]) begin
                // result = carry out + all sum bits from last stage
                result <= {carry_pipe[64], sum_pipe[64]};
            end else begin
                result <= result;
            end

            o_en <= en_pipe[64];
        end
    end

endmodule