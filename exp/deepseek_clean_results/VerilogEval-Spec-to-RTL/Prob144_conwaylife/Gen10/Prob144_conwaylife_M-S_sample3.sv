module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    wire [255:0] next_q;

    genvar i, j;
    generate
        for (i = 0; i < 16; i = i + 1) begin : row_gen
            for (j = 0; j < 16; j = j + 1) begin : col_gen
                localparam idx = i*16 + j;
                
                // Calculate neighbor indices with wrap-around
                wire [3:0] row_prev = (i == 0) ? 15 : (i - 1);
                wire [3:0] row_next = (i == 15) ? 0 : (i + 1);
                wire [3:0] col_prev = (j == 0) ? 15 : (j - 1);
                wire [3:0] col_next = (j == 15) ? 0 : (j + 1);
                
                // Get all neighbor values
                wire n0 = q[row_prev*16 + col_prev]; // top-left
                wire n1 = q[row_prev*16 + j];       // top
                wire n2 = q[row_prev*16 + col_next]; // top-right
                wire n3 = q[i*16 + col_prev];        // left
                wire n4 = q[i*16 + col_next];        // right
                wire n5 = q[row_next*16 + col_prev]; // bottom-left
                wire n6 = q[row_next*16 + j];        // bottom
                wire n7 = q[row_next*16 + col_next]; // bottom-right
                
                // Count live neighbors
                wire [3:0] neighbor_count = n0 + n1 + n2 + n3 + n4 + n5 + n6 + n7;
                
                // Next state calculation
                assign next_q[idx] = (neighbor_count == 3) ? 1'b1 :
                                    (neighbor_count == 2) ? q[idx] :
                                    1'b0;
            end
        end
    endgenerate

    // Simple synchronous update
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule