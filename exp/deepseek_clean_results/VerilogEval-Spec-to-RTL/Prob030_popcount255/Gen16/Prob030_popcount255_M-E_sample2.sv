module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // Stage 0: Create initial count array (255 numbers of 0 or 1)
    wire [0:0] stage0 [0:254];
    genvar i;
    generate
        for (i = 0; i < 255; i = i + 1) begin : init
            assign stage0[i] = in[i];
        end
    endgenerate

    // Parallel prefix sum stages
    parameter STAGES = 8; // log2(256)
    wire [7:0] prefix_sum [0:254];
    
    generate
        // Initialize first stage
        for (i = 0; i < 255; i = i + 1) begin : stage_init
            assign prefix_sum[i][0:0] = stage0[i];
            assign prefix_sum[i][7:1] = 7'b0;
        end

        // Build prefix sum network
        for (genvar s = 0; s < STAGES; s = s + 1) begin : prefix_stages
            for (i = 0; i < 255; i = i + 1) begin : prefix_update
                if (i >= (1 << s)) begin
                    // Current bit width needed (grows as log2(stage))
                    localparam WIDTH = (s < 3) ? s+2 : 8;
                    wire [WIDTH-1:0] sum;
                    assign sum = prefix_sum[i][WIDTH-1:0] + 
                                prefix_sum[i - (1 << s)][WIDTH-1:0];
                    assign prefix_sum[i][WIDTH-1:0] = sum;
                end
            end
        end
    endgenerate

    // Final result is the last element in the prefix sum
    assign out = prefix_sum[254][7:0];

endmodule