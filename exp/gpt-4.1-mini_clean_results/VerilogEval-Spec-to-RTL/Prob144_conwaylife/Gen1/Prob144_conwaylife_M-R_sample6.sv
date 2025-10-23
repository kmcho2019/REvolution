module TopModule (
    input wire clk,
    input wire load,
    input wire [255:0] data,
    output reg [255:0] q
);
    localparam ROWS = 16;
    localparam COLS = 16;

    // Wrap-around index using bit masking instead of modulo, since 16 = 2^4
    function automatic [3:0] wrap_index;
        input integer idx;
        begin
            wrap_index = idx[3:0]; // Equivalent to idx % 16 for non-negative idx
        end
    endfunction

    // Function to count neighbors of cell (r, c) in the grid
    function automatic [3:0] count_neighbors;
        input [255:0] grid;
        input integer r, c;
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
                        count = count + grid[nr*COLS + nc];
                    end
                end
            end
            count_neighbors = count;
        end
    endfunction

    // Function to compute next cell state based on current state and neighbor count
    function automatic next_cell_state;
        input bit current;
        input [3:0] neighbors;
        begin
            case (neighbors)
                0,1: next_cell_state = 1'b0;
                2:   next_cell_state = current;
                3:   next_cell_state = 1'b1;
                default: next_cell_state = 1'b0;
            endcase
        end
    endfunction

    // Generate combinational logic for next_q vector
    wire [255:0] next_q;
    genvar r, c;

    generate
        for (r = 0; r < ROWS; r = r + 1) begin : row_loop
            for (c = 0; c < COLS; c = c + 1) begin : col_loop
                wire current_bit = q[r*COLS + c];
                wire [3:0] neighbor_count = count_neighbors(q, r, c);
                assign next_q[r*COLS + c] = next_cell_state(current_bit, neighbor_count);
            end
        end
    endgenerate

    // Sequential update logic
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule