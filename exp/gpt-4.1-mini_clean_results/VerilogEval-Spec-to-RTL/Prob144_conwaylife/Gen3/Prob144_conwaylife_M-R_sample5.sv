module TopModule(
    input          clk,
    input          load,
    input  [255:0] data,
    output reg [255:0] q
);
    localparam WIDTH = 16;
    localparam HEIGHT = 16;

    // Wrap indices modulo 16 using bitwise AND (mod 16)
    function [3:0] wrap_index;
        input integer idx;
        begin
            wrap_index = idx[3:0] & 4'hF;
        end
    endfunction

    // Function to count neighbors of a cell (r,c)
    function [3:0] count_neighbors;
        input [255:0] grid;
        input integer r;
        input integer c;
        integer dr, dc;
        integer nr, nc;
        reg [3:0] count;
        begin
            count = 0;
            for (dr = -1; dr <= 1; dr = dr + 1) begin
                for (dc = -1; dc <= 1; dc = dc + 1) begin
                    if (!(dr == 0 && dc == 0)) begin
                        nr = wrap_index(r + dr);
                        nc = wrap_index(c + dc);
                        count = count + grid[(nr << 4) + nc];
                    end
                end
            end
            count_neighbors = count;
        end
    endfunction

    // Function to compute next cell state given neighbors and current state
    function next_cell_state;
        input [3:0] neighbors;
        input       current;
        begin
            // Rules:
            // neighbors 0-1 -> 0
            // neighbors 2   -> same
            // neighbors 3   -> 1
            // neighbors 4+  -> 0
            if (neighbors <= 1)
                next_cell_state = 1'b0;
            else if (neighbors == 2)
                next_cell_state = current;
            else if (neighbors == 3)
                next_cell_state = 1'b1;
            else
                next_cell_state = 1'b0;
        end
    endfunction

    // Generate the next state combinationally for all cells
    wire [255:0] next_q;

    genvar row, col;
    generate
        for (row = 0; row < HEIGHT; row = row + 1) begin : ROW_LOOP
            for (col = 0; col < WIDTH; col = col + 1) begin : COL_LOOP
                wire current_cell = q[(row << 4) + col];
                wire [3:0] neighbors = count_neighbors(q, row, col);
                assign next_q[(row << 4) + col] = next_cell_state(neighbors, current_cell);
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