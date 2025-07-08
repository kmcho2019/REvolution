module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Parameter for grid size
    localparam SIZE = 16;

    // Function to get the bit at position (r,c) with wrap-around
    function bit get_cell;
        input [255:0] state;
        input integer r;
        input integer c;
        integer rr, cc;
        begin
            rr = (r + SIZE) % SIZE;
            cc = (c + SIZE) % SIZE;
            get_cell = state[rr*SIZE + cc];
        end
    endfunction

    integer r, c;
    reg [3:0] neighbor_count;
    reg [255:0] next_q;

    always @(*) begin
        for (r = 0; r < SIZE; r = r + 1) begin
            for (c = 0; c < SIZE; c = c + 1) begin
                // Count neighbors
                neighbor_count = 0;
                neighbor_count = neighbor_count + get_cell(q, r-1, c-1);
                neighbor_count = neighbor_count + get_cell(q, r-1, c);
                neighbor_count = neighbor_count + get_cell(q, r-1, c+1);
                neighbor_count = neighbor_count + get_cell(q, r, c-1);
                neighbor_count = neighbor_count + get_cell(q, r, c+1);
                neighbor_count = neighbor_count + get_cell(q, r+1, c-1);
                neighbor_count = neighbor_count + get_cell(q, r+1, c);
                neighbor_count = neighbor_count + get_cell(q, r+1, c+1);

                // Apply rules
                if (neighbor_count <= 1)
                    next_q[r*SIZE + c] = 1'b0;
                else if (neighbor_count == 2)
                    next_q[r*SIZE + c] = q[r*SIZE + c];
                else if (neighbor_count == 3)
                    next_q[r*SIZE + c] = 1'b1;
                else // 4 or more neighbors
                    next_q[r*SIZE + c] = 1'b0;
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