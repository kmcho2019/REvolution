module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Parameters for grid size
    localparam N = 16;

    // Convert q into 2D array for easier indexing
    // We'll create combinational logic to compute next state

    integer r, c;

    // Function to get bit at (row,col) with wrap-around
    function automatic bit get_cell(input [255:0] grid, input integer row, input integer col);
        integer rr, cc;
    begin
        rr = (row + N) % N;
        cc = (col + N) % N;
        // Each row is 16 bits: bits [16*row + 15 : 16*row]
        get_cell = grid[rr*16 + cc];
    end
    endfunction

    reg [255:0] next_q;

    always @* begin
        // Compute next_q based on q
        for (r = 0; r < N; r = r + 1) begin
            for (c = 0; c < N; c = c + 1) begin
                // sum neighbors (8 neighbors)
                integer ncount;
                ncount = 0;

                // neighbors positions relative to (r,c)
                // offsets: (-1,-1), (-1,0), (-1,1), (0,-1), (0,1), (1,-1), (1,0), (1,1)
                ncount = 
                    get_cell(q, r-1, c-1) +
                    get_cell(q, r-1, c  ) +
                    get_cell(q, r-1, c+1) +
                    get_cell(q, r  , c-1) +
                    get_cell(q, r  , c+1) +
                    get_cell(q, r+1, c-1) +
                    get_cell(q, r+1, c  ) +
                    get_cell(q, r+1, c+1);

                bit current = get_cell(q, r, c);
                bit next_state;

                // Apply rules
                if (ncount <= 1)
                    next_state = 1'b0;
                else if (ncount == 2)
                    next_state = current;
                else if (ncount == 3)
                    next_state = 1'b1;
                else // ncount >= 4
                    next_state = 1'b0;

                next_q[r*16 + c] = next_state;
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