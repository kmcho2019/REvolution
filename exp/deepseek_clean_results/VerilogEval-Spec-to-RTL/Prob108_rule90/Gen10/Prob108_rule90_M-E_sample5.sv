module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Pipeline registers for each segment
    reg [63:0] segment [0:7];
    wire [63:0] next_segment [0:7];
    
    // Generate segments
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : segment_gen
            // Compute next state for each segment
            assign next_segment[i] = 
                (i == 0 ? {1'b0, segment[i][63:1]} : {segment[i-1][0], segment[i][63:1]}) ^
                (i == 7 ? {segment[i][62:0], 1'b0} : {segment[i][62:0], segment[i+1][63]});
            
            // Update segment on clock edge
            always @(posedge clk) begin
                if (load) begin
                    segment[i] <= data[i*64 +: 64];
                end else begin
                    segment[i] <= next_segment[i];
                end
            end
        end
    endgenerate
    
    // Combine segments into output
    always @(*) begin
        q = {segment[7], segment[6], segment[5], segment[4], 
             segment[3], segment[2], segment[1], segment[0]};
    end

endmodule