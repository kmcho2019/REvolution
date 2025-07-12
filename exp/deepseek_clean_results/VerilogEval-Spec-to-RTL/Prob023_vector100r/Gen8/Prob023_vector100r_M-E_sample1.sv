module TopModule (
    input  [99:0] in,
    output [99:0] out
);

// Parameterized logarithmic bit reversal
parameter WIDTH = 100;
parameter STAGES = $clog2(WIDTH);

genvar stage;
generate
    for (stage = 0; stage < STAGES; stage = stage + 1) begin : reverse_stages
        localparam BLOCK_SIZE = 1 << stage;
        wire [WIDTH-1:0] stage_out;
        
        if (stage == 0) begin
            // First stage: swap adjacent bits
            for (genvar i = 0; i < WIDTH; i = i + 2) begin : swap_pairs
                if (i+1 < WIDTH) begin
                    assign stage_out[i] = in[i+1];
                    assign stage_out[i+1] = in[i];
                end else begin
                    assign stage_out[i] = in[i];
                end
            end
        end else begin
            // Subsequent stages: swap blocks
            for (genvar j = 0; j < WIDTH; j = j + (2*BLOCK_SIZE)) begin : swap_blocks
                for (genvar k = 0; k < BLOCK_SIZE; k = k + 1) begin : block_bits
                    if (j + BLOCK_SIZE + k < WIDTH) begin
                        assign stage_out[j + k] = reverse_stages[stage-1].stage_out[j + BLOCK_SIZE + k];
                        assign stage_out[j + BLOCK_SIZE + k] = reverse_stages[stage-1].stage_out[j + k];
                    end else if (j + k < WIDTH) begin
                        assign stage_out[j + k] = reverse_stages[stage-1].stage_out[j + k];
                    end
                end
            end
        end
    end
endgenerate

assign out = reverse_stages[STAGES-1].stage_out;

endmodule