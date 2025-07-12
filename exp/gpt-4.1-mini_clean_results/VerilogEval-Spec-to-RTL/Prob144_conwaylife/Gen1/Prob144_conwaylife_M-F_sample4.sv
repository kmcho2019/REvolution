module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);
    // 16x16 grid: rows 0-15, cols 0-15
    // q[15:0] is row 0, q[31:16] row 1, ..., q[255:240] row 15
    
    // Loop indices and temporary variables declared here:
    integer row, col;
    integer r_up, r_down, c_left, c_right;
    integer sum_neighbors;
    reg curr;
    
    // Helper function to get cell state from q by row and col
    function get_cell;
        input [255:0] grid;
        input [3:0] r;
        input [3:0] c;
        begin
            get_cell = grid[r*16 + c];
        end
    endfunction

    reg [255:0] next_state;

    always @(*) begin
        for (row = 0; row < 16; row = row + 1) begin
            for (col = 0; col < 16; col = col + 1) begin
                // Calculate neighbors with toroidal wrap using modulo 16 mask
                r_up = (row + 15) & 4'hF;    // (row - 1) mod 16
                r_down = (row + 1) & 4'hF;   // (row + 1) mod 16
                c_left = (col + 15) & 4'hF;  // (col - 1) mod 16
                c_right = (col + 1) & 4'hF;  // (col + 1) mod 16
                
                // Sum 8 neighbors
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