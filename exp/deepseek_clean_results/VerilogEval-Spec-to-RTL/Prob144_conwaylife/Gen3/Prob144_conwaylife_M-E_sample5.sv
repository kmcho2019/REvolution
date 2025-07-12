module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Shift registers for neighbor propagation
    reg [255:0] q_prev, q_current, q_next;
    reg [255:0] left_neighbors, right_neighbors;
    
    // Processing elements for each column
    wire [255:0] next_state;
    
    // Generate processing elements for each column
    genvar col;
    generate
        for (col = 0; col < 16; col = col + 1) begin : pe_gen
            // Calculate neighbor counts with wrap-around
            wire [3:0] neighbor_count;
            
            // Left column (wrap around to right side)
            wire left_col = (col == 0) ? 15 : (col - 1);
            // Right column (wrap around to left side)
            wire right_col = (col == 15) ? 0 : (col + 1);
            
            // Extract relevant bits from shift registers
            wire [15:0] top_row = q_prev[(col*16)+:16];
            wire [15:0] mid_row = q_current[(col*16)+:16];
            wire [15:0] bottom_row = q_next[(col*16)+:16];
            
            wire [15:0] left_col_bits = left_neighbors[(col*16)+:16];
            wire [15:0] right_col_bits = right_neighbors[(col*16)+:16];
            
            // Neighbor count calculation
            assign neighbor_count = 
                top_row[15] + top_row[0] + top_row[1] +  // top neighbors
                mid_row[15] + mid_row[1] +               // side neighbors
                bottom_row[15] + bottom_row[0] + bottom_row[1]; // bottom neighbors
            
            // Game rules application
            assign next_state[(col*16)+:16] = 
                (neighbor_count == 2) ? mid_row :
                (neighbor_count == 3) ? 16'hFFFF : 
                16'h0000;
        end
    endgenerate
    
    // Sequential logic
    always @(posedge clk) begin
        if (load) begin
            q <= data;
            q_prev <= {data[15:0], data[255:16]}; // previous row (wrapped)
            q_current <= data;
            q_next <= {data[239:0], data[255:240]}; // next row (wrapped)
            left_neighbors <= {data[15:0], data[255:16]}; // left column neighbors
            right_neighbors <= {data[239:0], data[255:240]}; // right column neighbors
        end else begin
            q <= next_state;
            
            // Update shift registers
            q_prev <= q_current;
            q_current <= q_next;
            q_next <= {next_state[239:0], next_state[255:240]};
            
            // Update column neighbors
            left_neighbors <= {next_state[15:0], next_state[255:16]};
            right_neighbors <= {next_state[239:0], next_state[255:240]};
        end
    end

endmodule