module multi_pipe_8bit (
    input               clk,
    input               rst_n,
    input               mul_en_in,
    input      [7:0]    mul_a,
    input      [7:0]    mul_b,
    output reg          mul_en_out,
    output reg [15:0]   mul_out
);

// Number of pipeline stages equals bit width of multiplier
localparam PIPE_STAGES = 8;

// Pipeline registers
reg [7:0]  a_pipe   [0:PIPE_STAGES];  // multiplicand registers per stage
reg [7:0]  b_pipe   [0:PIPE_STAGES];  // multiplier registers per stage
reg [15:0] sum_pipe [0:PIPE_STAGES];  // partial sum registers per stage
reg        en_pipe  [0:PIPE_STAGES];  // enable pipeline

integer i;

// Pipeline initialization on reset
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Initialize pipeline registers to zero
        mul_en_out <= 1'b0;
        mul_out <= 16'd0;
        for (i=0; i<=PIPE_STAGES; i=i+1) begin
            a_pipe[i] <= 8'd0;
            b_pipe[i] <= 8'd0;
            sum_pipe[i] <= 16'd0;
            en_pipe[i] <= 1'b0;
        end
    end else begin
        // Stage 0: load inputs when mul_en_in asserted
        if (mul_en_in) begin
            a_pipe[0] <= mul_a;
            b_pipe[0] <= mul_b;
            sum_pipe[0] <= 16'd0;
            en_pipe[0] <= 1'b1;
        end else begin
            // No new input, disable stage 0 processing
            a_pipe[0] <= 8'd0;
            b_pipe[0] <= 8'd0;
            sum_pipe[0] <= 16'd0;
            en_pipe[0] <= 1'b0;
        end

        // Pipeline stages 1 to PIPE_STAGES: process one multiplier bit per stage
        for (i = 1; i <= PIPE_STAGES; i = i + 1) begin
            a_pipe[i] <= a_pipe[i-1];
            b_pipe[i] <= b_pipe[i-1];
            en_pipe[i] <= en_pipe[i-1];
            if (en_pipe[i-1]) begin
                // Extract bit (i-1) of multiplier from previous stage
                // If set, add multiplicand shifted by (i-1) to accumulated sum
                sum_pipe[i] <= sum_pipe[i-1] + ((b_pipe[i-1][i-1]) ? ( {8'd0, a_pipe[i-1]} << (i-1) ) : 16'd0);
            end else begin
                sum_pipe[i] <= 16'd0;
            end
        end

        // Output assignment at last stage
        mul_en_out <= en_pipe[PIPE_STAGES];
        mul_out    <= en_pipe[PIPE_STAGES] ? sum_pipe[PIPE_STAGES] : 16'd0;
    end
end

endmodule