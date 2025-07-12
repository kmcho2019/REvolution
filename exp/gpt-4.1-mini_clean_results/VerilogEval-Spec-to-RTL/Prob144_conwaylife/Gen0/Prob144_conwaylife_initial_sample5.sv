module TopModule(
    input        clk,
    input        load,
    input  [255:0] data,
    output reg [255:0] q
);
    // Parameters for grid dimensions
    localparam WIDTH  = 16;
    localparam HEIGHT = 16;

    // Function to handle wrap-around indices
    function [3:0] wrap_index(input integer idx);
        begin
            // Wrap modulo 16
            if (idx < 0)
                wrap_index = idx + 16;
            else if (idx > 15)
                wrap_index = idx - 16;
            else
                wrap_index = idx[3:0];
        end
    endfunction

    // Next state storage
    reg [255:0] next_q;

    integer r, c, dr, dc;
    integer nr, nc;
    integer neighbors;
    reg current_cell;

    always @(*) begin
        // Compute next_q combinationally
        for (r = 0; r < HEIGHT; r = r + 1) begin
            for (c = 0; c < WIDTH; c = c + 1) begin
                // Count live neighbors
                neighbors = 0;
                for (dr = -1; dr <= 1; dr = dr + 1) begin
                    for (dc = -1; dc <= 1; dc = dc + 1) begin
                        if (!(dr == 0 && dc == 0)) begin
                            nr = wrap_index(r + dr);
                            nc = wrap_index(c + dc);
                            neighbors = neighbors + q[nr*WIDTH + nc];
                        end
                    end
                end

                current_cell = q[r*WIDTH + c];
                // Apply rules:
                // 0-1 neighbor => 0
                // 2 neighbors => same state
                // 3 neighbors => 1
                // 4+ neighbors => 0

                if (neighbors <= 1) begin
                    next_q[r*WIDTH + c] = 1'b0;
                end else if (neighbors == 2) begin
                    next_q[r*WIDTH + c] = current_cell;
                end else if (neighbors == 3) begin
                    next_q[r*WIDTH + c] = 1'b1;
                end else begin // neighbors >= 4
                    next_q[r*WIDTH + c] = 1'b0;
                end
            end
        end
    end

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule