module adder_pipe_64bit(
    input  wire        clk,
    input  wire        rst_n,
    input  wire        i_en,
    input  wire [63:0] adda,
    input  wire [63:0] addb,
    output reg  [64:0] result,
    output reg         o_en
);

    // Pipeline registers per stage for carry and sum bits
    reg carry_pipe   [0:64];      // carry_pipe[0] is initial carry_in = 0
    reg sum_pipe     [0:63];      // sum bits per stage

    // Pipeline registers for operand bits
    reg adda_bit_pipe[0:63];
    reg addb_bit_pipe[0:63];

    // Pipeline register for input enable signal delayed through pipeline
    reg [64:0] en_pipe;

    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers
            carry_pipe[0] <= 1'b0;
            for (i = 0; i < 64; i = i + 1) begin
                adda_bit_pipe[i] <= 1'b0;
                addb_bit_pipe[i] <= 1'b0;
                sum_pipe[i]      <= 1'b0;
                carry_pipe[i+1]  <= 1'b0;
            end
            en_pipe <= 65'b0;
            result <= 65'b0;
            o_en <= 1'b0;
        end else begin
            // Shift enable pipeline
            en_pipe <= {en_pipe[63:0], i_en};

            // At stage 0, latch the input operand bits if i_en asserted
            if (i_en) begin
                for (i = 0; i < 64; i = i + 1) begin
                    adda_bit_pipe[i] <= adda[i];
                    addb_bit_pipe[i] <= addb[i];
                end
                carry_pipe[0] <= 1'b0; // initial carry-in zero
            end else begin
                // Hold operand bits stable otherwise
                for (i = 0; i < 64; i = i + 1) begin
                    adda_bit_pipe[i] <= adda_bit_pipe[i];
                    addb_bit_pipe[i] <= addb_bit_pipe[i];
                end
                carry_pipe[0] <= carry_pipe[0];
            end

            // Ripple carry pipeline: from bit 0 to bit 63
            for (i = 0; i < 64; i = i + 1) begin
                // Compute sum and carry-out
                // sum = a ^ b ^ carry_in
                // carry_out = majority of (a, b, carry_in)
                sum_pipe[i] <= adda_bit_pipe[i] ^ addb_bit_pipe[i] ^ carry_pipe[i];
                carry_pipe[i+1] <= (adda_bit_pipe[i] & addb_bit_pipe[i]) |
                                   (adda_bit_pipe[i] & carry_pipe[i]) |
                                   (addb_bit_pipe[i] & carry_pipe[i]);
            end

            // When final stage completed (after 64 cycles delay), assemble result
            if (en_pipe[64]) begin
                // Concatenate sum bits and final carry out
                // sum_pipe holds sum bits for each stage (bit 0 LSB ... bit 63 MSB)
                // Create a temporary variable to build the result
                reg [63:0] sum_vector;
                for (i = 0; i < 64; i = i + 1) begin
                    sum_vector[i] = sum_pipe[i];
                end
                result <= {carry_pipe[64], sum_vector};
            end else begin
                result <= result; // Hold previous
            end

            // Output enable follows enable pipeline delay
            o_en <= en_pipe[64];
        end
    end

endmodule