module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);
    // 16x16 grid
    localparam N = 16;

    // Extract cell at (r,c) from a 256-bit vector
    function bit get_cell(input [255:0] state, input int r, input int c);
        int rr, cc;
        begin
            rr = (r + N) % N;
            cc = (c + N) % N;
            get_cell = state[rr*16 + cc];
        end
    endfunction

    // Compute neighbors sum for cell (r,c)
    function [3:0] neighbor_count(input [255:0] state, input int r, input int c);
        int rr, cc;
        begin
            neighbor_count = 0;
            // loop over neighbors
            for (rr = r-1; rr <= r+1; rr = rr+1) begin
                for (cc = c-1; cc <= c+1; cc = cc+1) begin
                    if (!(rr == r && cc == c)) begin
                        neighbor_count = neighbor_count + get_cell(state, rr, cc);
                    end
                end
            end
        end
    endfunction

    // Compute next state combinationally
    reg [255:0] next_state;
    integer r,c;
    reg current_cell;
    reg [3:0] ncount;

    always @* begin
        for (r=0; r<N; r=r+1) begin
            for (c=0; c<N; c=c+1) begin
                current_cell = get_cell(q, r, c);
                ncount = neighbor_count(q, r, c);
                if (ncount <= 1)
                    next_state[r*16 + c] = 1'b0;
                else if (ncount == 2)
                    next_state[r*16 + c] = current_cell;
                else if (ncount == 3)
                    next_state[r*16 + c] = 1'b1;
                else // ncount >=4
                    next_state[r*16 + c] = 1'b0;
            end
        end
    end

    // Sequential logic
    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end

endmodule