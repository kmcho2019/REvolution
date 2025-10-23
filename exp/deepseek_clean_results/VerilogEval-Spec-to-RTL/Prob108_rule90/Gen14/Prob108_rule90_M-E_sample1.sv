module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Divide into 64 segments of 8 bits each
    wire [7:0] segments [63:0];
    wire [7:0] next_segments [63:0];
    
    // Connect segments to q
    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : segment_conn
            assign segments[i] = q[(i*8)+7 : i*8];
        end
    endgenerate
    
    // Compute next state for each segment
    generate
        for (i = 0; i < 64; i = i + 1) begin : rule90
            // Get left and right neighbor bits
            wire left_bit = (i == 0) ? 1'b0 : segments[i-1][0];
            wire right_bit = (i == 63) ? 1'b0 : segments[i+1][7];
            
            // Compute next state for this segment
            always @(*) begin
                next_segments[i][0] = left_bit ^ segments[i][1];
                next_segments[i][7] = segments[i][6] ^ right_bit;
                
                for (int j = 1; j < 7; j = j + 1) begin
                    next_segments[i][j] = segments[i][j-1] ^ segments[i][j+1];
                end
            end
        end
    endgenerate
    
    // Update state
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Combine all segments
            for (int i = 0; i < 64; i = i + 1) begin
                q[(i*8)+7 : i*8] <= next_segments[i];
            end
        end
    end

endmodule