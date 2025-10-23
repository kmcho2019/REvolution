module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);
    localparam N = 16;

    // Wrap index modulo 16 using bitmask (since 16 = 2^4)
    function [3:0] wrap_idx(input integer idx);
        begin
            wrap_idx = idx[3:0]; // automatically takes modulo 16
        end
    endfunction

    integer r, c, rr, cc;
    reg [3:0] nr, nc;
    reg [8:0] neighbor_count;
    reg cell_state;
    reg [255:0] next_q;

    always @(*) begin
        next_q = q;
        for (r = 0; r < N; r = r + 1) begin
            for (c = 0; c < N; c = c + 1) begin
                neighbor_count = 0;
                for (rr = r - 1; rr <= r + 1; rr = rr + 1) begin
                    for (cc = c - 1; cc <= c + 1; cc = cc + 1) begin
                        if (!(rr == r && cc == c)) begin
                            nr = wrap_idx(rr);
                            nc = wrap_idx(cc);
                            neighbor_count = neighbor_count + q[(nr << 4) + nc];
                        end
                    end
                end
                cell_state = q[(r << 4) + c];
                if (neighbor_count <= 1)
                    next_q[(r << 4) + c] = 1'b0;
                else if (neighbor_count == 2)
                    next_q[(r << 4) + c] = cell_state;
                else if (neighbor_count == 3)
                    next_q[(r << 4) + c] = 1'b1;
                else
                    next_q[(r << 4) + c] = 1'b0;
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