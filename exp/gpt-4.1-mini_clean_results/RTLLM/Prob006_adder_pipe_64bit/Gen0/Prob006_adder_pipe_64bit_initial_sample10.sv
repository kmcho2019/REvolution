module adder_pipe_64bit (
    input              clk,
    input              rst_n,
    input              i_en,
    input      [63:0]  adda,
    input      [63:0]  addb,
    output reg [64:0]  result,
    output reg         o_en
);

// Number of pipeline stages
localparam STAGES = 4;
localparam WIDTH_STAGE = 16;

// Pipeline registers for inputs, sums, carries, and enable signals
reg [15:0] adda_pipe [0:STAGES-1];
reg [15:0] addb_pipe [0:STAGES-1];

reg [15:0] sum_pipe [0:STAGES-1];
reg        carry_pipe [0:STAGES]; // carry_pipe[0] is initial carry-in (0), carry_pipe[STAGES] is final carry-out

reg        en_pipe [0:STAGES];

// Initialize carry-in of first stage to zero
// Assign carry_pipe[0] = 0 every cycle

integer i;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all pipeline registers and outputs
        for (i = 0; i < STAGES; i = i + 1) begin
            adda_pipe[i] <= 16'd0;
            addb_pipe[i] <= 16'd0;
            sum_pipe[i] <= 16'd0;
            en_pipe[i] <= 1'b0;
        end
        for (i = 0; i <= STAGES; i = i + 1)
            carry_pipe[i] <= 1'b0;
        result <= 65'd0;
        o_en <= 1'b0;
    end else begin
        // Pipeline stage 0: load inputs and enable
        if (i_en) begin
            adda_pipe[0] <= adda[15:0];
            addb_pipe[0] <= addb[15:0];
        end else begin
            adda_pipe[0] <= 16'd0;
            addb_pipe[0] <= 16'd0;
        end
        en_pipe[0] <= i_en;
        carry_pipe[0] <= 1'b0; // initial carry-in is zero

        // For stages > 0, advance pipeline inputs and enable signals
        for (i = 1; i < STAGES; i = i + 1) begin
            adda_pipe[i] <= adda[(i+1)*WIDTH_STAGE-1 -: WIDTH_STAGE];
            addb_pipe[i] <= addb[(i+1)*WIDTH_STAGE-1 -: WIDTH_STAGE];
            en_pipe[i] <= en_pipe[i-1];
        end

        // Calculate sums and carries in pipeline stages
        // Stage 0 sum and carry
        {carry_pipe[1], sum_pipe[0]} <= adda_pipe[0] + addb_pipe[0] + carry_pipe[0];

        // For remaining stages, sum and carry depend on previous carry
        for (i = 1; i < STAGES; i = i + 1) begin
            {carry_pipe[i+1], sum_pipe[i]} <= adda_pipe[i] + addb_pipe[i] + carry_pipe[i];
        end

        // When final stage completes, assemble the full result and o_en
        o_en <= en_pipe[STAGES-1];
        if (en_pipe[STAGES-1]) begin
            result <= {carry_pipe[STAGES], sum_pipe[STAGES-1], sum_pipe[STAGES-2], sum_pipe[STAGES-3], sum_pipe[0]};
            // sum_pipe order: 0 to 3, so need to concatenate sums in ascending order
            // As the sums are each 16 bits, concatenation is done accordingly:
            // result = {carry_out, sum[3], sum[2], sum[1], sum[0]}
        end else begin
            result <= 65'd0;
        end
    end
end

endmodule