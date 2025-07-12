module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Parameters for grid dimensions
    localparam WIDTH = 16;
    localparam HEIGHT = 16;

    // Function to convert (row,col) to bit index in q and data
    function [7:0] idx;
        input [3:0] row;
        input [3:0] col;
        begin
            idx = row * WIDTH + col;
        end
    endfunction

    // Wrap function for toroidal addressing
    function [3:0] wrap;
        input signed [4:0] val;
        begin
            if (val < 0)
                wrap = val + WIDTH;
            else if (val >= WIDTH)
                wrap = val - WIDTH;
            else
                wrap = val[3:0];
        end
    endfunction

    integer r, c;

    // Next state register
    reg [255:0] next_q;

    // Temporary variables for neighbor counting
    reg [3:0] nr, nc; // wrapped neighbor row/col
    reg [3:0] count;  // neighbors count for a cell
    reg current_cell;

    always @* begin
        // Default assignment
        next_q = 256'd0;

        // Compute next state for each cell
        for (r = 0; r < HEIGHT; r = r + 1) begin
            for (c = 0; c < WIDTH; c = c + 1) begin
                count = 0;

                // Count neighbors (8 neighbors)
                // row offsets: -1, 0, 1
                // col offsets: -1, 0, 1
                // skip (0,0)
                // Use signed arithmetic for offsets to handle wrap function
                integer dr, dc;
                for (dr = -1; dr <= 1; dr = dr + 1) begin
                    for (dc = -1; dc <= 1; dc = dc + 1) begin
                        if (!(dr == 0 && dc == 0)) begin
                            nr = wrap(r + dr);
                            nc = wrap(c + dc);
                            count = count + q[idx(nr,nc)];
                        end
                    end
                end

                current_cell = q[idx(r,c)];

                // Apply rules
                // (1) 0-1 neighbor -> 0
                // (2) 2 neighbors -> same as current cell
                // (3) 3 neighbors -> 1
                // (4) 4+ neighbors -> 0
                if (count == 2)
                    next_q[idx(r,c)] = current_cell;
                else if (count == 3)
                    next_q[idx(r,c)] = 1'b1;
                else
                    next_q[idx(r,c)] = 1'b0;
            end
        end
    end

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule