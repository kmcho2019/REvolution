module adder_pipe_64bit (
    input              clk,
    input              rst_n,
    input              i_en,
    input      [63:0]  adda,
    input      [63:0]  addb,
    output reg [64:0]  result,
    output reg         o_en
);

    localparam STG_WIDTH = 8;     // bits per stage
    localparam NUM_STG   = 8;     // total stages: 64/8 = 8

    // Pipeline registers for operands per stage
    reg [STG_WIDTH-1:0] adda_pipe  [0:NUM_STG-1];
    reg [STG_WIDTH-1:0] addb_pipe  [0:NUM_STG-1];

    // Sum registers for each stage
    reg [STG_WIDTH-1:0] sum_pipe   [0:NUM_STG-1];

    // Carry registers between stages (NUM_STG+1)
    reg carry_pipe [0:NUM_STG];

    // Pipeline enable registers
    reg en_pipe [0:NUM_STG];

    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset pipeline registers and outputs
            for (i = 0; i < NUM_STG; i = i + 1) begin
                adda_pipe[i]  <= {STG_WIDTH{1'b0}};
                addb_pipe[i]  <= {STG_WIDTH{1'b0}};
                sum_pipe[i]   <= {STG_WIDTH{1'b0}};
                carry_pipe[i] <= 1'b0;
                en_pipe[i]    <= 1'b0;
            end
            carry_pipe[NUM_STG] <= 1'b0;
            en_pipe[NUM_STG]    <= 1'b0;
            result <= 65'b0;
            o_en   <= 1'b0;
        end else begin
            // Stage 0 inputs load and enable
            if (i_en) begin
                adda_pipe[0] <= adda[ 0*STG_WIDTH +: STG_WIDTH];
                addb_pipe[0] <= addb[ 0*STG_WIDTH +: STG_WIDTH];
            end
            carry_pipe[0] <= 1'b0; // Initial carry-in zero
            en_pipe[0]    <= i_en;

            // Pipeline operand slices for stages 1 to NUM_STG-1
            for (i = 1; i < NUM_STG; i = i + 1) begin
                if (en_pipe[i-1]) begin
                    adda_pipe[i] <= adda[i*STG_WIDTH +: STG_WIDTH];
                    addb_pipe[i] <= addb[i*STG_WIDTH +: STG_WIDTH];
                end
                en_pipe[i] <= en_pipe[i-1];
                carry_pipe[i] <= carry_pipe[i]; // Hold current carry_pipe for now
            end

            // Compute sum and carry for each stage
            for (i = 0; i < NUM_STG; i = i + 1) begin
                {carry_pipe[i+1], sum_pipe[i]} <= adda_pipe[i] + addb_pipe[i] + carry_pipe[i];
            end

            // Propagate enable to output stage
            en_pipe[NUM_STG] <= en_pipe[NUM_STG-1];

            // Assemble 65-bit result on valid output enable
            if (en_pipe[NUM_STG]) begin
                // Concatenate sum from MSB stage to LSB stage with final carry-out
                result <= {carry_pipe[NUM_STG],
                           sum_pipe[NUM_STG-1],
                           sum_pipe[NUM_STG-2],
                           sum_pipe[NUM_STG-3],
                           sum_pipe[NUM_STG-4],
                           sum_pipe[NUM_STG-5],
                           sum_pipe[NUM_STG-6],
                           sum_pipe[NUM_STG-7],
                           sum_pipe[NUM_STG-8]};
            end

            o_en <= en_pipe[NUM_STG];
        end
    end
endmodule