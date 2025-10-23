module adder_pipe_64bit (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        i_en,
    input  wire [63:0] adda,
    input  wire [63:0] addb,
    output reg  [64:0] result,
    output reg         o_en
);

    localparam DEPTH = 65; // 64 bits + 1 carry out

    // Pipeline stage registers for each bit of operands and carry
    reg [63:0] a_pipe [0:DEPTH-1]; // Operand A bits at each stage
    reg [63:0] b_pipe [0:DEPTH-1]; // Operand B bits at each stage
    reg        carry_pipe [0:DEPTH]; // Carry in at each stage (DEPTH+1 carries)

    reg        en_pipe [0:DEPTH-1]; // Enable pipeline stages

    reg        sum_bit_pipe [0:DEPTH-1]; // Sum bits produced at each stage

    integer i;

    // Sequential logic for pipeline registers and computations
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Initialize all pipeline registers to zero on reset
            for (i = 0; i < DEPTH; i = i + 1) begin
                a_pipe[i]      <= 64'b0;
                b_pipe[i]      <= 64'b0;
                sum_bit_pipe[i]<= 1'b0;
                en_pipe[i]     <= 1'b0;
            end
            for (i = 0; i <= DEPTH; i = i + 1) begin
                carry_pipe[i]  <= 1'b0;
            end
            result <= 65'b0;
            o_en   <= 1'b0;
        end else begin
            // Stage 0: load inputs if i_en asserted
            if (i_en) begin
                a_pipe[0] <= adda;
                b_pipe[0] <= addb;
            end else begin
                a_pipe[0] <= 64'b0;
                b_pipe[0] <= 64'b0;
            end

            en_pipe[0] <= i_en;
            carry_pipe[0] <= 1'b0; // Initial carry-in to stage 0 is 0

            // Compute sum bits and carries for each stage
            for (i = 0; i < DEPTH; i = i + 1) begin
                if (i != 0) begin
                    // Propagate operands, enables, and carry in from previous stage
                    a_pipe[i] <= a_pipe[i-1];
                    b_pipe[i] <= b_pipe[i-1];
                    en_pipe[i] <= en_pipe[i-1];
                    carry_pipe[i] <= carry_pipe[i-1];
                end
                // Compute sum bit and carry out for bit i
                // sum_bit = a_bit ^ b_bit ^ carry_in
                sum_bit_pipe[i] <= a_pipe[i][i] ^ b_pipe[i][i] ^ carry_pipe[i];

                // carry_out = majority(a_bit, b_bit, carry_in)
                carry_pipe[i+1] <= (a_pipe[i][i] & b_pipe[i][i]) |
                                   (a_pipe[i][i] & carry_pipe[i]) |
                                   (b_pipe[i][i] & carry_pipe[i]);
            end

            // Output enable is delayed version of i_en after DEPTH cycles
            o_en <= en_pipe[DEPTH-1];

            if (en_pipe[DEPTH-1]) begin
                // Assemble final sum from sum bits of last stage and final carry out
                // sum bits are in sum_bit_pipe[0..64] corresponding to bits 0..64
                // sum_bit_pipe stores sums at each stage for the bit matching that stage index
                // To get the 64-bit sum, collect sum_bit_pipe[i] for i=0..63
                // The final carry is carry_pipe[DEPTH]
                integer j;
                reg [64:0] final_sum;
                final_sum[64] = carry_pipe[DEPTH];
                for (j = 0; j < 64; j = j + 1) begin
                    final_sum[j] = sum_bit_pipe[j];
                end
                result <= final_sum;
            end else begin
                result <= 65'b0;
            end
        end
    end

endmodule