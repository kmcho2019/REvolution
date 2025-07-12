module adder_pipe_64bit (
    input  wire         clk,
    input  wire         rst_n,
    input  wire         i_en,
    input  wire [63:0]  adda,
    input  wire [63:0]  addb,
    output reg  [64:0]  result,
    output reg          o_en
);

    localparam STG_CNT = 8;          // Number of pipeline stages (64 bits / 8 bits per stage)
    localparam STG_WIDTH = 8;        // Bits per stage

    // Pipeline registers for operand chunks and carry
    reg [STG_WIDTH-1:0] adda_pipe [0:STG_CNT-1];
    reg [STG_WIDTH-1:0] addb_pipe [0:STG_CNT-1];
    reg                 carry_pipe [0:STG_CNT];  // carry_pipe[0] is input carry (0), carry_pipe[STG_CNT] is final carry out

    // Pipeline registers for sum segments
    reg [STG_WIDTH-1:0] sum_pipe [0:STG_CNT-1];

    // Pipeline registers for input enable shifted through pipeline to generate output enable
    reg [STG_CNT:0] en_pipe;

    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers
            for (i = 0; i < STG_CNT; i = i + 1) begin
                adda_pipe[i] <= {STG_WIDTH{1'b0}};
                addb_pipe[i] <= {STG_WIDTH{1'b0}};
                sum_pipe[i]  <= {STG_WIDTH{1'b0}};
                carry_pipe[i] <= 1'b0;
            end
            carry_pipe[STG_CNT] <= 1'b0;
            en_pipe <= {(STG_CNT+1){1'b0}};
            result <= 65'b0;
            o_en <= 1'b0;
        end else begin
            // Shift enable pipeline
            en_pipe <= {en_pipe[STG_CNT-1:0], i_en};

            // Stage 0: Load input operands chunks and input carry = 0 if i_en asserted
            if (i_en) begin
                // Load 8-bit chunks from input operands
                for (i = 0; i < STG_CNT; i = i + 1) begin
                    adda_pipe[i] <= adda[i*STG_WIDTH +: STG_WIDTH];
                    addb_pipe[i] <= addb[i*STG_WIDTH +: STG_WIDTH];
                end
                carry_pipe[0] <= 1'b0; // Initial carry-in zero
            end else begin
                // Hold previous values if no new input
                for (i = 0; i < STG_CNT; i = i + 1) begin
                    adda_pipe[i] <= adda_pipe[i];
                    addb_pipe[i] <= addb_pipe[i];
                end
                carry_pipe[0] <= carry_pipe[0];
            end

            // Pipeline stages compute sums and carry outs
            for (i = 0; i < STG_CNT; i = i + 1) begin
                // Compute sum and carry out for each stage
                {carry_pipe[i+1], sum_pipe[i]} <= adda_pipe[i] + addb_pipe[i] + carry_pipe[i];
            end

            // Assemble final result when output enable asserted
            if (en_pipe[STG_CNT]) begin
                result <= {carry_pipe[STG_CNT], 
                           sum_pipe[7], sum_pipe[6], sum_pipe[5], sum_pipe[4],
                           sum_pipe[3], sum_pipe[2], sum_pipe[1], sum_pipe[0]};
            end else begin
                result <= result; // Hold last result
            end

            // Output enable delayed by STG_CNT cycles from input enable
            o_en <= en_pipe[STG_CNT];
        end
    end

endmodule