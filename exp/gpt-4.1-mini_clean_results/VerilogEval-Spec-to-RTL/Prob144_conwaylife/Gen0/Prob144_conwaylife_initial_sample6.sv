module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);
    // Parameters for size
    localparam N = 16;

    // Helper function: modular index for wrapping (0..15)
    function [3:0] wrap_idx(input integer idx);
        begin
            if (idx < 0)
                wrap_idx = idx + N;
            else if (idx >= N)
                wrap_idx = idx - N;
            else
                wrap_idx = idx[3:0];
        end
    endfunction

    integer r, c, rr, cc;
    reg [3:0] nr, nc;
    reg [3:0] row, col;

    reg [8:0] neighbor_count; // max 8 neighbours count fits in 4 bits, use 9 for safety
    reg cell_state;
    reg [255:0] next_q;

    always @(*) begin
        // Default next_q to current state q in case of load
        next_q = q;
        for (r = 0; r < N; r = r + 1) begin
            for (c = 0; c < N; c = c + 1) begin
                // sum neighbors
                neighbor_count = 0;
                for (rr = r-1; rr <= r+1; rr = rr + 1) begin
                    for (cc = c-1; cc <= c+1; cc = cc + 1) begin
                        if (!(rr == r && cc == c)) begin
                            nr = wrap_idx(rr);
                            nc = wrap_idx(cc);
                            neighbor_count = neighbor_count + q[nr*16+nc];
                        end
                    end
                end
                row = r[3:0];
                col = c[3:0];
                cell_state = q[row*16 + col];
                // Apply rules
                if (neighbor_count <= 1)
                    next_q[row*16 + col] = 1'b0;
                else if (neighbor_count == 2)
                    next_q[row*16 + col] = cell_state;
                else if (neighbor_count == 3)
                    next_q[row*16 + col] = 1'b1;
                else
                    next_q[row*16 + col] = 1'b0;
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