module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Pipeline registers
    reg [511:0] stage1_q;
    reg [511:0] stage2_q;
    
    // Segment processing
    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin: segment
            // Stage 1: Compute segment neighbors
            wire [7:0] left_segment = (i == 0) ? 8'b0 : q[(i*8)-1 -:8];
            wire [7:0] right_segment = (i == 63) ? 8'b0 : q[(i*8)+8 +:8];
            
            // Stage 1: Compute XOR for each bit in segment
            wire [7:0] segment_xor = left_segment ^ right_segment;
            
            // Pipeline stage 1
            always @(posedge clk) begin
                if (load) begin
                    stage1_q[i*8 +:8] <= data[i*8 +:8];
                end else begin
                    stage1_q[i*8 +:8] <= segment_xor;
                end
            end
            
            // Pipeline stage 2 (final output)
            always @(posedge clk) begin
                q[i*8 +:8] <= stage1_q[i*8 +:8];
            end
        end
    endgenerate

endmodule