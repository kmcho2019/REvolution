module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Helper function to get the value of a cell at (row, col) from a 256-bit vector
    // row and col are 4-bit indices (0 to 15)
    function automatic bit get_cell(input [255:0] grid, input [3:0] row, input [3:0] col);
        begin
            // Compute bit position:
            // row 0: bits [15:0], bit offset = row*16 + col
            // Least significant bit in each 16-bit segment corresponds to column 0
            get_cell = grid[row*16 + col];
        end
    endfunction

    integer r, c;
    reg [255:0] next_state;

    // Wrap around helper: returns value in [0..15]
    function automatic [3:0] wrap(input integer x);
        begin
            // wrap mod 16
            if (x < 0)
                wrap = x + 16;
            else if (x >= 16)
                wrap = x - 16;
            else
                wrap = x[3:0];
        end
    endfunction

    // Count alive neighbors for cell at (r,c)
    function automatic [3:0] count_neighbors(input [255:0] grid, input integer rr, input integer cc);
        integer rrn, ccn;
        integer nr, nc;
        reg [3:0] sum;
        begin
            sum = 0;
            for (nr = -1; nr <= 1; nr = nr + 1) begin
                for (nc = -1; nc <= 1; nc = nc + 1) begin
                    if (!(nr == 0 && nc == 0)) begin
                        rrn = wrap(rr + nr);
                        ccn = wrap(cc + nc);
                        sum = sum + get_cell(grid, rrn[3:0], ccn[3:0]);
                    end
                end
            end
            count_neighbors = sum;
        end
    endfunction

    always @(posedge clk) begin
        if (load) begin
            // Load input data directly
            q <= data;
        end else begin
            // Compute next state
            for (r = 0; r < 16; r = r + 1) begin
                for (c = 0; c < 16; c = c + 1) begin
                    reg current_cell;
                    reg [3:0] neighbors;
                    current_cell = get_cell(q, r[3:0], c[3:0]);
                    neighbors = count_neighbors(q, r, c);
                    // Apply rules
                    // (1) 0-1 neighbor: cell -> 0
                    // (2) 2 neighbors: cell unchanged
                    // (3) 3 neighbors: cell -> 1
                    // (4) 4+ neighbors: cell -> 0
                    if (neighbors <= 1)
                        next_state[r*16 + c] = 1'b0;
                    else if (neighbors == 2)
                        next_state[r*16 + c] = current_cell;
                    else if (neighbors == 3)
                        next_state[r*16 + c] = 1'b1;
                    else
                        next_state[r*16 + c] = 1'b0;
                end
            end
            q <= next_state;
        end
    end

endmodule