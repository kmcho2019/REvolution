module TopModule (
    input              clk,
    input              load,
    input      [255:0] data,
    output reg [255:0] q
);
    // Grid dimensions
    localparam WIDTH = 16;
    localparam HEIGHT = 16;

    // Wrap-around function using bit masking (mod 16)
    function [3:0] wrap_index;
        input integer idx;
        begin
            // Wrap modulo 16 by masking lower 4 bits
            wrap_index = idx[3:0];
        end
    endfunction

    reg [255:0] next_q;

    integer r, c, dr, dc;
    integer nr, nc;
    integer neighbors;
    reg current_cell;

    always @(*) begin
        next_q = 256'b0;

        for (r = 0; r < HEIGHT; r = r + 1) begin
            for (c = 0; c < WIDTH; c = c + 1) begin
                neighbors = 0;
                for (dr = -1; dr <= 1; dr = dr + 1) begin
                    for (dc = -1; dc <= 1; dc = dc + 1) begin
                        if (!(dr == 0 && dc == 0)) begin
                            // Wrap indices via masking
                            nr = wrap_index(r + dr);
                            nc = wrap_index(c + dc);
                            neighbors = neighbors + q[(nr << 4) + nc]; // (nr * 16) = nr << 4
                        end
                    end
                end

                current_cell = q[(r << 4) + c];
                // Apply rules:
                // 0-1 neighbors: dead (0)
                // 2 neighbors: no change
                // 3 neighbors: alive (1)
                // 4+ neighbors: dead (0)
                if (neighbors <= 1)
                    next_q[(r << 4) + c] = 1'b0;
                else if (neighbors == 2)
                    next_q[(r << 4) + c] = current_cell;
                else if (neighbors == 3)
                    next_q[(r << 4) + c] = 1'b1;
                else
                    next_q[(r << 4) + c] = 1'b0;
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