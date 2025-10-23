module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    localparam SIZE = 16;
    localparam MASK = 4'hF;

    // Neighbor offset arrays (8 neighbors)
    localparam signed [2:0] drow [0:7] = '{-1, -1, -1, 0, 0, 1, 1, 1};
    localparam signed [2:0] dcol [0:7] = '{-1, 0, 1, -1, 1, -1, 0, 1};

    reg [255:0] next_q;

    genvar r, c, n;

    wire [3:0] nr [0:7];
    wire [3:0] nc [0:7];
    wire [7:0] neighbor_bits;
    wire [3:0] neighbor_count;

    // Generate block to compute next state combinationally
    generate
        for (r = 0; r < SIZE; r = r + 1) begin : ROW
            for (c = 0; c < SIZE; c = c + 1) begin : COL
                // Compute neighbor coordinates with wrap-around
                wire [3:0] row = r[3:0];
                wire [3:0] col = c[3:0];

                // Compute neighbors' positions and bits
                for (n = 0; n < 8; n = n + 1) begin : NEIGH
                    wire signed [4:0] rr = $signed(row) + $signed(drow[n]);
                    wire signed [4:0] cc = $signed(col) + $signed(dcol[n]);
                    assign nr[n] = rr[3:0] & MASK;  // wrap modulo 16
                    assign nc[n] = cc[3:0] & MASK;
                end

                // Collect neighbor bits
                assign neighbor_bits = {
                    q[{nr[7], nc[7]}],
                    q[{nr[6], nc[6]}],
                    q[{nr[5], nc[5]}],
                    q[{nr[4], nc[4]}],
                    q[{nr[3], nc[3]}],
                    q[{nr[2], nc[2]}],
                    q[{nr[1], nc[1]}],
                    q[{nr[0], nc[0]}]
                };

                // Sum neighbors bits
                assign neighbor_count = neighbor_bits[0] + neighbor_bits[1] + neighbor_bits[2] +
                                        neighbor_bits[3] + neighbor_bits[4] + neighbor_bits[5] +
                                        neighbor_bits[6] + neighbor_bits[7];

                // Compute current cell index
                localparam integer idx = r * SIZE + c;

                always @(*) begin
                    case (neighbor_count)
                        4'd2: next_q[idx] = q[idx];
                        4'd3: next_q[idx] = 1'b1;
                        default: next_q[idx] = 1'b0;
                    endcase
                end
            end
        end
    endgenerate

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule