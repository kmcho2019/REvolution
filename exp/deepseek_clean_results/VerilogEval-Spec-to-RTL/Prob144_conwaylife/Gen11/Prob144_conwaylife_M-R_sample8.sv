module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Function to calculate next state for a single cell
    function automatic next_cell_state;
        input [255:0] grid;
        input [7:0] index;
        reg [3:0] row, col;
        reg [3:0] row_p, row_n, col_p, col_n;
        reg [7:0] neighbors;
        reg [3:0] count;
    begin
        row = index / 16;
        col = index % 16;
        
        // Calculate wrapped neighbor positions
        row_p = (row == 0) ? 15 : (row - 1);
        row_n = (row == 15) ? 0 : (row + 1);
        col_p = (col == 0) ? 15 : (col - 1);
        col_n = (col == 15) ? 0 : (col + 1);
        
        // Get all 8 neighbors
        neighbors[0] = grid[row_p*16 + col_p]; // top-left
        neighbors[1] = grid[row_p*16 + col];    // top
        neighbors[2] = grid[row_p*16 + col_n]; // top-right
        neighbors[3] = grid[row*16 + col_p];   // left
        neighbors[4] = grid[row*16 + col_n];    // right
        neighbors[5] = grid[row_n*16 + col_p]; // bottom-left
        neighbors[6] = grid[row_n*16 + col];    // bottom
        neighbors[7] = grid[row_n*16 + col_n]; // bottom-right
        
        // Count live neighbors
        count = neighbors[0] + neighbors[1] + neighbors[2] +
                neighbors[3] + neighbors[4] +
                neighbors[5] + neighbors[6] + neighbors[7];
        
        // Determine next state
        next_cell_state = (count == 3) ? 1'b1 :
                         (count == 2) ? grid[index] :
                         1'b0;
    end
    endfunction

    // Calculate next state for all cells
    wire [255:0] next_q;
    generate
        genvar i;
        for (i = 0; i < 256; i = i + 1) begin : next_state
            assign next_q[i] = next_cell_state(q, i);
        end
    endgenerate

    // Sequential update
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule