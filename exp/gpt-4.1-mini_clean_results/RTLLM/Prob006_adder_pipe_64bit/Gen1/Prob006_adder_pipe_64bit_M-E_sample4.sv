module adder_pipe_64bit (
    input           clk,
    input           rst_n,
    input           i_en,
    input  [63:0]   adda,
    input  [63:0]   addb,
    output reg [64:0] result,
    output reg      o_en
);

    // Number of stages equals 64 bits of addition
    localparam STAGES = 64;

    // Pipeline registers for carry signals, indexed from 0 to 64
    // carry_pipeline[i] is the carry-in to bit i addition
    reg carry_pipeline [0:STAGES];

    // Pipeline registers for sum bits
    reg sum_pipeline [0:STAGES-1];

    // Shift register for enable signal to track valid data through pipeline
    reg [STAGES-1:0] en_pipeline;

    integer i;

    // Initial carry-in zero at stage 0
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            carry_pipeline[0] <= 1'b0;
            en_pipeline <= {STAGES{1'b0}};
            o_en <= 1'b0;
            result <= 0;
            for (i = 0; i < STAGES; i = i + 1) begin
                sum_pipeline[i] <= 1'b0;
                carry_pipeline[i+1] <= 1'b0;
            end
        end else begin
            // Pipeline the enable signal
            en_pipeline <= {en_pipeline[STAGES-2:0], i_en};

            // First stage carry-in always 0 on valid input
            carry_pipeline[0] <= 1'b0;

            // For each stage, calculate sum bit and carry-out, register both
            for (i = 0; i < STAGES; i = i + 1) begin
                if (i_en || en_pipeline[i]) begin
                    // Compute sum bit: a xor b xor carry-in
                    sum_pipeline[i] <= adda[i] ^ addb[i] ^ carry_pipeline[i];

                    // Compute carry-out: majority function of (a,b,carry-in)
                    carry_pipeline[i+1] <= (adda[i] & addb[i]) |
                                           (adda[i] & carry_pipeline[i]) |
                                           (addb[i] & carry_pipeline[i]);
                end else begin
                    // If no valid data, clear sum and carry-out
                    sum_pipeline[i] <= 1'b0;
                    carry_pipeline[i+1] <= 1'b0;
                end
            end

            // Output enable is the last bit of the enable pipeline
            o_en <= en_pipeline[STAGES-1];

            // When output is enabled, assemble final result from sum_pipeline and last carry out
            if (en_pipeline[STAGES-1]) begin
                // Construct result from pipeline registers
                // sum_pipeline[0] is LSB, sum_pipeline[63] is MSB bit
                result <= {carry_pipeline[STAGES],  // Final carry-out as MSB
                           sum_pipeline[STAGES-1:0]};
            end else begin
                result <= 0;
            end
        end
    end

endmodule