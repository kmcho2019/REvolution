module TopModule (
    input              clk,
    input              load,
    input      [255:0] data,
    output reg [255:0] q
);
    localparam WIDTH = 16;
    localparam HEIGHT = 16;

    // Wrap around index mod 16 by masking lower 4 bits
    function [3:0] wrap_index;
        input integer idx;
        begin
            wrap_index = idx[3:0];
        end
    endfunction

    // Function to count alive neighbors for given row and column
    function [3:0] count_neighbors;
        input integer r;
        input integer c;
        integer dr, dc;
        integer nr, nc;
        integer sum;
        begin
            sum = 0;
            for (dr = -1; dr <= 1; dr = dr + 1) begin
                for (dc = -1; dc <= 1; dc = dc + 1) begin
                    if (!(dr == 0 && dc == 0)) begin
                        nr = wrap_index(r + dr);
                        nc = wrap_index(c + dc);
                        sum = sum + q[(nr << 4) + nc];
                    end
                end
            end
            count_neighbors = sum[3:0];
        end
    endfunction

    // Next state signals for each cell
    wire [255:0] next_q;

    genvar r, c;
    generate
        for (r = 0; r < HEIGHT; r = r + 1) begin : row_loop
            for (c = 0; c < WIDTH; c = c + 1) begin : col_loop
                wire [3:0] ncount;
                wire current_cell;
                assign current_cell = q[(r << 4) + c];
                // Using a function in a generate block requires a helper wire to hold the count
                // We create a small module instance to invoke the function inside generate
                // But Verilog doesn't allow function calls with variable arguments in generate
                // So, replicate the logic as a combinational block inside generate
                wire [3:0] neighbors;

                // Using a combinational block per cell to count neighbors
                // and determine next state
                reg next_state;
                // Instead of reg in generate, use assign and a helper function outside
                // We must create a small function to mimic count_neighbors here:
                // However, functions with loop and variable indexing are not synthesizable inside generate
                // So, reimplement count_neighbors in a local function and call via a combinational block

                // To solve this, create a per-cell module to count neighbors and output next cell state
                // But for brevity, unroll neighbor counting manually here using generate and assign:

            end
        end
    endgenerate

    // Because above generate cannot call count_neighbors function with variables,
    // rewrite neighbor count in a separate module and instantiate 256 times.

    // Neighbor counting and next state logic module:
    // This module takes current state q as input, and row,col
    // Outputs next cell state according to rules

    module CellUpdate(
        input [255:0] state,
        input [3:0] r,
        input [3:0] c,
        output next_cell
    );
        integer dr, dc;
        integer nr, nc;
        integer sum;
        reg current_cell;
        begin
            sum = 0;
            for (dr = -1; dr <= 1; dr = dr + 1) begin
                for (dc = -1; dc <= 1; dc = dc + 1) begin
                    if (!(dr == 0 && dc == 0)) begin
                        nr = (r + dr) & 4'hF; // wrap using mask
                        nc = (c + dc) & 4'hF;
                        sum = sum + state[(nr << 4) + nc];
                    end
                end
            end
            current_cell = state[(r << 4) + c];
            if (sum <= 1)
                next_cell = 1'b0;
            else if (sum == 2)
                next_cell = current_cell;
            else if (sum == 3)
                next_cell = 1'b1;
            else
                next_cell = 1'b0;
        end
    endmodule

    // Now instantiate one CellUpdate per cell and connect outputs to next_q bits
    genvar rr, cc;
    generate
        for (rr = 0; rr < HEIGHT; rr = rr + 1) begin : cell_row
            for (cc = 0; cc < WIDTH; cc = cc + 1) begin : cell_col
                wire next_cell_bit;
                CellUpdate cu(
                    .state(q),
                    .r(rr[3:0]),
                    .c(cc[3:0]),
                    .next_cell(next_cell_bit)
                );
                assign next_q[(rr << 4) + cc] = next_cell_bit;
            end
        end
    endgenerate

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule