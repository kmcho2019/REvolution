module adder_pipe_64bit(
    input  wire         clk,
    input  wire         rst_n,
    input  wire         i_en,
    input  wire [63:0]  adda,
    input  wire [63:0]  addb,
    output reg  [64:0]  result,
    output reg          o_en
);

    // Parameters
    localparam BLOCK_BITS = 8;
    localparam STAGES = 64 / BLOCK_BITS; // 8 stages

    // Pipeline registers for operand blocks per stage
    reg [BLOCK_BITS-1:0] adda_pipe [0:STAGES-1];
    reg [BLOCK_BITS-1:0] addb_pipe [0:STAGES-1];

    // Pipeline registers for sum blocks per stage
    reg [BLOCK_BITS-1:0] sum_pipe [0:STAGES-1];

    // Pipeline registers for carry signals per stage
    reg carry_pipe [0:STAGES]; // carry_pipe[0] = initial carry-in = 0

    // Pipeline register for enable signal delayed through stages
    reg [STAGES:0] en_pipe;

    integer i;

    // Combinational function to add 8 bits plus carry_in, returning sum and carry_out
    function [BLOCK_BITS:0] add_block;
        input [BLOCK_BITS-1:0] a;
        input [BLOCK_BITS-1:0] b;
        input carry_in;
        reg [BLOCK_BITS:0] sum_extended;
    begin
        sum_extended = {1'b0, a} + {1'b0, b} + carry_in;
        add_block = sum_extended;
    end
    endfunction

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset pipeline registers
            for (i = 0; i < STAGES; i = i + 1) begin
                adda_pipe[i] <= {BLOCK_BITS{1'b0}};
                addb_pipe[i] <= {BLOCK_BITS{1'b0}};
                sum_pipe[i]  <= {BLOCK_BITS{1'b0}};
                carry_pipe[i] <= 1'b0;
            end
            carry_pipe[STAGES] <= 1'b0;
            en_pipe <= {(STAGES+1){1'b0}};
            result <= {(BLOCK_BITS*STAGES+1){1'b0}};
            o_en <= 1'b0;
        end else begin
            // Stage 0: latch input operands and initial carry_in = 0 when i_en asserted
            en_pipe <= {en_pipe[STAGES-1:0], i_en};
            carry_pipe[0] <= 1'b0; // initial carry_in zero for stage 0

            if (i_en) begin
                // Load input operand blocks into stage 0 registers
                for (i = 0; i < STAGES; i = i + 1) begin
                    adda_pipe[i] <= adda[(i+1)*BLOCK_BITS-1 -: BLOCK_BITS];
                    addb_pipe[i] <= addb[(i+1)*BLOCK_BITS-1 -: BLOCK_BITS];
                end
            end else begin
                // Hold previous values if not enabled
                for (i = 0; i < STAGES; i = i + 1) begin
                    adda_pipe[i] <= adda_pipe[i];
                    addb_pipe[i] <= addb_pipe[i];
                end
                carry_pipe[0] <= carry_pipe[0];
            end

            // Pipeline ripple carry addition stages
            // For stage 0:
            // - add block 0 operands with carry_pipe[0]
            // - register sum and carry_out for next stage carry
            reg [BLOCK_BITS:0] add_res;
            // Stage 0
            add_res = add_block(adda_pipe[0], addb_pipe[0], carry_pipe[0]);
            sum_pipe[0] <= add_res[BLOCK_BITS-1:0];
            carry_pipe[1] <= add_res[BLOCK_BITS];

            // For stages 1 to STAGES-1:
            // Inputs come from previous stage pipeline registers
            for (i = 1; i < STAGES; i = i + 1) begin
                add_res = add_block(adda_pipe[i], addb_pipe[i], carry_pipe[i]);
                sum_pipe[i] <= add_res[BLOCK_BITS-1:0];
                carry_pipe[i+1] <= add_res[BLOCK_BITS];
            end

            // Output assembly and output enable
            if (en_pipe[STAGES]) begin
                // Assemble the result by concatenating sum blocks + final carry
                reg [63:0] sum_vector;
                for (i = 0; i < STAGES; i = i + 1) begin
                    sum_vector[(i+1)*BLOCK_BITS-1 -: BLOCK_BITS] = sum_pipe[i];
                end
                result <= {carry_pipe[STAGES], sum_vector};
            end else begin
                result <= result; // Hold previous
            end

            // Output enable propagation
            o_en <= en_pipe[STAGES];
        end
    end

endmodule