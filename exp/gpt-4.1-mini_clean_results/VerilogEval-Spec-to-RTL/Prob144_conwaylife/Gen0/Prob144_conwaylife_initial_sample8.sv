module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Parameters for grid size
    localparam N = 16;

    // Function to compute the wrapped index (mod 16)
    function [3:0] wrap_index;
        input integer idx;
        begin
            if (idx < 0)
                wrap_index = idx + N;
            else if (idx >= N)
                wrap_index = idx - N;
            else
                wrap_index = idx[3:0];
        end
    endfunction

    reg [255:0] next_q;

    integer r, c;
    integer rr, cc;
    integer idx;
    reg cell_state;
    reg [3:0] neighbor_count;
    reg [255:0] current;

    always @(*) begin
        current = q;
        next_q = 256'b0;

        // For each cell (r,c)
        for (r = 0; r < N; r = r + 1) begin
            for (c = 0; c < N; c = c + 1) begin
                // Calculate 1D index of current cell
                idx = r * N + c;
                cell_state = current[idx];

                // Count neighbors by summing 8 neighbors with wrap-around
                neighbor_count = 0;
                // neighbors relative row offsets: -1, 0, 1
                // neighbors relative col offsets: -1, 0, 1
                // skip (0,0)
                for (rr = r - 1; rr <= r + 1; rr = rr + 1) begin
                    for (cc = c - 1; cc <= c + 1; cc = cc + 1) begin
                        if (!(rr == r && cc == c)) begin
                            neighbor_count = neighbor_count + current[wrap_index(rr)*N + wrap_index(cc)];
                        end
                    end
                end

                // Apply rules:
                // 0-1 neighbor: cell becomes 0
                // 2 neighbors: cell unchanged
                // 3 neighbors: cell becomes 1
                // 4+ neighbors: cell becomes 0
                if (neighbor_count <= 1)
                    next_q[idx] = 1'b0;
                else if (neighbor_count == 2)
                    next_q[idx] = cell_state;
                else if (neighbor_count == 3)
                    next_q[idx] = 1'b1;
                else // neighbor_count >= 4
                    next_q[idx] = 1'b0;
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