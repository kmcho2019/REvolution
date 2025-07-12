module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Segment registers
    reg [15:0] segments [31:0];
    reg [15:0] segments_next [31:0];
    reg [15:0] segments_pipe [31:0];
    
    // Initialize all segments
    integer s;
    always @(posedge clk) begin
        if (load) begin
            for (s = 0; s < 32; s = s + 1) begin
                segments[s] <= data[(s*16)+15 : s*16];
            end
        end else begin
            for (s = 0; s < 32; s = s + 1) begin
                segments[s] <= segments_pipe[s];
            end
        end
    end
    
    // Pipeline stage
    always @(posedge clk) begin
        for (s = 0; s < 32; s = s + 1) begin
            segments_pipe[s] <= segments_next[s];
        end
    end
    
    // Segment computation
    genvar i, j;
    generate
        for (s = 0; s < 32; s = s + 1) begin: segment_compute
            // Compute next state for each bit in segment
            for (i = 0; i < 16; i = i + 1) begin: bit_compute
                wire left = (i == 0) ? 
                           ((s == 0) ? 1'b0 : segments[s-1][15]) : 
                           segments[s][i-1];
                wire right = (i == 15) ? 
                            ((s == 31) ? 1'b0 : segments[s+1][0]) : 
                            segments[s][i+1];
                always @(*) begin
                    segments_next[s][i] = left ^ right;
                end
            end
        end
    endgenerate
    
    // Combine segments into output
    always @(*) begin
        for (s = 0; s < 32; s = s + 1) begin
            q[(s*16)+15 : s*16] = segments[s];
        end
    end

endmodule