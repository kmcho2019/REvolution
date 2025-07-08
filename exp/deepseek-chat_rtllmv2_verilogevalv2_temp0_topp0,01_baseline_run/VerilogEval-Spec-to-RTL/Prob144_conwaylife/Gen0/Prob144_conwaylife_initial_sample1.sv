module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    wire [255:0] next_q;
    genvar i, j;

    generate
        for (i = 0; i < 16; i = i + 1) begin : row
            for (j = 0; j < 16; j = j + 1) begin : col
                // Calculate neighbor indices with wrap-around
                wire [3:0] row_above = (i == 0) ? 15 : (i - 1);
                wire [3:0] row_below = (i == 15) ? 0 : (i + 1);
                wire [3:0] col_left = (j == 0) ? 15 : (j - 1);
                wire [3:0] col_right = (j == 15) ? 0 : (j + 1);

                // Get neighbor values
                wire nw = q[{row_above, col_left}];
                wire n  = q[{row_above, j}];
                wire ne = q[{row_above, col_right}];
                wire w  = q[{i, col_left}];
                wire e  = q[{i, col_right}];
                wire sw = q[{row_below, col_left}];
                wire s  = q[{row_below, j}];
                wire se = q[{row_below, col_right}];

                // Count live neighbors
                wire [3:0] neighbor_count = nw + n + ne + w + e + sw + s + se;

                // Apply game rules
                assign next_q[{i,j}] = (neighbor_count == 3) ? 1'b1 :
                                      (neighbor_count == 2) ? q[{i,j}] :
                                      1'b0;
            end
        end
    endgenerate

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule