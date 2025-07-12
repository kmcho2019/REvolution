module TopModule (
    input              clk,
    input              load,
    input      [255:0] data,
    output reg [255:0] q
);
    localparam WIDTH = 16;
    localparam HEIGHT = 16;

    wire [255:0] next_q;

    // Function to compute neighbor count of cell (r,c)
    function [3:0] neighbor_count;
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
                    nr = (r + dr + HEIGHT) % HEIGHT;
                    nc = (c + dc + WIDTH) % WIDTH;
                    sum = sum + q[nr*WIDTH + nc];
                end
            end
        end
        neighbor_count = sum[3:0];
    end
    endfunction

    genvar r, c;

    // Generate combinational logic to compute next state for each cell
    generate
        for (r = 0; r < HEIGHT; r = r + 1) begin : ROW_LOOP
            for (c = 0; c < WIDTH; c = c + 1) begin : COL_LOOP
                wire current_cell = q[r*WIDTH + c];
                wire [3:0] neighbors = neighbor_count(r, c);

                // Assign next state per rules:
                // (1) neighbors 0 or 1 -> 0
                // (2) neighbors 2 -> current cell
                // (3) neighbors 3 -> 1
                // (4) neighbors >=4 -> 0

                assign next_q[r*WIDTH + c] = (neighbors == 2) ? current_cell :
                                             (neighbors == 3) ? 1'b1 : 1'b0;
            end
        end
    endgenerate

    // Synchronous state update with load option
    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule