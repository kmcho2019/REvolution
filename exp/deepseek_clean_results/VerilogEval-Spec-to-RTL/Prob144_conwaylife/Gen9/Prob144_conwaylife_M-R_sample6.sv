module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Current state register
    reg [255:0] current_state;
    
    // Next state computation
    wire [255:0] next_state;
    
    // Neighbor counting for each cell
    genvar i;
    generate
        for (i = 0; i < 256; i = i + 1) begin : cell_update
            // Calculate row and column indices
            wire [7:0] row = i / 16;
            wire [7:0] col = i % 16;
            
            // Get all 8 neighbors with toroidal wrapping
            wire [7:0] neighbors = {
                current_state[((row-1) & 15)*16 + ((col-1) & 15)],  // top-left
                current_state[((row-1) & 15)*16 + col],              // top
                current_state[((row-1) & 15)*16 + ((col+1) & 15)],  // top-right
                current_state[row*16 + ((col-1) & 15)],              // left
                current_state[row*16 + ((col+1) & 15)],              // right
                current_state[((row+1) & 15)*16 + ((col-1) & 15)],  // bottom-left
                current_state[((row+1) & 15)*16 + col],              // bottom
                current_state[((row+1) & 15)*16 + ((col+1) & 15)]   // bottom-right
            };
            
            // Count live neighbors
            wire [3:0] neighbor_count;
            assign neighbor_count = neighbors[0] + neighbors[1] + neighbors[2] + 
                                   neighbors[3] + neighbors[4] + 
                                   neighbors[5] + neighbors[6] + neighbors[7];
            
            // Game rules implementation
            assign next_state[i] = (neighbor_count == 3) ? 1'b1 :
                                  (neighbor_count == 2) ? current_state[i] :
                                  1'b0;
        end
    endgenerate

    // State update logic
    always @(posedge clk) begin
        if (load) begin
            current_state <= data;
        end else begin
            current_state <= next_state;
        end
    end

    // Output assignment
    always @(*) begin
        q = current_state;
    end

endmodule