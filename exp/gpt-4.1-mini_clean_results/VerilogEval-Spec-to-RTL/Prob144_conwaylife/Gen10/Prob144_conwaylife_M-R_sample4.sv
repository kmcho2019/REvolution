module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    localparam SIZE = 16;
    localparam MASK = SIZE - 1;  // 15

    // Function to perform modulo SIZE indexing with wrap-around for indices 0..15
    function automatic [3:0] wrap_index(input int idx);
        begin
            if (idx < 0)
                wrap_index = idx + SIZE;
            else if (idx >= SIZE)
                wrap_index = idx - SIZE;
            else
                wrap_index = idx[3:0];
        end
    endfunction

    reg [255:0] next_q;

    integer r, c, dr, dc;
    integer nr, nc;
    reg [3:0] count;

    // Combinational logic to compute next_q from current q
    always @* begin
        next_q = 256'b0;
        for (r = 0; r < SIZE; r = r + 1) begin
            for (c = 0; c < SIZE; c = c + 1) begin
                count = 0;
                // Check 8 neighbors with wrap-around
                for (dr = -1; dr <= 1; dr = dr + 1) begin
                    for (dc = -1; dc <= 1; dc = dc + 1) begin
                        if (!(dr == 0 && dc == 0)) begin
                            nr = wrap_index(r + dr);
                            nc = wrap_index(c + dc);
                            count = count + q[nr*SIZE + nc];
                        end
                    end
                end
                // Apply the rules:
                // 0-1 neighbor: 0
                // 2 neighbors: no change
                // 3 neighbors: 1
                // 4+ neighbors: 0
                if (count == 3)
                    next_q[r*SIZE + c] = 1'b1;
                else if (count == 2)
                    next_q[r*SIZE + c] = q[r*SIZE + c];
                else
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