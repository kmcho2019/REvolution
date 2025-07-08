module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // function to get bit at (row,col) with wrap-around
    function automatic bit get_cell;
        input [255:0] grid;
        input integer row;
        input integer col;
        integer r, c, idx;
        begin
            r = (row + 16) % 16;
            c = (col + 16) % 16;
            idx = r*16 + c;
            get_cell = grid[idx];
        end
    endfunction

    integer r, c, dr, dc;
    integer nr, nc;
    integer count;
    reg [255:0] next_q;

    always @* begin
        for (r = 0; r < 16; r = r + 1) begin
            for (c = 0; c < 16; c = c + 1) begin
                count = 0;
                // count neighbors
                for (dr = -1; dr <= 1; dr = dr + 1) begin
                    for (dc = -1; dc <= 1; dc = dc + 1) begin
                        if (!(dr == 0 && dc == 0)) begin
                            nr = (r + dr + 16) % 16;
                            nc = (c + dc + 16) % 16;
                            count = count + (q[nr*16 + nc] ? 1 : 0);
                        end
                    end
                end

                // apply rules
                case (count)
                    2: next_q[r*16 + c] = q[r*16 + c];    // stays same
                    3: next_q[r*16 + c] = 1'b1;           // becomes alive
                    default: next_q[r*16 + c] = 1'b0;     // otherwise dead
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