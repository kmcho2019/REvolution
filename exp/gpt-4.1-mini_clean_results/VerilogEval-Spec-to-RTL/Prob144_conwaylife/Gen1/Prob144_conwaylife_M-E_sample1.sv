module TopModule (
    input              clk,
    input              load,
    input      [255:0] data,
    output reg [255:0] q
);
    // Next state computed combinationally
    wire [255:0] next_q;

    genvar idx;
    generate
        for (idx = 0; idx < 256; idx = idx + 1) begin : gen_cells
            // Calculate 2D coordinates from idx
            // row = idx / 16, col = idx % 16
            // neighbors coordinates wrap around mod 16
            // neighbor offsets: (-1,-1), (-1,0), (-1,1), (0,-1), (0,1), (1,-1), (1,0), (1,1)

            // Compute each neighbor's flat index with wrap-around
            // Use functions inside generate block via localparam for clarity

            localparam integer row = idx / 16;
            localparam integer col = idx % 16;

            // Compute neighbor indices with wrap-around
            localparam integer r0 = (row + 16 - 1) % 16; // row-1 wrapped
            localparam integer r1 = row;
            localparam integer r2 = (row + 1) % 16;

            localparam integer c0 = (col + 16 - 1) % 16; // col-1 wrapped
            localparam integer c1 = col;
            localparam integer c2 = (col + 1) % 16;

            // neighbor flat indices
            localparam integer n0 = r0*16 + c0;
            localparam integer n1 = r0*16 + c1;
            localparam integer n2 = r0*16 + c2;
            localparam integer n3 = r1*16 + c0;
            localparam integer n4 = r1*16 + c2;
            localparam integer n5 = r2*16 + c0;
            localparam integer n6 = r2*16 + c1;
            localparam integer n7 = r2*16 + c2;

            // Sum neighbors bits
            wire [3:0] neighbor_count;
            assign neighbor_count = q[n0] + q[n1] + q[n2] + q[n3] + q[n4] + q[n5] + q[n6] + q[n7];

            // Apply rules
            // 0 or 1 neighbors -> 0
            // 2 neighbors -> unchanged
            // 3 neighbors -> 1
            // 4+ neighbors -> 0
            wire current_cell = q[idx];
            wire next_cell;

            assign next_cell = (neighbor_count == 2) ? current_cell :
                               (neighbor_count == 3) ? 1'b1 : 1'b0;

            assign next_q[idx] = next_cell;
        end
    endgenerate

    // Sequential update with synchronous load
    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule