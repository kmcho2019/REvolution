module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

// Internal predictor bits for segment synchronization
reg [7:0] predictor;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;
        predictor <= 8'b0;
    end else begin
        // Process each 8-bit segment in parallel
        Q[7:0] <= {~Q[0] ^ predictor[0], Q[7:1]};
        Q[15:8] <= {~Q[8] ^ predictor[1], Q[15:9]};
        Q[23:16] <= {~Q[16] ^ predictor[2], Q[23:17]};
        Q[31:24] <= {~Q[24] ^ predictor[3], Q[31:25]};
        Q[39:32] <= {~Q[32] ^ predictor[4], Q[39:33]};
        Q[47:40] <= {~Q[40] ^ predictor[5], Q[47:41]};
        Q[55:48] <= {~Q[48] ^ predictor[6], Q[55:49]};
        Q[63:56] <= {~Q[56] ^ predictor[7], Q[63:57]};
        
        // Update predictor bits (1 when segment is about to wrap)
        predictor[0] <= &Q[7:1];  // All 1s except LSB
        predictor[1] <= &Q[15:9];
        predictor[2] <= &Q[23:17];
        predictor[3] <= &Q[31:25];
        predictor[4] <= &Q[39:33];
        predictor[5] <= &Q[47:41];
        predictor[6] <= &Q[55:49];
        predictor[7] <= &Q[63:57];
    end
end

endmodule