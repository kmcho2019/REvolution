module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Systolic array registers for neighbor propagation
    reg [255:0] north_buf, south_buf;
    reg [15:0] west_buf [0:15], east_buf [0:15];
    reg [15:0] nw_buf [0:15], ne_buf [0:15], sw_buf [0:15], se_buf [0:15];

    // Next state calculation
    wire [255:0] next_q;
    
    genvar row, col;
    generate
        for (row = 0; row < 16; row = row + 1) begin : row_loop
            for (col = 0; col < 16; col = col + 1) begin : col_loop
                // Current cell and its neighbors from systolic buffers
                wire self = q[row*16 + col];
                wire north = north_buf[row*16 + col];
                wire south = south_buf[row*16 + col];
                wire west = west_buf[row][col];
                wire east = east_buf[row][col];
                wire nw = nw_buf[row][col];
                wire ne = ne_buf[row][col];
                wire sw = sw_buf[row][col];
                wire se = se_buf[row][col];
                
                // Neighbor count
                wire [3:0] neighbor_count = north + south + west + east + 
                                          nw + ne + sw + se;
                
                // Next state logic
                assign next_q[row*16 + col] = 
                    (neighbor_count == 3) ? 1'b1 :
                    (neighbor_count == 2) ? self : 1'b0;
            end
        end
    endgenerate

    always @(posedge clk) begin
        if (load) begin
            q <= data;
            // Initialize buffers with loaded data
            north_buf <= {data[239:0], data[255:240]}; // Rotate up
            south_buf <= {data[15:0], data[255:16]};   // Rotate down
            
            for (integer r = 0; r < 16; r = r + 1) begin
                west_buf[r] <= {q[r*16 + 0], q[r*16 + 15:1]};  // Rotate left
                east_buf[r] <= {q[r*16 + 14:0], q[r*16 + 15]}; // Rotate right
                
                // Diagonal buffers
                nw_buf[r] <= {q[((r+15)%16)*16 + 0], q[((r+15)%16)*16 + 15:1]};
                ne_buf[r] <= {q[((r+15)%16)*16 + 14:0], q[((r+15)%16)*16 + 15]};
                sw_buf[r] <= {q[((r+1)%16)*16 + 0], q[((r+1)%16)*16 + 15:1]};
                se_buf[r] <= {q[((r+1)%16)*16 + 14:0], q[((r+1)%16)*16 + 15]};
            end
        end else begin
            q <= next_q;
            
            // Update systolic buffers
            north_buf <= {q[239:0], q[255:240]}; // Rotate up
            south_buf <= {q[15:0], q[255:16]};   // Rotate down
            
            for (integer r = 0; r < 16; r = r + 1) begin
                west_buf[r] <= {q[r*16 + 0], q[r*16 + 15:1]};  // Rotate left
                east_buf[r] <= {q[r*16 + 14:0], q[r*16 + 15]}; // Rotate right
                
                // Diagonal buffers
                nw_buf[r] <= {q[((r+15)%16)*16 + 0], q[((r+15)%16)*16 + 15:1]};
                ne_buf[r] <= {q[((r+15)%16)*16 + 14:0], q[((r+15)%16)*16 + 15]};
                sw_buf[r] <= {q[((r+1)%16)*16 + 0], q[((r+1)%16)*16 + 15:1]};
                se_buf[r] <= {q[((r+1)%16)*16 + 14:0], q[((r+1)%16)*16 + 15]};
            end
        end
    end

endmodule