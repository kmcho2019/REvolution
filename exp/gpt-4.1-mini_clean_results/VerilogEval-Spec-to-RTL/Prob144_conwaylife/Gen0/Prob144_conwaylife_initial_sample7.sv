module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);
    // 16x16 grid: rows 0-15, cols 0-15
    // q[15:0] is row 0, q[31:16] row 1, ..., q[255:240] row 15
    
    // To calculate neighbors, we use modular wrapping:
    // row_up = (row + 15) % 16
    // row_down = (row + 1) % 16
    // col_left = (col + 15) % 16
    // col_right = (col + 1) % 16
    
    integer row, col;
    
    reg [255:0] next_state;
    
    // Helper function to get cell state from q by row and col
    function get_cell;
        input [255:0] grid;
        input [3:0] r;
        input [3:0] c;
        begin
            get_cell = grid[r*16 + c];
        end
    endfunction

    always @(*) begin
        for (row = 0; row < 16; row = row + 1) begin
            for (col = 0; col < 16; col = col + 1) begin
                // Calculate neighbors with toroidal wrap
                // row indices
                integer r_up = (row + 15) & 4'hF;   // modulo 16 via mask
                integer r_down = (row + 1) & 4'hF;
                // col indices
                integer c_left = (col + 15) & 4'hF;
                integer c_right = (col + 1) & 4'hF;
                
                // Sum 8 neighbors
                integer sum_neighbors;
                sum_neighbors = 0;
                sum_neighbors = sum_neighbors +
                    get_cell(q, r_up, c_left) +
                    get_cell(q, r_up, col) +
                    get_cell(q, r_up, c_right) +
                    get_cell(q, row, c_left) +
                    get_cell(q, row, c_right) +
                    get_cell(q, r_down, c_left) +
                    get_cell(q, r_down, col) +
                    get_cell(q, r_down, c_right);
                
                // Current cell state
                reg curr;
                curr = get_cell(q, row, col);
                
                // Apply rules:
                // (1) neighbors 0-1: cell=0
                // (2) neighbors 2: cell stays
                // (3) neighbors 3: cell=1
                // (4) neighbors 4+: cell=0
                if (sum_neighbors <= 1)
                    next_state[row*16 + col] = 1'b0;
                else if (sum_neighbors == 2)
                    next_state[row*16 + col] = curr;
                else if (sum_neighbors == 3)
                    next_state[row*16 + col] = 1'b1;
                else
                    next_state[row*16 + col] = 1'b0;
            end
        end
    end
    
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_state;
        end
    end
    
endmodule