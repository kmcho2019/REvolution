module TopModule(
    input             clk,
    input             load,
    input      [255:0] data,
    output reg [255:0] q
);
    localparam WIDTH = 16;
    localparam HEIGHT = 16;

    reg [255:0] next_q;

    integer r, c, dr, dc;
    integer nr, nc;
    integer neighbors;
    reg cell;

    always @(*) begin
        for (r = 0; r < HEIGHT; r = r + 1) begin
            for (c = 0; c < WIDTH; c = c + 1) begin
                neighbors = 0;
                for (dr = -1; dr <= 1; dr = dr + 1) begin
                    for (dc = -1; dc <= 1; dc = dc + 1) begin
                        if (!(dr == 0 && dc == 0)) begin
                            nr = (r + dr + WIDTH) & 4'hF; // mod 16
                            nc = (c + dc + WIDTH) & 4'hF; // mod 16
                            neighbors = neighbors + q[nr*WIDTH + nc];
                        end
                    end
                end
                cell = q[r*WIDTH + c];
                if (neighbors <= 1)
                    next_q[r*WIDTH + c] = 1'b0;
                else if (neighbors == 2)
                    next_q[r*WIDTH + c] = cell;
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