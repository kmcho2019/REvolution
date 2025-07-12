module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    localparam N = 16;

    // Wrap-around function (mod 16)
    function [3:0] wrap;
        input integer x;
        begin
            if (x < 0)
                wrap = x + N;
            else if (x >= N)
                wrap = x - N;
            else
                wrap = x[3:0];
        end
    endfunction

    integer r, c, dr, dc;
    reg [3:0] nr, nc; // neighbor row and column after wrap
    reg [3:0] count;
    reg cellstate;
    reg [255:0] next_state;

    always @* begin
        // Compute next_state combinationally from current q
        for (r = 0; r < N; r = r + 1) begin
            for (c = 0; c < N; c = c + 1) begin
                count = 0;
                for (dr = -1; dr <= 1; dr = dr + 1) begin
                    for (dc = -1; dc <= 1; dc = dc + 1) begin
                        if (!(dr == 0 && dc == 0)) begin
                            nr = wrap(r + dr);
                            nc = wrap(c + dc);
                            if (q[nr*16 + nc])
                                count = count + 1;
                        end
                    end
                end
                cellstate = q[r*16 + c];
                // Apply rules:
                // 0-1 neighbors -> 0
                // 2 neighbors -> same state
                // 3 neighbors -> 1
                // 4+ neighbors -> 0
                if (count <= 1)
                    next_state[r*16 + c] = 1'b0;
                else if (count == 2)
                    next_state[r*16 + c] = cellstate;
                else if (count == 3)
                    next_state[r*16 + c] = 1'b1;
                else
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