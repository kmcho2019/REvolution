module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);
    localparam N = 16;

    // Internal next state register
    reg [255:0] next_q;

    // Helper function to get bit at row,col from q with wrap-around
    function automatic bit get_cell;
        input [255:0] state;
        input integer row;
        input integer col;
        integer r, c;
        begin
            r = (row + N) % N;
            c = (col + N) % N;
            get_cell = state[r*16 + c];
        end
    endfunction

    integer r, c, dr, dc;
    integer neighbor_count;

    always @* begin
        // Compute next state combinationally
        for (r = 0; r < N; r = r + 1) begin
            for (c = 0; c < N; c = c + 1) begin
                neighbor_count = 0;
                // Count neighbors in 3x3 area excluding center
                for (dr = -1; dr <= 1; dr = dr + 1) begin
                    for (dc = -1; dc <= 1; dc = dc + 1) begin
                        if (!(dr == 0 && dc == 0)) begin
                            if (get_cell(q, r + dr, c + dc))
                                neighbor_count = neighbor_count + 1;
                        end
                    end
                end

                // Apply rules
                if (neighbor_count <= 1)
                    next_q[r*16 + c] = 1'b0;
                else if (neighbor_count == 2)
                    next_q[r*16 + c] = q[r*16 + c];
                else if (neighbor_count == 3)
                    next_q[r*16 + c] = 1'b1;
                else // neighbor_count >= 4
                    next_q[r*16 + c] = 1'b0;
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