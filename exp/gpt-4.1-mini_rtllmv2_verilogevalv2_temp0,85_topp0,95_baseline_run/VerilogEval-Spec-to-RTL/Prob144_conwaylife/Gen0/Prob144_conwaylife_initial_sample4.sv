module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);
    // Grid size
    localparam N = 16;

    // Function to get cell state at (r,c) with wrap-around
    function automatic bit get_cell;
        input [3:0] r;
        input [3:0] c;
        begin
            // Wrap around by modulo N (16)
            // Since 4 bits, wrap by truncation mod 16
            get_cell = q[(r*N + c)];
        end
    endfunction

    // Function to count neighbors of cell at (r,c)
    function automatic [3:0] neighbor_count;
        input [3:0] r;
        input [3:0] c;
        reg [3:0] rr, cc;
        integer dr, dc;
        reg count;
        integer i, j;
        begin
            neighbor_count = 0;
            // Iterate over neighbor offsets (-1,0,1) excluding (0,0)
            for (dr = -1; dr <= 1; dr = dr + 1) begin
                for (dc = -1; dc <= 1; dc = dc + 1) begin
                    if (!(dr == 0 && dc == 0)) begin
                        // Compute wrapped row and col
                        rr = (r + dr) & 4'hF; // modulo 16 by masking lower 4 bits
                        cc = (c + dc) & 4'hF;
                        count = get_cell(rr, cc);
                        neighbor_count = neighbor_count + count;
                    end
                end
            end
        end
    endfunction

    integer r, c;
    reg [255:0] next_q;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Compute next state for all cells
            for (r = 0; r < N; r = r + 1) begin
                for (c = 0; c < N; c = c + 1) begin
                    reg current;
                    reg [3:0] ncount;
                    current = get_cell(r[3:0], c[3:0]);
                    ncount = neighbor_count(r[3:0], c[3:0]);
                    // Apply rules:
                    // 0-1 neighbor: 0
                    // 2 neighbors: no change
                    // 3 neighbors: 1
                    // 4+ neighbors: 0
                    if (ncount <= 1)
                        next_q[r*N + c] = 1'b0;
                    else if (ncount == 2)
                        next_q[r*N + c] = current;
                    else if (ncount == 3)
                        next_q[r*N + c] = 1'b1;
                    else
                        next_q[r*N + c] = 1'b0;
                end
            end
            q <= next_q;
        end
    end
endmodule