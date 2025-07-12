module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

// Pipeline registers
reg [63:0] Q_pipe;
reg next_msb;

// State prediction logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        next_msb <= 1'b0;
    end else begin
        // Predict next MSB one cycle early
        next_msb <= (Q_pipe[0] ^ next_msb) ? ~next_msb : next_msb;
    end
end

// Main pipeline stage
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;
        Q_pipe <= 64'b0;
    end else begin
        // First pipeline stage: upper 32-bit shift
        Q_pipe[63:32] <= {next_msb, Q_pipe[63:33]};
        
        // Second pipeline stage: lower 32-bit shift and output
        Q_pipe[31:0] <= Q_pipe[32:1];
        Q <= Q_pipe;
    end
end

// synthesis attribute async_reg of Q is "true";
// synthesis attribute shreg_extract of Q_pipe is "no";
// synthesis attribute use_dsp48 of next_msb is "no";

endmodule