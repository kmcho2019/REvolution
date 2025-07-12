module adder_pipe_64bit (
    input  wire         clk,
    input  wire         rst_n,
    input  wire         i_en,
    input  wire [63:0]  adda,
    input  wire [63:0]  addb,
    output reg  [64:0]  result,
    output reg          o_en
);

    reg [63:0] adda_reg, addb_reg;        // Registered inputs at start of pipeline
    reg [63:0] sum_pipe;                   // Sum bits pipeline register
    reg [64:0] carry_pipe;                 // Carry bits pipeline register (carry_pipe[0] is carry-in)
    reg [64:0] en_pipe;                    // Enable pipeline, 65 cycles delay

    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            adda_reg   <= 64'b0;
            addb_reg   <= 64'b0;
            sum_pipe   <= 64'b0;
            carry_pipe <= 65'b0;
            en_pipe    <= 65'b0;
            result     <= 65'b0;
            o_en       <= 1'b0;
        end else begin
            // Shift enable pipeline and insert i_en at LSB
            en_pipe <= {en_pipe[63:0], i_en};

            // Register inputs when i_en asserted
            if (i_en) begin
                adda_reg <= adda;
                addb_reg <= addb;
                carry_pipe <= 65'b0; // carry_in = 0
                sum_pipe <= 64'b0;
            end else begin
                // Advance carry and sum pipeline by one bit stage
                // Compute sum bit and next carry bit for current stage (LSB of adda_reg and addb_reg shifted accordingly)

                // For stage n, sum = adda_bit ^ addb_bit ^ carry_in
                // carry_out = majority(adda_bit, addb_bit, carry_in)

                // We implement ripple carry by shifting through bits per clock cycle
                // Take bit 0 of adda_reg and addb_reg with carry_pipe[0]

                // sum_pipe[0] = bit0 sum, sum_pipe[63:1] shifts down, sum_pipe bit[0] replaced each cycle
                // carry_pipe shifts similarly with carry out inserted at MSB

                // Compute current stage sum and carry out for bit 0
                wire bit0_a = adda_reg[0];
                wire bit0_b = addb_reg[0];
                wire carry_in = carry_pipe[0];
                wire sum0 = bit0_a ^ bit0_b ^ carry_in;
                wire carry_out = (bit0_a & bit0_b) | (bit0_a & carry_in) | (bit0_b & carry_in);

                // Shift inputs right by 1 for next cycle
                adda_reg <= {1'b0, adda_reg[63:1]};
                addb_reg <= {1'b0, addb_reg[63:1]};

                // Shift sum_pipe right by 1 and insert sum0 at MSB
                sum_pipe <= {sum0, sum_pipe[63:1]};

                // Shift carry_pipe right by 1 and insert carry_out at MSB
                carry_pipe <= {carry_out, carry_pipe[64:1]};
            end

            // When output enable is asserted (after 64 cycles), output result
            if (en_pipe[64]) begin
                result <= {carry_pipe[0], sum_pipe}; // carry_pipe[0] is final carry out (after shifting)
            end

            o_en <= en_pipe[64];
        end
    end

endmodule