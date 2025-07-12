module adder_pipe_64bit(
    input              clk,
    input              rst_n,
    input              i_en,
    input      [63:0]  adda,
    input      [63:0]  addb,
    output reg [64:0]  result,
    output reg         o_en
);

    // Parameters for pipeline granularity
    localparam STG_BITS = 4;
    localparam STG_NUM  = 64 / STG_BITS; // 16 stages

    // Pipeline registers for operands slices per stage
    reg [STG_BITS-1:0] adda_pipe [0:STG_NUM-1];
    reg [STG_BITS-1:0] addb_pipe [0:STG_NUM-1];

    // Pipeline registers for sum slices per stage
    reg [STG_BITS-1:0] sum_pipe [0:STG_NUM-1];

    // Pipeline registers for carry signals between stages
    reg carry_pipe [0:STG_NUM]; // carry_pipe[0] is carry-in for stage 0, initialized to 0

    // Pipeline register for valid enable signals
    reg [STG_NUM-1:0] en_pipe;

    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers and output
            for (i = 0; i < STG_NUM; i = i + 1) begin
                adda_pipe[i] <= {STG_BITS{1'b0}};
                addb_pipe[i] <= {STG_BITS{1'b0}};
                sum_pipe[i]  <= {STG_BITS{1'b0}};
            end
            for (i = 0; i <= STG_NUM; i = i + 1) begin
                carry_pipe[i] <= 1'b0;
            end
            en_pipe <= {STG_NUM{1'b0}};
            result <= 65'b0;
            o_en <= 1'b0;
        end else begin
            // Stage 0 input registration and enable shift register update
            if (i_en) begin
                // Load slices from inputs into stage 0 operand registers
                for (i = 0; i < STG_NUM; i = i + 1) begin
                    adda_pipe[i] <= adda[(i+1)*STG_BITS-1 -: STG_BITS];
                    addb_pipe[i] <= addb[(i+1)*STG_BITS-1 -: STG_BITS];
                end
            end

            // Shift valid enable pipeline, insert current i_en at LSB (stage 0)
            en_pipe <= {en_pipe[STG_NUM-2:0], i_en};

            // Initialize carry in for stage 0 to zero when new input arrives, else zero otherwise
            carry_pipe[0] <= i_en ? 1'b0 : carry_pipe[0];

            // Compute pipeline stages:
            // Each stage adds operands slice with carry-in from previous stage, sum and carry-out registered
            for (i = 0; i < STG_NUM; i = i + 1) begin
                if (en_pipe[i]) begin
                    // Add slice + carry-in
                    {carry_pipe[i+1], sum_pipe[i]} <= adda_pipe[i] + addb_pipe[i] + carry_pipe[i];
                end else begin
                    // No valid data, keep sum and carry as zero
                    sum_pipe[i] <= sum_pipe[i];
                    carry_pipe[i+1] <= carry_pipe[i+1];
                end
            end

            // Output assembles when last stage valid enable asserted
            if (en_pipe[STG_NUM-1]) begin
                // Concatenate final carry and all sum slices from MSB to LSB
                result <= {carry_pipe[STG_NUM],
                          sum_pipe[STG_NUM-1], sum_pipe[STG_NUM-2], sum_pipe[STG_NUM-3], sum_pipe[STG_NUM-4],
                          sum_pipe[11], sum_pipe[10], sum_pipe[9],  sum_pipe[8],
                          sum_pipe[7],  sum_pipe[6],  sum_pipe[5],  sum_pipe[4],
                          sum_pipe[3],  sum_pipe[2],  sum_pipe[1],  sum_pipe[0]};
                o_en <= 1'b1;
            end else begin
                result <= 65'b0;
                o_en <= 1'b0;
            end
        end
    end
endmodule