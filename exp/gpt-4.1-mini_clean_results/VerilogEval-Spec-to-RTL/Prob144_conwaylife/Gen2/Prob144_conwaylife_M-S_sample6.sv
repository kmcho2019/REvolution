module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);
    localparam N = 16;
    integer r, c, rr, cc;
    reg [3:0] nr, nc;
    reg [3:0] row, col;
    reg [3:0] neighbor_count;
    reg [255:0] next_q;

    always @(*) begin
        for (r = 0; r < N; r = r + 1) begin
            for (c = 0; c < N; c = c + 1) begin
                neighbor_count = 0;
                for (rr = -1; rr <= 1; rr = rr + 1) begin
                    for (cc = -1; cc <= 1; cc = cc + 1) begin
                        if (!(rr == 0 && cc == 0)) begin
                            nr = (r + rr) & 4'hF; // wrap with mask (mod 16)
                            nc = (c + cc) & 4'hF;
                            neighbor_count = neighbor_count + q[(nr << 4) + nc];
                        end
                    end
                end
                row = r[3:0];
                col = c[3:0];
                // Apply rules directly
                if (neighbor_count <= 1)
                    next_q[(row << 4) + col] = 1'b0;
                else if (neighbor_count == 2)
                    next_q[(row << 4) + col] = q[(row << 4) + col];
                else if (neighbor_count == 3)
                    next_q[(row << 4) + col] = 1'b1;
                else
                    next_q[(row << 4) + col] = 1'b0;
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