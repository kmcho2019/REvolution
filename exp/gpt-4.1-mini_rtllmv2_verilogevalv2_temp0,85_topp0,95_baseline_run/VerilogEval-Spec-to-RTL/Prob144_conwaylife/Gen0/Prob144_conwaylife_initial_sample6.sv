module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);
    // Helper function to wrap indices mod 16
    function [3:0] wrap;
        input integer idx;
        begin
            if (idx < 0)
                wrap = idx + 16;
            else if (idx > 15)
                wrap = idx - 16;
            else
                wrap = idx[3:0];
        end
    endfunction

    integer r, c, dr, dc;
    reg [255:0] next_q;

    // Convert q to 2D array for easier indexing
    wire [0:15][0:15] state;
    genvar rr, cc;
    generate
        for (rr = 0; rr < 16; rr = rr + 1) begin : gen_row
            for (cc = 0; cc < 16; cc = cc + 1) begin : gen_col
                assign state[rr][cc] = q[rr*16 + cc];
            end
        end
    endgenerate

    // Compute next state combinationally
    always @(*) begin
        // For each cell
        for (r = 0; r < 16; r = r + 1) begin
            for (c = 0; c < 16; c = c + 1) begin
                // Count neighbors
                integer neighbors;
                neighbors = 0;
                for (dr = -1; dr <= 1; dr = dr + 1) begin
                    for (dc = -1; dc <= 1; dc = dc + 1) begin
                        if (!(dr == 0 && dc == 0)) begin
                            neighbors = neighbors + state[wrap(r+dr)][wrap(c+dc)];
                        end
                    end
                end
                // Apply rules
                if (neighbors <= 1)
                    next_q[r*16 + c] = 1'b0;
                else if (neighbors == 2)
                    next_q[r*16 + c] = state[r][c];
                else if (neighbors == 3)
                    next_q[r*16 + c] = 1'b1;
                else // neighbors >= 4
                    next_q[r*16 + c] = 1'b0;
            end
        end
    end

    // Sequential update
    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule