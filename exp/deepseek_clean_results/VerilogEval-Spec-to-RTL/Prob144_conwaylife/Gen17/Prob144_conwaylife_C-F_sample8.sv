module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    wire [255:0] next_q;

    genvar i;
    generate
        for (i = 0; i < 256; i = i + 1) begin : cell_logic
            // Pre-compute all neighbor indices at compile time
            localparam row = i / 16;
            localparam col = i % 16;
            
            localparam row_prev = (row == 0) ? 15 : (row - 1);
            localparam row_next = (row == 15) ? 0 : (row + 1);
            localparam col_prev = (col == 0) ? 15 : (col - 1);
            localparam col_next = (col == 15) ? 0 : (col + 1);
            
            localparam n0 = row_prev*16 + col_prev; // top-left
            localparam n1 = row_prev*16 + col;      // top
            localparam n2 = row_prev*16 + col_next; // top-right
            localparam n3 = row*16 + col_prev;      // left
            localparam n4 = row*16 + col_next;       // right
            localparam n5 = row_next*16 + col_prev;  // bottom-left
            localparam n6 = row_next*16 + col;       // bottom
            localparam n7 = row_next*16 + col_next; // bottom-right

            // Optimized neighbor counting with carry-save
            wire [1:0] sum_top = {1'b0, q[n0]} + {1'b0, q[n1]} + {1'b0, q[n2]};
            wire [1:0] sum_mid = {1'b0, q[n3]} + {1'b0, q[n4]};
            wire [1:0] sum_bot = {1'b0, q[n5]} + {1'b0, q[n6]} + {1'b0, q[n7]};
            
            wire [2:0] neighbor_count = sum_top + sum_mid + sum_bot;

            // Direct next-state calculation
            assign next_q[i] = (neighbor_count == 3) ? 1'b1 :
                              (neighbor_count == 2) ? q[i] :
                              1'b0;
        end
    endgenerate

    // Efficient sequential update
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Update all cells in parallel (optimized synthesis will handle stability)
            q <= next_q;
        end
    end

endmodule