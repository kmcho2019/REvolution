module TopModule (
    input              clk,
    input              load,
    input      [255:0] data,
    output reg [255:0] q
);
    localparam WIDTH = 16;
    localparam HEIGHT = 16;

    // 4-bit wrap-around (mod 16)
    function [3:0] wrap_idx;
        input integer idx;
        begin
            wrap_idx = idx[3:0];
        end
    endfunction

    reg [3:0] row_idx; // row being updated this cycle (0..15)
    reg [255:0] next_q;
    reg [15:0] next_row_data;

    // Extract a single cell bit from q
    function bit get_cell;
        input [255:0] grid;
        input integer r, c;
        begin
            get_cell = grid[(r << 4) + c];
        end
    endfunction

    integer c, dr, dc;
    integer nr, nc;
    integer neighbors;
    bit current_cell;

    always @(*) begin
        // Start with unchanged q
        next_q = q;
        next_row_data = 16'd0;

        // Current row to update
        integer r = row_idx;

        // For each cell in the row
        for (c = 0; c < WIDTH; c = c + 1) begin
            neighbors = 0;
            // Sum neighbors from 3 rows: r-1, r, r+1 (wrap)
            for (dr = -1; dr <= 1; dr = dr + 1) begin
                nr = wrap_idx(r + dr);
                for (dc = -1; dc <= 1; dc = dc + 1) begin
                    if (!(dr == 0 && dc == 0)) begin
                        nc = wrap_idx(c + dc);
                        neighbors = neighbors + get_cell(q, nr, nc);
                    end
                end
            end

            current_cell = get_cell(q, r, c);

            // Apply rules
            if (neighbors <= 1)
                next_row_data[c] = 1'b0;
            else if (neighbors == 2)
                next_row_data[c] = current_cell;
            else if (neighbors == 3)
                next_row_data[c] = 1'b1;
            else
                next_row_data[c] = 1'b0;
        end

        // Write computed row into next_q at correct position
        // Clear current row bits
        next_q = next_q & ~(256'hFFFF << (r << 4));
        // Set updated row bits
        next_q = next_q | (next_row_data << (r << 4));
    end

    always @(posedge clk) begin
        if (load) begin
            q <= data;
            row_idx <= 0;
        end else begin
            q <= next_q;
            row_idx <= wrap_idx(row_idx + 1);
        end
    end

endmodule