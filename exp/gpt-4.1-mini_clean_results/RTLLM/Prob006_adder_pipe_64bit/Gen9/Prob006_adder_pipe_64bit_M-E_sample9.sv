module adder_pipe_64bit(
    input  wire         clk,
    input  wire         rst_n,
    input  wire         i_en,
    input  wire [63:0]  adda,
    input  wire [63:0]  addb,
    output reg  [64:0]  result,
    output reg          o_en
);

    // Parameters for splitting into 4 blocks of 16 bits
    localparam STAGES = 4;
    localparam BLOCK_BITS = 16;

    // Pipeline registers to hold operands per stage
    reg [BLOCK_BITS-1:0] adda_reg [0:STAGES-1];
    reg [BLOCK_BITS-1:0] addb_reg [0:STAGES-1];

    // Sum registers per stage (for each 16-bit block)
    reg [BLOCK_BITS-1:0] sum_reg [0:STAGES-1];

    // Carry registers between stages (carry into stage 0 is 0)
    reg carry_reg [0:STAGES];

    // Pipeline shift register for enable signal to track valid output
    reg [STAGES:0] en_pipe;

    integer i;

    // Function to perform 16-bit ripple carry addition with carry_in
    // Returns 17-bit sum: [15:0] sum and [16] carry_out
    function [BLOCK_BITS:0] add16;
        input [BLOCK_BITS-1:0] a;
        input [BLOCK_BITS-1:0] b;
        input carry_in;
        reg [BLOCK_BITS:0] sum_full;
    begin
        sum_full = a + b + carry_in;
        add16 = sum_full;
    end
    endfunction

    // Registers to hold combinational adder results
    reg [BLOCK_BITS:0] stage_sum_carry [0:STAGES-1];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers
            for (i = 0; i < STAGES; i = i + 1) begin
                adda_reg[i] <= {BLOCK_BITS{1'b0}};
                addb_reg[i] <= {BLOCK_BITS{1'b0}};
                sum_reg[i] <= {BLOCK_BITS{1'b0}};
                carry_reg[i] <= 1'b0;
                stage_sum_carry[i] <= {(BLOCK_BITS+1){1'b0}};
            end
            carry_reg[STAGES] <= 1'b0;
            en_pipe <= {(STAGES+1){1'b0}};
            result <= {(BLOCK_BITS*STAGES+1){1'b0}};
            o_en <= 1'b0;
        end else begin
            // Shift enable pipeline to track data validity
            en_pipe <= {en_pipe[STAGES-1:0], i_en};

            // Stage 0: latch lower 16 bits of adda and addb, carry_in = 0
            if (i_en) begin
                adda_reg[0] <= adda[BLOCK_BITS-1:0];
                addb_reg[0] <= addb[BLOCK_BITS-1:0];
            end else begin
                adda_reg[0] <= adda_reg[0];
                addb_reg[0] <= addb_reg[0];
            end
            carry_reg[0] <= 1'b0; // initial carry in zero

            // Perform addition for stage 0 combinationally
            stage_sum_carry[0] = add16(adda_reg[0], addb_reg[0], carry_reg[0]);
            sum_reg[0] <= stage_sum_carry[0][BLOCK_BITS-1:0];
            carry_reg[1] <= stage_sum_carry[0][BLOCK_BITS];

            // Pipeline other stages
            for (i = 1; i < STAGES; i = i + 1) begin
                // Latch next 16-bit operands
                if (i_en && i == 0) begin
                    // Actually handled in stage 0 above
                    adda_reg[i] <= adda[(i+1)*BLOCK_BITS-1 -: BLOCK_BITS];
                    addb_reg[i] <= addb[(i+1)*BLOCK_BITS-1 -: BLOCK_BITS];
                end else if (i_en) begin
                    // Load operands for new input only at stage 0,
                    // but since input operands registered at stage 0, 
                    // propagate registers down pipeline
                    // We'll handle operand propagation:
                    // Shift operand registers forward (carry forward)
                    // Actually we need to propagate the operand registers:
                    // so update registers to previous stage value to keep pipeline flowing
                    adda_reg[i] <= adda_reg[i];
                    addb_reg[i] <= addb_reg[i];
                end else begin
                    // Hold values if no new enable
                    adda_reg[i] <= adda_reg[i];
                    addb_reg[i] <= addb_reg[i];
                end
            end

            // Propagate operands down the pipeline (except stage 0 which loaded new operands)
            for (i = STAGES-1; i > 0; i = i - 1) begin
                adda_reg[i] <= adda_reg[i-1];
                addb_reg[i] <= addb_reg[i-1];
            end

            // For stages 1 to 3: compute sums and carry outs using ripple carry adder blocks
            for (i = 1; i < STAGES; i = i + 1) begin
                stage_sum_carry[i] = add16(adda_reg[i], addb_reg[i], carry_reg[i]);
                sum_reg[i] <= stage_sum_carry[i][BLOCK_BITS-1:0];
                carry_reg[i+1] <= stage_sum_carry[i][BLOCK_BITS];
            end

            // Assemble output result once valid data has reached last pipeline stage (en_pipe[STAGES])
            if (en_pipe[STAGES]) begin
                result <= {
                    carry_reg[STAGES],      // bit 64 carry out
                    sum_reg[3],             // bits 63:48
                    sum_reg[2],             // bits 47:32
                    sum_reg[1],             // bits 31:16
                    sum_reg[0]              // bits 15:0
                };
            end else begin
                result <= result; // hold previous result
            end

            // Output enable follows delayed i_en
            o_en <= en_pipe[STAGES];
        end
    end
endmodule