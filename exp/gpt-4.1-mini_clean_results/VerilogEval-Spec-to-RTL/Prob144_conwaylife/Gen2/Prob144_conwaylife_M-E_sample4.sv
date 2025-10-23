module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    localparam ROWS = 16;
    localparam COLS = 16;

    // Registers to hold next state and row being processed
    reg [255:0] next_q;
    reg [3:0] row_counter; // 0 to 15

    // Helper function: get cell from grid with wrapping using mask (mod 16)
    function bit get_cell;
        input [255:0] grid;
        input [3:0] r; // 4-bit row index (0-15)
        input [3:0] c; // 4-bit col index (0-15)
        begin
            get_cell = grid[(r*COLS) + c];
        end
    endfunction

    integer c, dr, dc;
    integer neighbors_count;
    reg [3:0] rr, cc;

    reg [COLS-1:0] next_row; // holds next states for one row

    always @(*) begin
        next_row = 0;
        // Compute next row based on row_counter and current q
        // For each column in the row
        for (c = 0; c < COLS; c = c + 1) begin
            neighbors_count = 0;
            // Sum over neighbors (8 neighbors)
            for (dr = -1; dr <= 1; dr = dr + 1) begin
                rr = (row_counter + dr) & 4'hF; // wrap with & 0xF
                for (dc = -1; dc <= 1; dc = dc + 1) begin
                    cc = (c + dc) & 4'hF;
                    if (!(dr == 0 && dc == 0)) begin
                        neighbors_count = neighbors_count + get_cell(q, rr, cc);
                    end
                end
            end

            // Apply rules
            case (neighbors_count)
                0,1: next_row[c] = 1'b0;
                2:   next_row[c] = get_cell(q, row_counter, c);
                3:   next_row[c] = 1'b1;
                default: next_row[c] = 1'b0;
            endcase
        end
    end

    always @(posedge clk) begin
        if (load) begin
            q <= data;
            next_q <= data;
            row_counter <= 0;
        end else begin
            // Insert computed row into next_q
            // Clear old bits of that row, then set new bits
            next_q <= (next_q & ~(256'hFFFF << (row_counter*COLS))) | ({{(256-COLS){1'b0}}, next_row} << (row_counter*COLS));

            if (row_counter == ROWS-1) begin
                // All rows processed, update q with next_q and restart
                q <= next_q;
                row_counter <= 0;
            end else begin
                row_counter <= row_counter + 1;
            end
        end
    end

endmodule