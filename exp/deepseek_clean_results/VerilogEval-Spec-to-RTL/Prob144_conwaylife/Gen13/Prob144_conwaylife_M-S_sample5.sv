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
                // Calculate neighbor positions with wrap-around
                wire [3:0] row_prev = (i == 0) ? 15 : (i - 1);
                wire [3:0] row_next = (i == 15) ? 0 : (i + 1);
                wire [3:0] col_prev = (j == 0) ? 15 : (j - 1);
                wire [3:0] col_next = (j == 15) ? 0 : (j + 1);
                
                // Sum all 8 neighbors
                wire [3:0] neighbor_count = 
                    q[row_prev*16 + col_prev] + q[row_prev*16 + j] + q[row_prev*16 + col_next] +
                    q[i*16 + col_prev] + q[i*16 + col_next] +
                    q[row_next*16 + col_prev] + q[row_next*16 + j] + q[row_next*16 + col_next];
                
                // Next state calculation
                assign next_q[i*16 + j] = (neighbor_count == 3) ? 1'b1 :
                                         (neighbor_count == 2) ? q[i*16 + j] :
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