module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    localparam SIZE = 16;

    integer i, j, di, dj;
    reg [3:0] r, c, nr, nc;
    reg [7:0] idx, nidx;
    reg [3:0] neighbors;
    reg [255:0] next_q;

    // Helper to get index from row and column (both 4-bit)
    function [7:0] index;
        input [3:0] row, col;
        begin
            index = (row << 4) + col; // row*16 + col
        end
    endfunction

    always @(*) begin
        if (load) begin
            next_q = data;
        end else begin
            next_q = 0;
            for (i = 0; i < SIZE; i = i + 1) begin
                for (j = 0; j < SIZE; j = j + 1) begin
                    neighbors = 0;
                    for (di = -1; di <= 1; di = di + 1) begin
                        for (dj = -1; dj <= 1; dj = dj + 1) begin
                            if (!(di == 0 && dj == 0)) begin
                                nr = (i + di) & 4'hF; // wrap around 0..15
                                nc = (j + dj) & 4'hF;
                                nidx = index(nr, nc);
                                neighbors = neighbors + q[nidx];
                            end
                        end
                    end
                    idx = index(i[3:0], j[3:0]);
                    case (neighbors)
                        4, 5, 6, 7, 8: next_q[idx] = 1'b0;      // 4+ neighbors: dies
                        3: next_q[idx] = 1'b1;                   // 3 neighbors: becomes alive
                        2: next_q[idx] = q[idx];                  // 2 neighbors: stays same
                        default: next_q[idx] = 1'b0;              // 0 or 1 neighbor: dies
                    endcase
                end
            end
        end
    end

    always @(posedge clk) begin
        q <= next_q;
    end

endmodule