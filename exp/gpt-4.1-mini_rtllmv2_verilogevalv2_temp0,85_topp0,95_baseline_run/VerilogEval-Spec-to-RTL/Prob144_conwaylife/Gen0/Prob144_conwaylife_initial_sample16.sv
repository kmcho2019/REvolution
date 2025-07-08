module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Grid dimensions
    localparam N = 16;

    // Function to compute 1D index from row and column, with wrap-around
    function automatic [7:0] idx(input [3:0] r, input [3:0] c);
        begin
            idx = (r & 4'hF)*N + (c & 4'hF);
        end
    endfunction

    integer r, c, dr, dc;
    reg [3:0] nr, nc;
    reg [3:0] neighbors_count;
    reg current_cell;

    reg [255:0] next_state;

    always @* begin
        // Compute next state combinationally
        for (r = 0; r < N; r = r + 1) begin
            for (c = 0; c < N; c = c + 1) begin
                neighbors_count = 0;
                current_cell = q[idx(r,c)];
                // Sum neighbors, 8 directions
                for (dr = -1; dr <= 1; dr = dr + 1) begin
                    for (dc = -1; dc <= 1; dc = dc + 1) begin
                        if (!(dr == 0 && dc == 0)) begin
                            nr = (r + dr) & 4'hF; // wrap around 0..15
                            nc = (c + dc) & 4'hF; // wrap around 0..15
                            neighbors_count = neighbors_count + q[idx(nr,nc)];
                        end
                    end
                end
                // Apply rules
                if (neighbors_count <= 1)
                    next_state[idx(r,c)] = 1'b0;
                else if (neighbors_count == 2)
                    next_state[idx(r,c)] = current_cell;
                else if (neighbors_count == 3)
                    next_state[idx(r,c)] = 1'b1;
                else // neighbors_count >= 4
                    next_state[idx(r,c)] = 1'b0;
            end
        end
    end

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end

endmodule