module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    localparam WIDTH = 16;
    localparam HEIGHT = 16;

    // Convert 2D coords to 1D index
    function [7:0] to_idx(input [3:0] row, input [3:0] col);
        to_idx = {row, col};
    endfunction

    // Wrap around modulo 16 (mask lower 4 bits)
    function [3:0] wrap(input integer val);
        wrap = val[3:0];
    endfunction

    // Cell state accessor from a 256-bit vector with wraparound
    function cell_state(input [255:0] grid, input integer r, input integer c);
        cell_state = grid[to_idx(wrap(r), wrap(c))];
    endfunction

    reg [255:0] next_q;           // stores the updated grid after full update
    reg [3:0] row_counter;        // current row being processed (0..15)
    reg processing;               // flag indicating we are mid-update (not loading)

    integer j, ni, nj;
    reg [3:0] neighbors;

    always @(posedge clk) begin
        if (load) begin
            // Load entire grid immediately
            q <= data;
            next_q <= 0;
            row_counter <= 0;
            processing <= 0;
        end else begin
            if (processing == 0) begin
                // Start processing rows from row 0
                processing <= 1;
                row_counter <= 0;
                next_q <= 0; // clear next state buffer
            end else begin
                // Update one row of next_q per clock
                // Count neighbors and update cells in row_counter
                for (j = 0; j < WIDTH; j = j +1) begin
                    neighbors = 0;
                    for (ni = row_counter - 1; ni <= row_counter + 1; ni = ni + 1) begin
                        for (nj = j - 1; nj <= j + 1; nj = nj + 1) begin
                            if (!(ni == row_counter && nj == j))
                                neighbors = neighbors + cell_state(q, ni, nj);
                        end
                    end
                    // Apply rules
                    case (neighbors)
                        2: next_q[to_idx(row_counter, j)] <= q[to_idx(row_counter, j)]; // stay same
                        3: next_q[to_idx(row_counter, j)] <= 1'b1;                      // become alive
                        default: next_q[to_idx(row_counter, j)] <= 1'b0;                // die
                    endcase
                end

                if (row_counter == HEIGHT - 1) begin
                    // Finished updating all rows, commit next_q to q
                    q <= next_q;
                    processing <= 0; // done with this update
                end else begin
                    row_counter <= row_counter + 1;
                end
            end
        end
    end

endmodule