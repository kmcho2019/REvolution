module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);
    localparam WIDTH = 16;
    localparam HEIGHT = 16;

    // Helper function: Get cell value at (r,c) with wrap-around
    function automatic bit get_cell(input [255:0] state, input integer r, input integer c);
        integer rr, cc, idx;
    begin
        rr = (r + HEIGHT) % HEIGHT;
        cc = (c + WIDTH) % WIDTH;
        idx = rr*WIDTH + cc;
        get_cell = state[idx];
    end
    endfunction

    integer r, c, nr, nc;
    integer neighbor_count;
    reg [255:0] next_q;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Compute next state for each cell
            for (r = 0; r < HEIGHT; r = r + 1) begin
                for (c = 0; c < WIDTH; c = c + 1) begin
                    neighbor_count = 0;
                    // Sum neighbors (8 neighbors)
                    for (nr = r-1; nr <= r+1; nr = nr + 1) begin
                        for (nc = c-1; nc <= c+1; nc = nc + 1) begin
                            if (!(nr == r && nc == c)) begin
                                neighbor_count = neighbor_count + get_cell(q, nr, nc);
                            end
                        end
                    end
                    // Apply rules:
                    // 0-1 neighbors: cell=0
                    // 2 neighbors: cell unchanged
                    // 3 neighbors: cell=1
                    // 4+ neighbors: cell=0
                    if (neighbor_count <= 1) begin
                        next_q[r*WIDTH + c] = 0;
                    end else if (neighbor_count == 2) begin
                        next_q[r*WIDTH + c] = q[r*WIDTH + c];
                    end else if (neighbor_count == 3) begin
                        next_q[r*WIDTH + c] = 1;
                    end else begin
                        next_q[r*WIDTH + c] = 0;
                    end
                end
            end
            q <= next_q;
        end
    end

endmodule