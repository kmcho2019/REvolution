module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);
    localparam WIDTH = 16;
    localparam HEIGHT = 16;

    // Inline modular wrap for rows and columns (0..15)
    function [3:0] wrap(input integer val);
        begin
            wrap = val[3:0];
        end
    endfunction

    integer r, c, dr, dc;
    reg [3:0] nr, nc;
    reg [3:0] count;
    reg [255:0] next_q;

    always @* begin
        for (r = 0; r < HEIGHT; r = r + 1) begin
            for (c = 0; c < WIDTH; c = c + 1) begin
                count = 0;
                for (dr = -1; dr <= 1; dr = dr + 1) begin
                    for (dc = -1; dc <= 1; dc = dc + 1) begin
                        if (!(dr == 0 && dc == 0)) begin
                            nr = wrap(r + dr);
                            nc = wrap(c + dc);
                            count = count + q[nr*WIDTH + nc];
                        end
                    end
                end

                // Apply Game of Life rules
                if (count <= 1)
                    next_q[r*WIDTH + c] = 1'b0;
                else if (count == 2)
                    next_q[r*WIDTH + c] = q[r*WIDTH + c];
                else if (count == 3)
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