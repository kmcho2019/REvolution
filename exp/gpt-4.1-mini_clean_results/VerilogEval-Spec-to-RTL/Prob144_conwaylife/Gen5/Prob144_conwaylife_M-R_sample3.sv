module TopModule (
    input              clk,
    input              load,
    input      [255:0] data,
    output reg [255:0] q
);
    localparam WIDTH = 16;
    localparam HEIGHT = 16;

    // Wrap-around function (mod 16 using 4-bit mask)
    function [3:0] wrap_index(input integer idx);
        begin
            wrap_index = idx[3:0];
        end
    endfunction

    // Function to count neighbors of cell (r,c) in grid state 'grid'
    function [3:0] count_neighbors;
        input [255:0] grid;
        input integer r;
        input integer c;
        integer dr, dc;
        integer nr, nc;
        integer count;
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
            count_neighbors = count[3:0]; // 0 to 8 fits in 4 bits
        end
    endfunction

    // Function to compute next cell state given current state and neighbor count
    function next_cell_state;
        input current;
        input [3:0] neighbors;
        begin
            case (neighbors)
                2: next_cell_state = current; // no change
                3: next_cell_state = 1'b1;    // cell alive
                default: next_cell_state = 1'b0; // all others dead
            endcase
        end
    endfunction

    wire [255:0] next_q;

    genvar r, c;
    generate
        for (r = 0; r < HEIGHT; r = r + 1) begin : row_loop
            for (c = 0; c < WIDTH; c = c + 1) begin : col_loop
                wire [3:0] ncount = count_neighbors(q, r, c);
                wire current_cell = q[(r << 4) + c];
                wire next_cell = next_cell_state(current_cell, ncount);
                assign next_q[(r << 4) + c] = next_cell;
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