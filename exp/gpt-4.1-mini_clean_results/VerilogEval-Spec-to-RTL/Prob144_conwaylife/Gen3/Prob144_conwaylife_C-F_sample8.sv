module TopModule (
    input             clk,
    input             load,
    input      [255:0] data,
    output reg [255:0] q
);
    localparam WIDTH = 16;
    localparam HEIGHT = 16;

    reg [255:0] next_q;

    integer r, c, dr, dc;
    integer nr, nc;
    integer neighbors;
    reg current_cell;

    // Use mask to wrap index modulo 16
    function [3:0] wrap16(input integer idx);
        begin
            wrap16 = idx & 4'hF;
        end
    endfunction

    always @(*) begin
        for (r = 0; r < HEIGHT; r = r + 1) begin
            for (c = 0; c < WIDTH; c = c + 1) begin
                neighbors = 0;
                for (dr = -1; dr <= 1; dr = dr + 1) begin
                    for (dc = -1; dc <= 1; dc = dc + 1) begin
                        if (!(dr == 0 && dc == 0)) begin
                            nr = wrap16(r + dr);
                            nc = wrap16(c + dc);
                            // Access using bit-shift indexing (row << 4 + col)
                            neighbors = neighbors + q[(nr << 4) + nc];
                        end
                    end
                end

                current_cell = q[(r << 4) + c];
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