module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Function to get the bit at row,col from a 256-bit vector
    function automatic bit get_cell(input [255:0] state, input int row, input int col);
        int r_mod, c_mod, idx;
        begin
            r_mod = row & 4'hF; // modulo 16
            c_mod = col & 4'hF;
            idx = r_mod*16 + c_mod;
            get_cell = state[idx];
        end
    endfunction

    // Combinational next state logic
    reg [255:0] next_state;
    integer r,c;
    integer nr,nc;
    integer neighbors;
    always @(*) begin
        for (r=0; r<16; r=r+1) begin
            for (c=0; c<16; c=c+1) begin
                // Count neighbors
                neighbors = 0;
                for (nr = r-1; nr <= r+1; nr = nr + 1) begin
                    for (nc = c-1; nc <= c+1; nc = nc + 1) begin
                        if (!(nr == r && nc == c)) begin
                            if (get_cell(q,nr,nc))
                                neighbors = neighbors + 1;
                        end
                    end
                end

                // Apply rules
                if (neighbors <= 1)
                    next_state[r*16 + c] = 1'b0;
                else if (neighbors == 2)
                    next_state[r*16 + c] = q[r*16 + c];
                else if (neighbors == 3)
                    next_state[r*16 + c] = 1'b1;
                else // neighbors >= 4
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