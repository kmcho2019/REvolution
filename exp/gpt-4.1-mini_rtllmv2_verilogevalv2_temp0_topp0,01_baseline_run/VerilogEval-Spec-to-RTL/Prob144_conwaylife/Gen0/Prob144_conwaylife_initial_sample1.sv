module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);
    // Parameters for grid size
    localparam N = 16;

    // Function to get the bit at (r,c) from a 256-bit vector
    function bit get_cell(input [255:0] state, input integer r, input integer c);
        integer rr, cc;
    begin
        rr = (r + N) % N;
        cc = (c + N) % N;
        get_cell = state[rr*16 + cc];
    end
    endfunction

    integer r, c, dr, dc;
    reg [255:0] next_state;
    reg [3:0] neighbor_count; // max 8 neighbors, 4 bits enough

    always @(*) begin
        // Compute next_state combinationally
        for (r = 0; r < N; r = r + 1) begin
            for (c = 0; c < N; c = c + 1) begin
                neighbor_count = 0;
                // Sum neighbors
                for (dr = -1; dr <= 1; dr = dr + 1) begin
                    for (dc = -1; dc <= 1; dc = dc + 1) begin
                        if (!(dr == 0 && dc == 0)) begin
                            neighbor_count = neighbor_count + get_cell(q, r + dr, c + dc);
                        end
                    end
                end
                // Apply rules
                if (neighbor_count <= 1)
                    next_state[r*16 + c] = 1'b0;
                else if (neighbor_count == 2)
                    next_state[r*16 + c] = q[r*16 + c];
                else if (neighbor_count == 3)
                    next_state[r*16 + c] = 1'b1;
                else // neighbor_count >= 4
                    next_state[r*16 + c] = 1'b0;
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