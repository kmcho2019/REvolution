module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Ping-pong buffers for current and next state
    reg [255:0] current_state, next_state;
    
    // Column sums storage (for sharing between rows)
    reg [15:0] col_sums [15:0];
    
    // Circular buffer for row neighbor sums
    reg [15:0] row_sums [2:0];
    reg [1:0] wr_ptr = 0;
    
    always @(posedge clk) begin
        if (load) begin
            current_state <= data;
            next_state <= data;
        end else begin
            // Update state using ping-pong technique
            current_state <= next_state;
            q <= next_state;
            
            // Process each row in sequence
            for (integer row = 0; row < 16; row = row + 1) begin
                // Calculate column sums for current row
                for (integer col = 0; col < 16; col = col + 1) begin
                    // Get wrapped row indices
                    integer prev_row = (row == 0) ? 15 : (row - 1);
                    integer next_row = (row == 15) ? 0 : (row + 1);
                    
                    // Calculate column sum (top + center + bottom)
                    col_sums[col] = current_state[prev_row*16 + col] + 
                                   current_state[row*16 + col] + 
                                   current_state[next_row*16 + col];
                end
                
                // Store current row sum in circular buffer
                row_sums[wr_ptr] = current_state[row*16 +: 16];
                wr_ptr <= wr_ptr + 1;
                
                // Get wrapped row sums (previous and next rows)
                wire [15:0] prev_row_sum = row_sums[(wr_ptr + 1) % 3];
                wire [15:0] next_row_sum = row_sums[(wr_ptr + 2) % 3];
                
                // Process each column in current row
                for (integer col = 0; col < 16; col = col + 1) begin
                    // Get wrapped column indices
                    integer prev_col = (col == 0) ? 15 : (col - 1);
                    integer next_col = (col == 15) ? 0 : (col + 1);
                    
                    // Calculate neighbor count using shared sums
                    wire [3:0] neighbor_count = 
                        // Left and right neighbors from current row
                        current_state[row*16 + prev_col] + 
                        current_state[row*16 + next_col] +
                        // Top row (minus center)
                        (prev_row_sum[col] - current_state[prev_row*16 + col]) +
                        // Bottom row (minus center)
                        (next_row_sum[col] - current_state[next_row*16 + col]);
                    
                    // Update rule
                    case (neighbor_count)
                        3: next_state[row*16 + col] <= 1'b1;
                        2: next_state[row*16 + col] <= current_state[row*16 + col];
                        default: next_state[row*16 + col] <= 1'b0;
                    endcase
                end
            end
        end
    end

endmodule