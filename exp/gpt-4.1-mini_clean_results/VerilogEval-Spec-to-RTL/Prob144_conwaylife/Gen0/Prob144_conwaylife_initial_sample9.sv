module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Local parameters for grid size
    localparam ROWS = 16;
    localparam COLS = 16;

    // Function to get bit at (r,c) with wrap-around
    function bit get_cell;
        input [255:0] grid;
        input integer r, c;
        integer rr, cc;
        begin
            rr = (r + ROWS) % ROWS;
            cc = (c + COLS) % COLS;
            get_cell = grid[rr*COLS + cc];
        end
    endfunction

    integer r, c, dr, dc;
    reg [255:0] next_q;
    integer neighbors_count;

    always @(*) begin
        // For each cell compute neighbors and next state
        for (r = 0; r < ROWS; r = r + 1) begin
            for (c = 0; c < COLS; c = c + 1) begin
                neighbors_count = 0;
                // Check all 8 neighbors
                for (dr = -1; dr <= 1; dr = dr + 1) begin
                    for (dc = -1; dc <= 1; dc = dc + 1) begin
                        if (!(dr == 0 && dc == 0)) begin
                            neighbors_count = neighbors_count + get_cell(q, r + dr, c + dc);
                        end
                    end
                end

                // Apply rules
                case (neighbors_count)
                    0,1: next_q[r*COLS + c] = 1'b0;
                    2: next_q[r*COLS + c] = q[r*COLS + c];
                    3: next_q[r*COLS + c] = 1'b1;
                    default: next_q[r*COLS + c] = 1'b0;
                endcase
            end
        end
    end

    // Sequential logic for loading or advancing the game state
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule