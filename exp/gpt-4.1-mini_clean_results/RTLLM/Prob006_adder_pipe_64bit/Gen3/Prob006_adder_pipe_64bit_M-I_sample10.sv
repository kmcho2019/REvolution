module adder_pipe_64bit (
    input             clk,
    input             rst_n,
    input             i_en,
    input      [63:0] adda,
    input      [63:0] addb,
    output reg [64:0] result,
    output reg        o_en
);

    // Pipeline registers per bit stage (64 stages)
    reg [63:0] adda_pipe;     // operand A bits, shifted right each cycle
    reg [63:0] addb_pipe;     // operand B bits, shifted right each cycle
    reg [63:0] sum_pipe;      // accumulated sum bits, shifted left each cycle
    reg        carry_pipe;    // carry in to the current bit addition

    // Shift registers to delay carry out and enable signals through pipeline
    reg [64:0] carry_shift;  // shifts carry out bits for final carry bit after 64 cycles
    reg [64:0] en_shift;     // delays input enable signal through pipeline stages

    integer i;

    // For holding reversed sum bits (MSB to LSB) after pipeline completion
    reg [63:0] sum_rev;

    // Bit reversal combinational logic (reverse bits of sum_pipe)
    always @* begin
        for (i = 0; i < 64; i = i + 1) begin
            sum_rev[i] = sum_pipe[63 - i];
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            adda_pipe   <= 64'd0;
            addb_pipe   <= 64'd0;
            sum_pipe    <= 64'd0;
            carry_pipe  <= 1'b0;
            carry_shift <= 65'd0;
            en_shift    <= 65'd0;
            result      <= 65'd0;
            o_en        <= 1'b0;
        end else begin
            // Shift enable pipeline register left by 1 bit, insert current i_en at LSB
            en_shift <= {en_shift[63:0], i_en};

            if (i_en) begin
                // Load operands and reset carry and sum at start of new addition
                adda_pipe  <= adda;
                addb_pipe  <= addb;
                carry_pipe <= 1'b0;  // initial carry-in zero
                sum_pipe   <= 64'd0;
                carry_shift <= 65'd0;
            end else begin
                // Keep pipeline registers if no new input (carry over previous state)
                adda_pipe   <= adda_pipe;
                addb_pipe   <= addb_pipe;
                carry_pipe  <= carry_pipe;
                sum_pipe    <= sum_pipe;
                carry_shift <= carry_shift;
            end

            // Extract current bit inputs and carry in for this pipeline stage
            // Using temporary regs assigned here (procedural)
            // Sum bit and carry out computations
            // Note: these must be assigned to regs here, not wires declared inside always
            reg bit_a, bit_b, cin;
            reg sum_bit, cout;

            bit_a = adda_pipe[0];
            bit_b = addb_pipe[0];
            cin   = carry_pipe;

            sum_bit = bit_a ^ bit_b ^ cin;
            cout   = (bit_a & bit_b) | (bit_a & cin) | (bit_b & cin);

            // Shift operands right by one bit (towards MSB)
            adda_pipe <= {1'b0, adda_pipe[63:1]};
            addb_pipe <= {1'b0, addb_pipe[63:1]};

            // Shift sum_pipe left by one bit and insert new sum bit at LSB
            sum_pipe <= {sum_pipe[62:0], sum_bit};

            // Update carry_pipe with the carry-out from this bit addition
            carry_pipe <= cout;

            // Shift carry_shift left by one bit and insert current carry out at LSB
            carry_shift <= {carry_shift[63:0], cout};

            // Output enable is delayed input enable signal after 64 cycles (when result is ready)
            o_en <= en_shift[64];

            // Output the result only when pipeline output is valid (after 64 cycles)
            if (en_shift[64]) begin
                // Final result: concatenation of last carry out and reversed sum bits
                result <= {carry_shift[64], sum_rev};
            end else begin
                result <= 65'd0;
            end
        end
    end

endmodule