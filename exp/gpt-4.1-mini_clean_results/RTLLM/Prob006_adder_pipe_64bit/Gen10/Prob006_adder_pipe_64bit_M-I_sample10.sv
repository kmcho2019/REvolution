module adder_pipe_64bit (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        i_en,
    input  wire [63:0] adda,
    input  wire [63:0] addb,
    output reg  [64:0] result,
    output reg         o_en
);

    // Pipeline depth for ripple carry: 64 bits + 1 final carry
    localparam DEPTH = 65;

    // Pipeline registers:
    // Store one bit of A and B per pipeline stage
    reg a_bit_pipe   [0:DEPTH-2];  // stages 0 to 63 (64 bits)
    reg b_bit_pipe   [0:DEPTH-2];
    reg sum_bit_pipe [0:DEPTH-2];  // sum bits stored after addition at each stage
    reg carry_pipe   [0:DEPTH-1];  // carry bits: from stage 0 (carry_in) to stage 64 (final carry_out)

    // Pipeline enable register: shifts i_en through DEPTH cycles
    reg [DEPTH-1:0] en_pipe;

    integer i;

    // Asynchronously reset all registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Clear all pipeline registers
            for (i = 0; i < DEPTH-1; i = i + 1) begin
                a_bit_pipe[i]   <= 1'b0;
                b_bit_pipe[i]   <= 1'b0;
                sum_bit_pipe[i] <= 1'b0;
            end
            for (i = 0; i < DEPTH; i = i + 1) begin
                carry_pipe[i]   <= 1'b0;
            end
            en_pipe <= {DEPTH{1'b0}};
            result <= {DEPTH{1'b0}};
            o_en <= 1'b0;
        end else begin
            // Shift enable pipeline
            en_pipe <= {en_pipe[DEPTH-2:0], i_en};

            // Stage 0 input:
            // Load operand bits only when i_en is asserted (new addition)
            if (i_en) begin
                a_bit_pipe[0] <= adda[0];
                b_bit_pipe[0] <= addb[0];
                carry_pipe[0] <= 1'b0;  // Initial carry in = 0
            end else begin
                // Keep or shift data later handled by stages
                // (No operand bits update if no new addition)
                // To maintain valid pipeline, bits will shift down stages in next always blocks
                // carry_pipe[0] also unchanged if no new addition
                carry_pipe[0] <= carry_pipe[0];
                a_bit_pipe[0] <= a_bit_pipe[0];
                b_bit_pipe[0] <= b_bit_pipe[0];
            end

            // Stages 1 to 63: shift operands and carry along pipeline
            for (i = 1; i < DEPTH-1; i = i + 1) begin
                a_bit_pipe[i] <= a_bit_pipe[i-1];
                b_bit_pipe[i] <= b_bit_pipe[i-1];
            end

            // Perform bitwise addition and pipeline carry for each stage
            for (i = 0; i < DEPTH-1; i = i + 1) begin
                // sum = a ^ b ^ carry_in
                sum_bit_pipe[i] <= a_bit_pipe[i] ^ b_bit_pipe[i] ^ carry_pipe[i];
                // carry_out = majority(a, b, carry_in)
                carry_pipe[i+1] <= (a_bit_pipe[i] & b_bit_pipe[i]) |
                                   (a_bit_pipe[i] & carry_pipe[i]) |
                                   (b_bit_pipe[i] & carry_pipe[i]);
            end

            // After all bits processed, when en_pipe[DEPTH-1] is high,
            // assemble final result from sum bits and last carry

            o_en <= en_pipe[DEPTH-1]; // output enable delayed by pipeline depth

            if (en_pipe[DEPTH-1]) begin
                // assemble sum vector from sum bits pipeline registers
                reg [63:0] sum_vector;
                for (i = 0; i < 64; i = i + 1) begin
                    sum_vector[i] = sum_bit_pipe[i];
                end
                result <= {carry_pipe[DEPTH-1], sum_vector};
            end
        end
    end

endmodule