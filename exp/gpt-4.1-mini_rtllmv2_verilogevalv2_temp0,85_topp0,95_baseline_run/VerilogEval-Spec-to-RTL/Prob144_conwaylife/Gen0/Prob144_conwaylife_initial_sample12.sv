module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [255:0] data,
    output reg  [255:0] q
);

    // Parameters for grid size
    localparam N = 16;

    // Function to get bit at (r,c) from vector q
    // Rows are packed in 16-bit chunks: row 0 at bits [15:0], row 1 at [31:16], etc.
    function automatic bit get_cell;
        input [255:0] grid;
        input integer r;
        input integer c;
        integer rr, cc;
        integer idx;
    begin
        // wrap indices for toroidal addressing
        rr = (r + N) % N;
        cc = (c + N) % N;
        idx = rr * N + cc;
        get_cell = grid[idx];
    end
    endfunction

    integer r, c, i;
    reg [3:0] neighbors;
    reg [255:0] next_q;

    always @(posedge clk) begin
        if (load) begin
            // Load input data into q
            q <= data;
        end else begin
            // Compute next state of the grid
            for (r = 0; r < N; r = r + 1) begin
                for (c = 0; c < N; c = c + 1) begin
                    neighbors = 0;

                    // Sum all 8 neighbors with wrapping
                    neighbors = 
                        get_cell(q, r-1, c-1) +
                        get_cell(q, r-1, c  ) +
                        get_cell(q, r-1, c+1) +
                        get_cell(q, r  , c-1) +
                        get_cell(q, r  , c+1) +
                        get_cell(q, r+1, c-1) +
                        get_cell(q, r+1, c  ) +
                        get_cell(q, r+1, c+1);

                    // Apply rules:
                    // 0-1 neighbor: 0
                    // 2 neighbors: unchanged
                    // 3 neighbors: 1
                    // 4+ neighbors: 0
                    if (neighbors <= 1) begin
                        next_q[r*N + c] = 1'b0;
                    end else if (neighbors == 2) begin
                        next_q[r*N + c] = q[r*N + c];
                    end else if (neighbors == 3) begin
                        next_q[r*N + c] = 1'b1;
                    end else begin
                        next_q[r*N + c] = 1'b0;
                    end
                end
            end
            q <= next_q;
        end
    end

endmodule