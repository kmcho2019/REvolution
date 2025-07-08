module TopModule(
    input  clk,
    input  load,
    input  [255:0] data,
    output reg [255:0] q
);
    localparam N = 16;

    // Function to get bit at row,col from vector q
    function bit get_cell;
        input [255:0] state;
        input integer r, c;
        begin
            r = r % N; if (r < 0) r = r + N;
            c = c % N; if (c < 0) c = c + N;
            get_cell = state[r*16 + c];
        end
    endfunction

    integer r,c;
    reg [255:0] next_q;

    always @(*) begin
        // If loading, next_q = data
        if (load) begin
            next_q = data;
        end else begin
            // Compute next state for each cell
            next_q = 256'b0;
            for (r = 0; r < N; r = r + 1) begin
                for (c = 0; c < N; c = c + 1) begin
                    integer nr, nc, count;
                    count = 0;
                    // Sum neighbors (8 neighbors)
                    // neighbors: (r-1,c-1), (r-1,c), (r-1,c+1)
                    //            (r, c-1),           (r, c+1)
                    //            (r+1,c-1), (r+1,c), (r+1,c+1)
                    for (nr = r - 1; nr <= r + 1; nr = nr + 1) begin
                        for (nc = c - 1; nc <= c + 1; nc = nc + 1) begin
                            if (!(nr == r && nc == c)) begin
                                count = count + get_cell(q, nr, nc);
                            end
                        end
                    end
                    bit current = get_cell(q, r, c);
                    // Apply rules
                    // (1) 0-1 neighbor: 0
                    // (2) 2 neighbors: unchanged
                    // (3) 3 neighbors: 1
                    // (4) 4+ neighbors: 0
                    bit next_state;
                    if (count <= 1)
                        next_state = 1'b0;
                    else if (count == 2)
                        next_state = current;
                    else if (count == 3)
                        next_state = 1'b1;
                    else
                        next_state = 1'b0;
                    next_q[r*16 + c] = next_state;
                end
            end
        end
    end

    always @(posedge clk) begin
        q <= next_q;
    end

endmodule