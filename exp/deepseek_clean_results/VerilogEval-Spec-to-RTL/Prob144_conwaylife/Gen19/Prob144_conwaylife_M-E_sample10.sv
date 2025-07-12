module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Pre-compute neighbor masks for each row
    wire [15:0] row_prev [15:0];
    wire [15:0] row_curr [15:0];
    wire [15:0] row_next [15:0];
    
    // Connect rows with wrap-around
    generate
        for (genvar i = 0; i < 16; i = i + 1) begin : row_connections
            assign row_prev[i] = (i == 0) ? q[255:240] : q[(i-1)*16 +: 16];
            assign row_curr[i] = q[i*16 +: 16];
            assign row_next[i] = (i == 15) ? q[15:0] : q[(i+1)*16 +: 16];
        end
    endgenerate

    // Process each cell in parallel
    wire [255:0] next_q;
    generate
        for (genvar i = 0; i < 16; i = i + 1) begin : row_processing
            for (genvar j = 0; j < 16; j = j + 1) begin : col_processing
                // Create 3x3 neighborhood window with wrap-around
                wire [8:0] neighborhood;
                assign neighborhood[8] = row_prev[i][(j+15)%16]; // top-left
                assign neighborhood[7] = row_prev[i][j];         // top
                assign neighborhood[6] = row_prev[i][(j+1)%16];  // top-right
                assign neighborhood[5] = row_curr[i][(j+15)%16]; // left
                assign neighborhood[4] = row_curr[i][j];         // center (current cell)
                assign neighborhood[3] = row_curr[i][(j+1)%16];  // right
                assign neighborhood[2] = row_next[i][(j+15)%16]; // bottom-left
                assign neighborhood[1] = row_next[i][j];         // bottom
                assign neighborhood[0] = row_next[i][(j+1)%16];   // bottom-right

                // Count live neighbors (excluding self)
                wire [3:0] neighbor_count;
                assign neighbor_count = 
                    neighborhood[8] + neighborhood[7] + neighborhood[6] +
                    neighborhood[5] + neighborhood[3] +
                    neighborhood[2] + neighborhood[1] + neighborhood[0];

                // Compute next state
                assign next_q[i*16 + j] = 
                    (neighbor_count == 3) ? 1'b1 :
                    (neighbor_count == 2) ? q[i*16 + j] :
                    1'b0;
            end
        end
    endgenerate

    // Update state on clock edge
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule