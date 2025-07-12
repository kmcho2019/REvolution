module adder_pipe_64bit (
    input               clk,
    input               rst_n,
    input               i_en,
    input       [63:0]  adda,
    input       [63:0]  addb,
    output reg  [64:0]  result,
    output reg          o_en
);

    // Pipeline registers for each bit stage
    // Holds bit slices of adda, addb, sum bits, carry, and enable
    reg adda_bit [0:63];
    reg addb_bit [0:63];
    reg sum_bit  [0:63];
    reg carry    [0:64]; // carry in to bit 0 is carry[0], final carry out is carry[64]
    reg en_pipe  [0:64];

    integer i;

    // Sequential logic: On reset clear all registers, else shift bits and compute sum and carry at each stage
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Clear all pipeline registers and outputs
            for (i = 0; i < 64; i = i + 1) begin
                adda_bit[i] <= 1'b0;
                addb_bit[i] <= 1'b0;
                sum_bit[i] <= 1'b0;
            end
            for (i = 0; i <= 64; i = i + 1) begin
                carry[i] <= 1'b0;
                en_pipe[i] <= 1'b0;
            end
            result <= 65'b0;
            o_en <= 1'b0;
        end else begin
            // Stage 0: load input operands bits and carry in 0
            adda_bit[0] <= adda[0];
            addb_bit[0] <= addb[0];
            carry[0] <= 1'b0;   // carry in for LSB is zero
            en_pipe[0] <= i_en;

            // Compute sum and carry bit 0
            sum_bit[0] <= adda_bit[0] ^ addb_bit[0] ^ carry[0];
            carry[1]  <= (adda_bit[0] & addb_bit[0]) | (adda_bit[0] & carry[0]) | (addb_bit[0] & carry[0]);

            // Propagate for bits 1 to 63
            for (i = 1; i < 64; i = i + 1) begin
                // Shift input operand bits from inputs (to pipeline registers)
                adda_bit[i] <= adda[i];
                addb_bit[i] <= addb[i];

                // sum bit computed from previous stage inputs and carry
                sum_bit[i] <= adda_bit[i] ^ addb_bit[i] ^ carry[i];

                // carry out for next bit
                carry[i+1] <= (adda_bit[i] & addb_bit[i]) | (adda_bit[i] & carry[i]) | (addb_bit[i] & carry[i]);
            end

            // Pipeline the enable signals to track valid data through stages
            for (i = 1; i <= 64; i = i + 1) begin
                en_pipe[i] <= en_pipe[i-1];
            end

            // When enable of last stage is high, output is valid
            if (en_pipe[64]) begin
                // Assemble result from sum bits and carry out
                // sum bits are registered individually, so gather them
                for (i = 0; i < 64; i = i + 1) begin
                    result[i] <= sum_bit[i];
                end
                result[64] <= carry[64];
                o_en <= 1'b1;
            end else begin
                // No valid output yet
                result <= result; // hold previous value
                o_en <= 1'b0;
            end
        end
    end

endmodule