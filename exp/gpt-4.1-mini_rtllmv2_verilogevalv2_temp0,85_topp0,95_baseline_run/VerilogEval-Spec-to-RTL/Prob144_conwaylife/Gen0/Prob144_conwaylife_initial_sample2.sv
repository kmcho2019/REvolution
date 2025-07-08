module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);
    // Grid dimension
    localparam N = 16;

    // Function to wrap indices modulo N (16)
    function [3:0] wrap;
        input integer val;
        begin
            if (val < 0)
                wrap = val + N;
            else if (val >= N)
                wrap = val - N;
            else
                wrap = val;
        end
    endfunction

    integer r, c;

    reg [N-1:0] current_grid [N-1:0];  // 16 rows of 16 bits for clarity
    reg [N-1:0] next_grid [N-1:0];

    // Convert q vector to 2D grid
    always @(*) begin
        for (r = 0; r < N; r = r + 1) begin
            current_grid[r] = q[(r+1)*N-1 -: N];
        end
    end

    // Count alive neighbors for cell (r,c)
    function [3:0] count_neighbors;
        input integer rr;
        input integer cc;
        integer rrw, ccw;
        integer nr, nc;
        begin
            count_neighbors = 0;
            for (nr = rr-1; nr <= rr+1; nr = nr + 1) begin
                rrw = wrap(nr);
                for (nc = cc-1; nc <= cc+1; nc = nc + 1) begin
                    ccw = wrap(nc);
                    if (!(nr == rr && nc == cc)) begin
                        count_neighbors = count_neighbors + current_grid[rrw][ccw];
                    end
                end
            end
        end
    endfunction

    // Compute next state for all cells combinationally
    always @(*) begin
        for (r = 0; r < N; r = r + 1) begin
            for (c = 0; c < N; c = c + 1) begin
                reg [3:0] neighbors;
                neighbors = count_neighbors(r, c);
                case (neighbors)
                    2: next_grid[r][c] = current_grid[r][c];
                    3: next_grid[r][c] = 1'b1;
                    default: next_grid[r][c] = 1'b0;
                endcase
            end
        end
    end

    // Sequential logic: load or update q on posedge clk
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Pack next_grid back into q vector
            for (r = 0; r < N; r = r + 1) begin
                q[(r+1)*N-1 -: N] <= next_grid[r];
            end
        end
    end

endmodule