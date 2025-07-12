module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Circular boundary implementation
    reg [513:0] extended_state;  // q[-1] and q[512] are stored as [0] and [513]

    // Pipelined computation stages
    reg [63:0] stage1 [0:7];
    reg [63:0] stage2 [0:7];
    reg [63:0] next_state;

    integer i, j;

    always @(posedge clk) begin
        if (load) begin
            extended_state <= {1'b0, data, 1'b0};
        end else begin
            // Pipeline Stage 1: Compute left/center/right for chunks
            for (i = 0; i < 8; i = i + 1) begin
                for (j = 0; j < 64; j = j + 1) begin
                    stage1[i][j] <= (extended_state[(i*64)+j+1] ^ extended_state[(i*64)+j+2]) | 
                                   (~extended_state[(i*64)+j] & (extended_state[(i*64)+j+1] | extended_state[(i*64)+j+2]));
                end
            end

            // Pipeline Stage 2: Combine results
            for (i = 0; i < 8; i = i + 1) begin
                stage2[i] <= stage1[i];
            end

            // Final output assembly
            for (i = 0; i < 8; i = i + 1) begin
                next_state[(i*64)+:64] <= stage2[i];
            end

            // Update state with circular boundary
            extended_state <= {next_state[511], next_state, next_state[0]};
        end
    end

    assign q = extended_state[512:1];

endmodule