module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);
    localparam N = 16;

    // Function for modular wrap-around indexing [0..N-1]
    function integer wrap;
        input integer idx;
        begin
            if (idx < 0)
                wrap = idx + N;
            else if (idx >= N)
                wrap = idx - N;
            else
                wrap = idx;
        end
    endfunction

    integer r, c, dr, dc;
    reg [255:0] next_state;
    reg [3:0] neighbors_sum;
    reg cell_state;

    always @* begin
        for (r = 0; r < N; r = r + 1) begin
            for (c = 0; c < N; c = c + 1) begin
                neighbors_sum = 0;
                // Sum 8 neighbors with wrap
                for (dr = -1; dr <= 1; dr = dr + 1) begin
                    for (dc = -1; dc <= 1; dc = dc + 1) begin
                        if (!(dr == 0 && dc == 0)) begin
                            neighbors_sum = neighbors_sum + q[wrap(r+dr)*N + wrap(c+dc)];
                        end
                    end
                end
                cell_state = q[r*N + c];
                // Apply rules
                if (neighbors_sum <= 1)
                    next_state[r*N + c] = 1'b0;
                else if (neighbors_sum == 2)
                    next_state[r*N + c] = cell_state;
                else if (neighbors_sum == 3)
                    next_state[r*N + c] = 1'b1;
                else
                    next_state[r*N + c] = 1'b0;
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