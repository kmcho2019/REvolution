module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);
    // Grid dimension
    localparam N = 16;

    // Function to get index in 1D vector from row and col
    function integer idx(input integer r, input integer c);
        begin
            idx = r * N + c;
        end
    endfunction

    // Wrap index modulo N (16) using bitwise AND (since N=16)
    function integer wrap(input integer x);
        begin
            wrap = x & (N - 1);
        end
    endfunction

    // Function to count neighbors for a given cell position in current state
    function [3:0] neighbor_count;
        input [255:0] grid;
        input integer r;
        input integer c;
        integer ru, rd, cl, cr;
        begin
            ru = wrap(r - 1);
            rd = wrap(r + 1);
            cl = wrap(c - 1);
            cr = wrap(c + 1);

            neighbor_count =
                  grid[idx(ru, cl)]
                + grid[idx(ru, c)]
                + grid[idx(ru, cr)]
                + grid[idx(r, cl)]
                + grid[idx(r, cr)]
                + grid[idx(rd, cl)]
                + grid[idx(rd, c)]
                + grid[idx(rd, cr)];
        end
    endfunction

    // Compute next state combinationally per cell
    reg [255:0] next_state;

    integer r, c;
    always @* begin
        for (r = 0; r < N; r = r + 1) begin
            for (c = 0; c < N; c = c + 1) begin
                // Current cell
                wire curr = q[idx(r,c)];
                // Neighbor count
                wire [3:0] ncount = neighbor_count(q, r, c);

                // Apply rules:
                // neighbors 0-1 => 0
                // neighbors 2   => current state
                // neighbors 3   => 1
                // neighbors 4+  => 0
                if (ncount <= 1)
                    next_state[idx(r,c)] = 1'b0;
                else if (ncount == 2)
                    next_state[idx(r,c)] = curr;
                else if (ncount == 3)
                    next_state[idx(r,c)] = 1'b1;
                else
                    next_state[idx(r,c)] = 1'b0;
            end
        end
    end

    // Synchronous update of state with load input
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_state;
        end
    end
endmodule