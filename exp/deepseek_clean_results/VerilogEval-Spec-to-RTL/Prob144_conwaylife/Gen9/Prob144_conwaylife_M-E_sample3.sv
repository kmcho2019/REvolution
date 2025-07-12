module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Processing Element (PE) for each cell
    genvar i, j;
    generate
        for (i = 0; i < 16; i = i + 1) begin : row_gen
            for (j = 0; j < 16; j = j + 1) begin : col_gen
                // Current cell state
                reg cell_state;
                
                // Neighbor positions (pre-computed with wrap-around)
                wire [7:0] neighbors = {
                    q[((i-1)&15)*16 + ((j-1)&15)],  // top-left
                    q[((i-1)&15)*16 + j],           // top
                    q[((i-1)&15)*16 + ((j+1)&15)],  // top-right
                    q[i*16 + ((j-1)&15)],           // left
                    q[i*16 + ((j+1)&15)],           // right
                    q[((i+1)&15)*16 + ((j-1)&15)],  // bottom-left
                    q[((i+1)&15)*16 + j],           // bottom
                    q[((i+1)&15)*16 + ((j+1)&15)]   // bottom-right
                };
                
                // Population count of neighbors
                wire [3:0] neighbor_count;
                assign neighbor_count = 
                    neighbors[0] + neighbors[1] + neighbors[2] + 
                    neighbors[3] + neighbors[4] + 
                    neighbors[5] + neighbors[6] + neighbors[7];
                
                // Next state logic
                wire next_state;
                assign next_state = 
                    (neighbor_count == 3) ? 1'b1 :
                    (neighbor_count == 2) ? cell_state : 1'b0;
                
                // Update logic
                always @(posedge clk) begin
                    if (load) begin
                        cell_state <= data[i*16 + j];
                    end else begin
                        cell_state <= next_state;
                    end
                end
                
                // Output connection
                always @(*) begin
                    q[i*16 + j] = cell_state;
                end
            end
        end
    endgenerate

endmodule