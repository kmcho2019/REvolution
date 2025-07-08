module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);
    // parameters
    localparam N = 16;
    integer r, c, dr, dc;
    
    reg [255:0] next_q;
    
    // helper function: get cell at (row, col)
    function bit get_cell(input [255:0] board, input integer row, input integer col);
        integer rr, cc;
        begin
            // wrap around using modulo 16
            rr = (row + N) % N;
            cc = (col + N) % N;
            get_cell = board[rr*16 + cc];
        end
    endfunction
    
    // combinational logic for next state
    always @(*) begin
        for (r = 0; r < N; r = r + 1) begin
            for (c = 0; c < N; c = c + 1) begin
                integer ncount;
                bit current_cell;
                ncount = 0;
                current_cell = get_cell(q, r, c);
                
                // sum neighbors
                for (dr = -1; dr <= 1; dr = dr + 1) begin
                    for (dc = -1; dc <= 1; dc = dc + 1) begin
                        if (!(dr == 0 && dc == 0)) begin
                            if (get_cell(q, r + dr, c + dc)) ncount = ncount + 1;
                        end
                    end
                end
                
                // apply rules
                if (ncount <= 1)
                    next_q[r*16 + c] = 0;
                else if (ncount == 2)
                    next_q[r*16 + c] = current_cell;
                else if (ncount == 3)
                    next_q[r*16 + c] = 1;
                else
                    next_q[r*16 + c] = 0;
            end
        end
    end
    
    // sequential logic: update q
    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end
endmodule