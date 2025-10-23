module TopModule(
    input              clk,
    input              load,
    input      [255:0] data,
    output reg [255:0] q
);
    localparam WIDTH = 16;
    localparam HEIGHT = 16;

    reg [255:0] next_q;

    integer r, c;

    // Helper macro to compute wrapped index using bit masking (mod 16)
    function [3:0] wrap;
        input integer idx;
        begin
            wrap = idx[3:0]; // since WIDTH=16, modulo 16 = mask lower 4 bits
        end
    endfunction

    always @(*) begin
        for (r = 0; r < HEIGHT; r = r + 1) begin
            for (c = 0; c < WIDTH; c = c + 1) begin
                integer neighbors;
                reg current_cell;
                reg [7:0] neighbor_cells;
                integer nr, nc;

                // Compute wrapped neighbor indices explicitly and gather neighbors
                neighbor_cells[0] = q[wrap(r-1)*WIDTH + wrap(c-1)];
                neighbor_cells[1] = q[wrap(r-1)*WIDTH + wrap(c)];
                neighbor_cells[2] = q[wrap(r-1)*WIDTH + wrap(c+1)];
                neighbor_cells[3] = q[wrap(r)*WIDTH + wrap(c-1)];
                neighbor_cells[4] = q[wrap(r)*WIDTH + wrap(c+1)];
                neighbor_cells[5] = q[wrap(r+1)*WIDTH + wrap(c-1)];
                neighbor_cells[6] = q[wrap(r+1)*WIDTH + wrap(c)];
                neighbor_cells[7] = q[wrap(r+1)*WIDTH + wrap(c+1)];

                // Sum neighbors
                neighbors = neighbor_cells[0] + neighbor_cells[1] + neighbor_cells[2] +
                            neighbor_cells[3] + neighbor_cells[4] + neighbor_cells[5] +
                            neighbor_cells[6] + neighbor_cells[7];

                current_cell = q[r*WIDTH + c];

                // Apply game rules
                if (neighbors <= 1)
                    next_q[r*WIDTH + c] = 1'b0;
                else if (neighbors == 2)
                    next_q[r*WIDTH + c] = current_cell;
                else if (neighbors == 3)
                    next_q[r*WIDTH + c] = 1'b1;
                else
                    next_q[r*WIDTH + c] = 1'b0;
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