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

    // Carry pipeline registers, carry_pipe[0] is initial carry-in
    reg        carry_pipe [0:STAGES];

    // Partial sum segments per stage (8 bits each)
    reg [SEG_BITS-1:0] sum_seg [0:STAGES-1];

    // Combinational wires for the add segments and carry-in per stage
    wire [SEG_BITS-1:0] a_seg [0:STAGES-1];
    wire [SEG_BITS-1:0] b_seg [0:STAGES-1];
    wire carry_in [0:STAGES-1];
    wire [SEG_BITS:0] sum_with_carry [0:STAGES-1];

    genvar i;
    generate
        for (i = 0; i < STAGES; i = i + 1) begin : gen_add_segments
            // Extract the 8-bit segments for this stage from the registered operands
            assign a_seg[i] = adda_pipe[i][(SEG_BITS*i) +: SEG_BITS];
            assign b_seg[i] = addb_pipe[i][(SEG_BITS*i) +: SEG_BITS];
            assign carry_in[i] = carry_pipe[i];

            // Perform 8-bit addition with carry_in
            assign sum_with_carry[i] = {1'b0, a_seg[i]} + {1'b0, b_seg[i]} + carry_in[i];
        end
    endgenerate

    integer j;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers
            for (j = 0; j <= STAGES; j = j + 1) begin
                adda_pipe[j] <= 64'd0;
                addb_pipe[j] <= 64'd0;
                en_pipe[j] <= 1'b0;
                carry_pipe[j] <= 1'b0;
            end
            for (j = 0; j < STAGES; j = j + 1) begin
                sum_seg[j] <= {SEG_BITS{1'b0}};
            end
            result <= 65'd0;
            o_en <= 1'b0;
        end else begin
            // Load inputs and initial carry-in on stage 0
            adda_pipe[0] <= adda;
            addb_pipe[0] <= addb;
            en_pipe[0]   <= i_en;
            carry_pipe[0] <= 1'b0;

            // Pipeline carry, enable, operands, and partial sums through stages
            for (j = 0; j < STAGES; j = j + 1) begin
                // Register sum segment from combinational add result
                sum_seg[j] <= sum_with_carry[j][SEG_BITS-1:0];

                // Register carry out for next stage
                carry_pipe[j+1] <= sum_with_carry[j][SEG_BITS];

                // Propagate operands and enable to next stage, except for last stage
                if (j < STAGES - 1) begin
                    adda_pipe[j+1] <= adda_pipe[j];
                    addb_pipe[j+1] <= addb_pipe[j];
                    en_pipe[j+1] <= en_pipe[j];
                end
            end

            // Output enable delayed to last stage enable
            o_en <= en_pipe[STAGES];

            // Assemble output result when output is enabled
            if (en_pipe[STAGES]) begin
                // Concatenate final carry and all sum segments in correct order (MSB to LSB)
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