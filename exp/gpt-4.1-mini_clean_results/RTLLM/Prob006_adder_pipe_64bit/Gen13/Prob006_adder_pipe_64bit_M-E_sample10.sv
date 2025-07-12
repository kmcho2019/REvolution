module adder_pipe_64bit (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        i_en,
    input  wire [63:0] adda,
    input  wire [63:0] addb,
    output reg  [64:0] result,
    output reg         o_en
);

    localparam STAGES = 8;
    localparam SEG_BITS = 8;

    // Pipeline registers for operands per stage
    reg [63:0] adda_pipe [0:STAGES];
    reg [63:0] addb_pipe [0:STAGES];
    reg        en_pipe   [0:STAGES];

    // Carry pipeline registers
    reg        carry_pipe [0:STAGES]; // carry_pipe[0] is initial carry-in (zero)

    // Partial sum segments per stage
    reg [SEG_BITS-1:0] sum_seg [0:STAGES-1];

    integer i;

    // Initial assignments and reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i <= STAGES; i = i + 1) begin
                adda_pipe[i] <= 64'd0;
                addb_pipe[i] <= 64'd0;
                en_pipe[i] <= 1'b0;
                carry_pipe[i] <= 1'b0;
            end
            for (i = 0; i < STAGES; i = i + 1) begin
                sum_seg[i] <= {SEG_BITS{1'b0}};
            end
            result <= 65'd0;
            o_en <= 1'b0;
        end else begin
            // Stage 0: Load inputs, initial carry zero, and input enable
            adda_pipe[0] <= adda;
            addb_pipe[0] <= addb;
            en_pipe[0]   <= i_en;
            carry_pipe[0] <= 1'b0;

            // Pipeline carry and enable propagation and addition per stage
            for (i = 0; i < STAGES; i = i + 1) begin
                // Extract segments for this stage's operands from pipe stage i
                // These are static slices aligned at 8-bit boundaries
                // Example: stage 0 sums bits [7:0], stage 1 sums bits [15:8], etc.
                wire [SEG_BITS-1:0] a_seg = adda_pipe[i][(SEG_BITS*i) +: SEG_BITS];
                wire [SEG_BITS-1:0] b_seg = addb_pipe[i][(SEG_BITS*i) +: SEG_BITS];
                wire carry_in = carry_pipe[i];

                // Perform 8-bit addition with carry_in
                wire [SEG_BITS:0] sum_with_carry = {1'b0, a_seg} + {1'b0, b_seg} + carry_in;

                // Register the sum segment result
                sum_seg[i] <= sum_with_carry[SEG_BITS-1:0];

                // Register carry-out for next stage, except for last stage
                carry_pipe[i+1] <= sum_with_carry[SEG_BITS];

                // Propagate operands and enable to next pipeline stage (except last stage)
                if (i < STAGES - 1) begin
                    adda_pipe[i+1] <= adda_pipe[i];
                    addb_pipe[i+1] <= addb_pipe[i];
                    en_pipe[i+1] <= en_pipe[i];
                end
            end

            // Output enable is the enable at the last pipeline stage
            o_en <= en_pipe[STAGES];

            // When output is enabled, assemble the final result
            if (en_pipe[STAGES]) begin
                // Concatenate partial sums from MSB stage to LSB stage and final carry
                // sum_seg[7] is bits [63:56], sum_seg[6] bits [55:48], ..., sum_seg[0] bits [7:0]
                // result = {carry_out, sum_seg[7], sum_seg[6], ..., sum_seg[0]}
                result <= {carry_pipe[STAGES],
                           sum_seg[7],
                           sum_seg[6],
                           sum_seg[5],
                           sum_seg[4],
                           sum_seg[3],
                           sum_seg[2],
                           sum_seg[1],
                           sum_seg[0]};
            end
        end
    end

endmodule