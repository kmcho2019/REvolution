module TopModule (
    input        clk,
    input        load,
    input  [255:0] data,
    output reg [255:0] q
);
    // Helper function to get neighbor count with wraparound
    function [3:0] neighbor_count;
        input [255:0] state;
        input integer r;
        input integer c;
        integer rr, cc;
        integer dr, dc;
        integer idx;
        reg [3:0] count;
    begin
        count = 0;
        for (dr = -1; dr <= 1; dr = dr + 1) begin
            for (dc = -1; dc <= 1; dc = dc + 1) begin
                if (!(dr == 0 && dc == 0)) begin
                    // Wrap row and col
                    rr = (r + dr + 16) % 16;
                    cc = (c + dc + 16) % 16;
                    idx = rr*16 + cc;
                    count = count + state[idx];
                end
            end
        end
        neighbor_count = count;
    end
    endfunction

    integer r, c;
    reg [255:0] next_q;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Compute next state for each cell
            for (r = 0; r < 16; r = r + 1) begin
                for (c = 0; c < 16; c = c + 1) begin
                    reg current_cell;
                    reg [3:0] n_count;
                    integer idx;
                    idx = r*16 + c;
                    current_cell = q[idx];
                    n_count = neighbor_count(q, r, c);
                    if (n_count <= 1)
                        next_q[idx] = 0;
                    else if (n_count == 2)
                        next_q[idx] = current_cell;
                    else if (n_count == 3)
                        next_q[idx] = 1;
                    else // n_count >= 4
                        next_q[idx] = 0;
                end
            end
            q <= next_q;
        end
    end

endmodule