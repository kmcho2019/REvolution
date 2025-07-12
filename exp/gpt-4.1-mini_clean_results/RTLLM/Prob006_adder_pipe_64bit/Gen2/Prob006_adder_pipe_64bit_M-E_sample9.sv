module adder_pipe_64bit (
    input             clk,
    input             rst_n,
    input             i_en,
    input      [63:0] adda,
    input      [63:0] addb,
    output reg [64:0] result,
    output reg        o_en
);

    // Pipeline registers per bit stage
    reg [63:0] adda_pipe;   // operand A bits registered and shifted per cycle
    reg [63:0] addb_pipe;   // operand B bits registered and shifted per cycle
    reg [63:0] sum_pipe;    // accumulated sum bits registered per cycle
    reg        carry_pipe;  // carry bit into current stage
    reg [64:0] carry_shift; // carry bits per pipeline stage (to delay carry propagation)
    reg [64:0] en_shift;    // enable signal shifted through pipeline stages

    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            adda_pipe <= 0;
            addb_pipe <= 0;
            sum_pipe <= 0;
            carry_pipe <= 0;
            carry_shift <= 0;
            en_shift <= 0;
            result <= 0;
            o_en <= 0;
        end else begin
            // Shift enable signal pipeline, left-shift by 1 bit
            en_shift <= {en_shift[63:0], i_en};

            if (i_en) begin
                // Load operands on stage 0
                adda_pipe <= adda;
                addb_pipe <= addb;
                carry_pipe <= 0; // initial carry-in zero
                sum_pipe <= 0;
                carry_shift <= 0;
            end else begin
                // Keep operands and carry_pipe as is if no new valid input (can also keep 0)
                // But better to keep as last registered to avoid glitches
                adda_pipe <= adda_pipe;
                addb_pipe <= addb_pipe;
                carry_pipe <= carry_pipe;
                sum_pipe <= sum_pipe;
                carry_shift <= carry_shift;
            end

            // Process one bit addition per clock cycle, ripple carry step:

            // Compute sum bit = current LSB bits plus carry_pipe
            // bits at LSB of adda_pipe and addb_pipe
            // Result sum bit stored LSB of sum_pipe, shifted in from right each cycle

            // current bits to add
            wire bit_a = adda_pipe[0];
            wire bit_b = addb_pipe[0];
            wire cin   = carry_pipe;

            // sum bit and carry out
            wire sum_bit = bit_a ^ bit_b ^ cin;
            wire cout   = (bit_a & bit_b) | (bit_a & cin) | (bit_b & cin);

            // shift adda_pipe and addb_pipe right by one (towards MSB)
            // shift sum_pipe left by one and input new sum_bit at LSB

            adda_pipe <= {1'b0, adda_pipe[63:1]};
            addb_pipe <= {1'b0, addb_pipe[63:1]};
            sum_pipe  <= {sum_bit, sum_pipe[63:1]};
            carry_pipe <= cout;

            // Shift carry_shift: this register delays all carry bits for output assembly
            // Append current cout at LSB and shift left
            carry_shift <= {carry_shift[63:0], cout};

            // After 64 cycles, output ready and assembled from sum_pipe and last carry
            // The sum_pipe register holds bits shifted in over 64 cycles from LSB to MSB

            // When enable shifted through 64 cycles arrives at MSB bit of en_shift,
            // output the result and valid signal

            o_en <= en_shift[64];

            if (en_shift[64]) begin
                // Assemble final result: sum bits + last carry bit at MSB
                // sum_pipe holds 64 sum bits LSB-first (sum_pipe[0] is newest sum bit)
                // To output MSB first, reverse bits in sum_pipe

                // Reverse sum_pipe bits
                reg [63:0] sum_rev;
                for (i = 0; i < 64; i = i + 1) begin
                    sum_rev[i] = sum_pipe[63 - i];
                end

                result <= {carry_shift[64], sum_rev};
            end else begin
                result <= 0;
            end
        end
    end

endmodule