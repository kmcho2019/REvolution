module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);
    localparam N = 16;

    // Helper function: modular index with wrap-around for 16
    function automatic [3:0] wrap_idx(input integer idx);
        wrap_idx = (idx < 0) ? idx + N : (idx >= N ? idx - N : idx);
    endfunction

    integer i;
    reg [255:0] next_q;

    always @(*) begin
        for (i = 0; i < 256; i = i + 1) begin
            // Convert linear index to row,col
            integer r = i / N;
            integer c = i % N;

            // Count neighbors
            integer nr, nc, count;
            count = 0;
            for (nr = r - 1; nr <= r + 1; nr = nr + 1) begin
                for (nc = c - 1; nc <= c + 1; nc = nc + 1) begin
                    if (!(nr == r && nc == c)) begin
                        integer rr = wrap_idx(nr);
                        integer cc = wrap_idx(nc);
                        count = count + q[rr * N + cc];
                    end
                end
            end

            // Apply rules
            if (count <= 1)
                next_q[i] = 1'b0;
            else if (count == 2)
                next_q[i] = q[i];
            else if (count == 3)
                next_q[i] = 1'b1;
            else
                next_q[i] = 1'b0;
        end
    end

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule