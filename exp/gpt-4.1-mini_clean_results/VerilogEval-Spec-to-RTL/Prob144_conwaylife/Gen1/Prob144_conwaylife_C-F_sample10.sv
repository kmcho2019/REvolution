module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    localparam WIDTH = 16;
    localparam HEIGHT = 16;

    // Wrap a coordinate with bit masking for mod 16 (toroid)
    function [3:0] wrap_16;
        input integer val;
        begin
            wrap_16 = val[3:0]; // Just take lower 4 bits for wraparound
        end
    endfunction

    // Return the bit at (r,c) from grid, with toroidal wraparound
    function bit get_cell;
        input [255:0] grid;
        input integer r;
        input integer c;
        integer rr, cc;
        integer idx;
        begin
            rr = wrap_16(r);
            cc = wrap_16(c);
            idx = rr * WIDTH + cc;
            get_cell = grid[idx];
        end
    endfunction

    integer r, c, dr, dc;
    integer neighbors_count;
    reg [255:0] next_q;

    always @(*) begin
        for (r = 0; r < HEIGHT; r = r + 1) begin
            for (c = 0; c < WIDTH; c = c + 1) begin
                neighbors_count = 0;
                // Sum 8 neighbors with wraparound
                for (dr = -1; dr <= 1; dr = dr + 1) begin
                    for (dc = -1; dc <= 1; dc = dc + 1) begin
                        if (!(dr == 0 && dc == 0)) begin
                            neighbors_count = neighbors_count + get_cell(q, r + dr, c + dc);
                        end
                    end
                end

                case (neighbors_count)
                    0,1: next_q[r*WIDTH + c] = 1'b0;
                    2: next_q[r*WIDTH + c] = q[r*WIDTH + c]; // unchanged
                    3: next_q[r*WIDTH + c] = 1'b1;
                    default: next_q[r*WIDTH + c] = 1'b0; // 4+ neighbors
                endcase
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