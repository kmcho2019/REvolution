module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Pre-compute neighbor indices for each cell
    wire [7:0][7:0] neighbor_indices [0:255];
    
    genvar i, j, n;
    generate
        for (i = 0; i < 16; i = i + 1) begin : row_gen
            for (j = 0; j < 16; j = j + 1) begin : col_gen
                // Calculate all 8 neighbor positions with toroidal wrapping
                localparam idx = i*16 + j;
                
                // Neighbor 0: top-left
                assign neighbor_indices[idx][0] = ((i+15)%16)*16 + ((j+15)%16);
                // Neighbor 1: top
                assign neighbor_indices[idx][1] = ((i+15)%16)*16 + j;
                // Neighbor 2: top-right
                assign neighbor_indices[idx][2] = ((i+15)%16)*16 + ((j+1)%16);
                // Neighbor 3: left
                assign neighbor_indices[idx][3] = i*16 + ((j+15)%16);
                // Neighbor 4: right
                assign neighbor_indices[idx][4] = i*16 + ((j+1)%16);
                // Neighbor 5: bottom-left
                assign neighbor_indices[idx][5] = ((i+1)%16)*16 + ((j+15)%16);
                // Neighbor 6: bottom
                assign neighbor_indices[idx][6] = ((i+1)%16)*16 + j;
                // Neighbor 7: bottom-right
                assign neighbor_indices[idx][7] = ((i+1)%16)*16 + ((j+1)%16);
            end
        end
    endgenerate

    // Next state logic
    wire [255:0] next_q;
    generate
        for (i = 0; i < 256; i = i + 1) begin : cell_logic
            // Count live neighbors
            wire [3:0] neighbor_count;
            assign neighbor_count = 
                q[neighbor_indices[i][0]] + q[neighbor_indices[i][1]] +
                q[neighbor_indices[i][2]] + q[neighbor_indices[i][3]] +
                q[neighbor_indices[i][4]] + q[neighbor_indices[i][5]] +
                q[neighbor_indices[i][6]] + q[neighbor_indices[i][7]];
            
            // Apply game rules
            assign next_q[i] = (neighbor_count == 3) ? 1'b1 :
                              (neighbor_count == 2) ? q[i] :
                              1'b0;
        end
    endgenerate

    // State update
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule