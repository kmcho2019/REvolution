module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // 2D array representation of the grid
    wire [15:0] grid [0:15];
    
    // Convert between flat and 2D representations
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin
            assign grid[i] = q[i*16 +: 16];
        end
    endgenerate

    // Function to count neighbors with toroidal wrapping
    function [3:0] count_neighbors;
        input [3:0] row, col;
        reg [3:0] r_prev, r_next, c_prev, c_next;
        begin
            // Calculate wrapped indices
            r_prev = (row - 1) & 15;
            r_next = (row + 1) & 15;
            c_prev = (col - 1) & 15;
            c_next = (col + 1) & 15;
            
            // Count neighbors (using shift instead of multiply)
            count_neighbors = 
                grid[r_prev][c_prev] + grid[r_prev][col] + grid[r_prev][c_next] +
                grid[row][c_prev] + grid[row][c_next] +
                grid[r_next][c_prev] + grid[r_next][col] + grid[r_next][c_next];
        end
    endfunction

    // Next state calculation
    wire [255:0] next_q;
    genvar r, c;
    generate
        for (r = 0; r < 16; r = r + 1) begin : row
            for (c = 0; c < 16; c = c + 1) begin : col
                wire [3:0] neighbors = count_neighbors(r[3:0], c[3:0]);
                assign next_q[r*16 + c] = (neighbors == 3) ? 1'b1 :
                                        (neighbors == 2) ? grid[r][c] :
                                        1'b0;
            end
        end
    endgenerate

    // Sequential update
    always @(posedge clk) begin
        q <= load ? data : next_q;
    end

endmodule