module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Parameters for grid size
    localparam N = 16;

    // Function to get the bit value of cell at (r,c) with wrapping
    function automatic bit get_cell;
        input [255:0] state;
        input integer r, c;
        integer rr, cc;
        begin
            rr = (r < 0) ? (N - 1) : (r >= N ? 0 : r);
            cc = (c < 0) ? (N - 1) : (c >= N ? 0 : c);
            get_cell = state[rr*N + cc];
        end
    endfunction

    reg [255:0] next_state;

    integer row, col;

    always @* begin
        // For each cell, count neighbors and apply rules
        for (row = 0; row < N; row = row + 1) begin
            for (col = 0; col < N; col = col + 1) begin
                // sum neighbors
                integer count;
                count = 0;
                count = count + get_cell(q, row-1, col-1);
                count = count + get_cell(q, row-1, col);
                count = count + get_cell(q, row-1, col+1);
                count = count + get_cell(q, row,   col-1);
                count = count + get_cell(q, row,   col+1);
                count = count + get_cell(q, row+1, col-1);
                count = count + get_cell(q, row+1, col);
                count = count + get_cell(q, row+1, col+1);

                // current cell state
                bit cstate = get_cell(q, row, col);

                // apply rules
                if (count <= 1)
                    next_state[row*N + col] = 1'b0;
                else if (count == 2)
                    next_state[row*N + col] = cstate;
                else if (count == 3)
                    next_state[row*N + col] = 1'b1;
                else // count >=4
                    next_state[row*N + col] = 1'b0;
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