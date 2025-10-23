module TopModule (
    input           clk,
    input           load,
    input  [255:0]  data,
    output reg [255:0] q
);

    // Grid dimensions
    localparam WIDTH  = 16;
    localparam HEIGHT = 16;

    integer r, c, dr, dc;
    integer nr, nc;
    integer neighbors;
    reg current_cell;
    reg [255:0] next_q;

    always @(*) begin
        // Compute next state combinationally
        for (r = 0; r < HEIGHT; r = r + 1) begin
            for (c = 0; c < WIDTH; c = c + 1) begin
                neighbors = 0;
                // Sum the 8 neighbors with wrapping using bit masking
                for (dr = -1; dr <= 1; dr = dr + 1) begin
                    for (dc = -1; dc <= 1; dc = dc + 1) begin
                        if (!(dr == 0 && dc == 0)) begin
                            // Wrap rows and cols by masking lower 4 bits (mod 16)
                            nr = (r + dr) & 4'hF;
                            nc = (c + dc) & 4'hF;
                            neighbors = neighbors + q[(nr << 4) + nc];
                        end
                    end
                end

                current_cell = q[(r << 4) + c];
                // Apply Game of Life rules
                if (neighbors <= 1)
                    next_q[(r << 4) + c] = 1'b0;
                else if (neighbors == 2)
                    next_q[(r << 4) + c] = current_cell;
                else if (neighbors == 3)
                    next_q[(r << 4) + c] = 1'b1;
                else // neighbors >= 4
                    next_q[(r << 4) + c] = 1'b0;
            end
        end
    end

    // Sequential logic: Load input data or update to next state each clock cycle
    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule