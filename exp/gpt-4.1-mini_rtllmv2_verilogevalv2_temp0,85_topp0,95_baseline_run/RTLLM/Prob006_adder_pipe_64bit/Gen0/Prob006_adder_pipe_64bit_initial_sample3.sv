module adder_pipe_64bit (
    input              clk,
    input              rst_n,
    input              i_en,
    input      [63:0]  adda,
    input      [63:0]  addb,
    output reg [64:0]  result,
    output reg         o_en
);

// Parameters
localparam STAGE_NUM = 8;
localparam STAGE_WIDTH = 8;

// Internal signals
reg [STAGE_WIDTH-1:0] stage_a   [0:STAGE_NUM-1];
reg [STAGE_WIDTH-1:0] stage_b   [0:STAGE_NUM-1];
reg                   stage_en  [0:STAGE_NUM-1];
reg                   carry     [0:STAGE_NUM]; // carry[0] is initial carry_in = 0
reg [STAGE_WIDTH-1:0] sum       [0:STAGE_NUM-1];

// Initialize carry[0] to zero
// We use generate loops to implement pipeline stages

integer i;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all pipeline registers
        for (i = 0; i < STAGE_NUM; i = i + 1) begin
            stage_a[i]  <= 0;
            stage_b[i]  <= 0;
            stage_en[i] <= 0;
            sum[i]      <= 0;
        end
        carry[0] <= 0;
        for (i = 1; i <= STAGE_NUM; i = i + 1) begin
            carry[i] <= 0;
        end
        result <= 0;
        o_en   <= 0;
    end else begin
        // Stage 0: latch inputs and i_en, carry_in = 0
        stage_a[0]  <= adda[7:0];
        stage_b[0]  <= addb[7:0];
        stage_en[0] <= i_en;
        carry[0]    <= 1'b0; // initial carry in is zero

        // Compute sum and carry out for stage 0
        {carry[1], sum[0]} <= {1'b0, stage_a[0]} + {1'b0, stage_b[0]} + carry[0];

        // For subsequent stages 1 to 7
        for (i = 1; i < STAGE_NUM; i = i + 1) begin
            stage_a[i]  <= adda[8*i +: 8];
            stage_b[i]  <= addb[8*i +: 8];
            stage_en[i] <= stage_en[i-1]; // pipeline enable
            // compute sum and carry out for stage i
            {carry[i+1], sum[i]} <= {1'b0, stage_a[i]} + {1'b0, stage_b[i]} + carry[i];
        end

        // Output assignment
        // Wait until last stage valid
        if (stage_en[STAGE_NUM-1]) begin
            // Concatenate sums and final carry out
            result <= {carry[STAGE_NUM], sum[STAGE_NUM-1], sum[STAGE_NUM-2], sum[STAGE_NUM-3], sum[STAGE_NUM-4],
                       sum[STAGE_NUM-5], sum[STAGE_NUM-6], sum[STAGE_NUM-7], sum[0]};
            o_en <= 1'b1;
        end else begin
            o_en <= 1'b0;
            // Optional: result keeps last value or reset to zero when no valid output
            // result <= 0;
        end
    end
end

endmodule