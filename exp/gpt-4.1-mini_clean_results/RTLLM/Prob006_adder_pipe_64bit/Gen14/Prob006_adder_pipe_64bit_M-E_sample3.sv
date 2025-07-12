module adder_pipe_64bit (
    input              clk,
    input              rst_n,
    input              i_en,
    input      [63:0]  adda,
    input      [63:0]  addb,
    output reg [64:0]  result,
    output reg         o_en
);

    localparam STG_BITS = 8;
    localparam NUM_STG  = 64 / STG_BITS; // 8 stages

    // Pipeline registers for operand slices
    reg [STG_BITS-1:0] adda_pipe   [0:NUM_STG-1];
    reg [STG_BITS-1:0] addb_pipe   [0:NUM_STG-1];

    // Pipeline registers for sum slices
    reg [STG_BITS-1:0] sum_pipe    [0:NUM_STG-1];

    // Carry between stages (NUM_STG + 1)
    reg carry_pipe [0:NUM_STG];

    // Enable pipeline registers
    reg en_pipe [0:NUM_STG];

    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset pipeline registers
            for (i = 0; i < NUM_STG; i = i + 1) begin
                adda_pipe[i] <= {STG_BITS{1'b0}};
                addb_pipe[i] <= {STG_BITS{1'b0}};
                sum_pipe[i]  <= {STG_BITS{1'b0}};
                carry_pipe[i] <= 1'b0;
                en_pipe[i] <= 1'b0;
            end
            carry_pipe[NUM_STG] <= 1'b0;
            en_pipe[NUM_STG]    <= 1'b0;
            result <= 65'b0;
            o_en   <= 1'b0;
        end else begin
            // Stage 0: latch inputs slices, carry_in = 0, enable = i_en
            if (i_en) begin
                for (i = 0; i < NUM_STG; i = i + 1) begin
                    adda_pipe[i] <= adda[STG_BITS*i +: STG_BITS];
                    addb_pipe[i] <= addb[STG_BITS*i +: STG_BITS];
                end
            end else begin
                for (i = 0; i < NUM_STG; i = i + 1) begin
                    adda_pipe[i] <= adda_pipe[i];
                    addb_pipe[i] <= addb_pipe[i];
                end
            end
            carry_pipe[0] <= 1'b0;
            en_pipe[0] <= i_en;

            // For pipeline stages 0..7 compute sum and carry out using carry in
            for (i = 0; i < NUM_STG; i = i + 1) begin
                {carry_pipe[i+1], sum_pipe[i]} <= adda_pipe[i] + addb_pipe[i] + carry_pipe[i];
            end

            // Propagate enable signal through pipeline
            for (i = 1; i <= NUM_STG; i = i + 1) begin
                en_pipe[i] <= en_pipe[i-1];
            end

            // When final stage enable is high, assemble the final 65-bit result
            if (en_pipe[NUM_STG]) begin
                // Concatenate sum slices from MSB stage to LSB stage with final carry out
                // sum_pipe[0] is LSB slice, sum_pipe[NUM_STG-1] MSB slice
                result <= {carry_pipe[NUM_STG],
                           sum_pipe[NUM_STG-1],
                           sum_pipe[NUM_STG-2],
                           sum_pipe[NUM_STG-3],
                           sum_pipe[NUM_STG-4],
                           sum_pipe[NUM_STG-5],
                           sum_pipe[NUM_STG-6],
                           sum_pipe[NUM_STG-7],
                           sum_pipe[0]};
            end else begin
                result <= result; // hold previous value
            end

            o_en <= en_pipe[NUM_STG];
        end
    end

endmodule