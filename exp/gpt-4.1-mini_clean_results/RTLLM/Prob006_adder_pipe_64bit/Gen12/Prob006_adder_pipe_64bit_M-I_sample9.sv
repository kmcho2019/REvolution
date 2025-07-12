module adder_pipe_64bit (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        i_en,
    input  wire [63:0] adda,
    input  wire [63:0] addb,
    output reg  [64:0] result,
    output reg         o_en
);

    // Pipeline stages configuration
    localparam STAGES = 4;
    localparam SEG_BITS = 16;

    // Pipeline registers for inputs
    reg [63:0] adda_pipe [0:STAGES];
    reg [63:0] addb_pipe [0:STAGES];
    reg        en_pipe   [0:STAGES];

    // Pipeline registers for carry signals (one per stage + final carry)
    reg        carry_pipe [0:STAGES];

    // Pipeline registers for partial sums
    reg [SEG_BITS-1:0] sum_seg [0:STAGES-1];

    integer i;

    // Addition of each 16-bit segment with carry-in producing sum segment and carry-out
    // Function returns {carry_out, sum}
    function [SEG_BITS:0] add_seg_with_carry;
        input [SEG_BITS-1:0] a_seg;
        input [SEG_BITS-1:0] b_seg;
        input                cin;
        reg   [SEG_BITS:0]   sum_full;
    begin
        sum_full = {1'b0, a_seg} + {1'b0, b_seg} + cin;
        add_seg_with_carry = sum_full;
    end
    endfunction

    // Synchronous pipeline implementation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers and outputs
            for (i = 0; i <= STAGES; i = i + 1) begin
                adda_pipe[i] <= 64'd0;
                addb_pipe[i] <= 64'd0;
                en_pipe[i]   <= 1'b0;
                carry_pipe[i] <= 1'b0;
            end
            for (i = 0; i < STAGES; i = i + 1) begin
                sum_seg[i] <= {SEG_BITS{1'b0}};
            end
            result <= 65'd0;
            o_en <= 1'b0;
        end else begin
            // Stage 0: Load inputs and enable
            adda_pipe[0] <= adda;
            addb_pipe[0] <= addb;
            en_pipe[0]   <= i_en;
            carry_pipe[0] <= 1'b0; // initial carry-in zero

            // Process pipeline stages
            for (i = 0; i < STAGES; i = i + 1) begin
                // Propagate inputs and enable registers to next stage
                if (i < STAGES - 1) begin
                    adda_pipe[i+1] <= adda_pipe[i];
                    addb_pipe[i+1] <= addb_pipe[i];
                    en_pipe[i+1]   <= en_pipe[i];
                    carry_pipe[i+1] <= carry_pipe[i+1]; // updated below after addition
                end

                // Extract segments for this stage
                // Each stage adds 16 bits segment with carry_in from previous stage
                // The segments are aligned from LSB upwards:
                // stage 0: bits [15:0]
                // stage 1: bits [31:16]
                // ...
                // stage 3: bits [63:48]
                //
                // Perform addition for this segment with carry_pipe[i]
                // Store sum segment and carry_out

                reg [SEG_BITS-1:0] a_seg;
                reg [SEG_BITS-1:0] b_seg;
                reg carry_in;
                reg [SEG_BITS:0] add_res; // includes carry out

                a_seg    = adda_pipe[i][SEG_BITS*i +: SEG_BITS];
                b_seg    = addb_pipe[i][SEG_BITS*i +: SEG_BITS];
                carry_in = carry_pipe[i];

                add_res = add_seg_with_carry(a_seg, b_seg, carry_in);
                sum_seg[i] <= add_res[SEG_BITS-1:0];
                // Update carry for next stage (except last stage)
                if (i < STAGES) begin
                    carry_pipe[i+1] <= add_res[SEG_BITS];
                end
            end

            // Output enable pipelined from last stage enable
            o_en <= en_pipe[STAGES];

            // Assemble final result when valid (one cycle after last pipeline stage)
            if (en_pipe[STAGES]) begin
                // Concatenate sum segments from all stages plus final carry
                // sum segments order: stage 0 is LSB
                result <= {carry_pipe[STAGES], 
                           sum_seg[STAGES-1],
                           sum_seg[STAGES-2],
                           sum_seg[STAGES-3],
                           sum_seg[0]};
                // But the above concatenation is wrong because it places stage 0 sum in LSB position of concat
                // Need to order sum segments from MSB stage to LSB stage correctly
                // Correct ordering:
                // stage 3 [63:48], stage 2 [47:32], stage 1 [31:16], stage 0 [15:0]

                // So write as:
                // {carry_pipe[STAGES],
                //  sum_seg[3], sum_seg[2], sum_seg[1], sum_seg[0]} with each segment 16 bits

                // Fixing result assembly:
                result <= {carry_pipe[STAGES], sum_seg[3], sum_seg[2], sum_seg[1], sum_seg[0]};
            end
        end
    end

endmodule