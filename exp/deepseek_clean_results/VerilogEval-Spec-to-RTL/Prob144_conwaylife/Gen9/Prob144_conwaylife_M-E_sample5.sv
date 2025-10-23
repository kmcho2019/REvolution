module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Next state computation
    wire [255:0] next_q;
    
    // Neighbor count for each cell (4 bits per cell)
    reg [3:0] neighbor_count [0:255];
    
    // State prediction for all possible neighbor counts
    wire [255:0] next_state [0:8];
    generate
        for (genvar n = 0; n <= 8; n = n + 1) begin : state_pred
            assign next_state[n] = (n == 3) ? 256'hFFFFFFFF :
                                  (n == 2) ? q :
                                  256'h0;
        end
    endgenerate

    // Parallel neighbor counting
    always @(*) begin
        for (integer i = 0; i < 256; i = i + 1) begin
            // Get row and column indices
            integer row = i / 16;
            integer col = i % 16;
            
            // Calculate neighbor positions with wrap-around
            integer row_m1 = (row == 0) ? 15 : (row - 1);
            integer row_p1 = (row == 15) ? 0 : (row + 1);
            integer col_m1 = (col == 0) ? 15 : (col - 1);
            integer col_p1 = (col == 15) ? 0 : (col + 1);
            
            // Compute neighbor indices
            integer n0 = row_m1 * 16 + col_m1;
            integer n1 = row_m1 * 16 + col;
            integer n2 = row_m1 * 16 + col_p1;
            integer n3 = row * 16 + col_m1;
            integer n4 = row * 16 + col_p1;
            integer n5 = row_p1 * 16 + col_m1;
            integer n6 = row_p1 * 16 + col;
            integer n7 = row_p1 * 16 + col_p1;
            
            // Count live neighbors
            neighbor_count[i] = q[n0] + q[n1] + q[n2] + q[n3] + 
                              q[n4] + q[n5] + q[n6] + q[n7];
        end
    end

    // Select next state based on neighbor count
    generate
        for (genvar i = 0; i < 256; i = i + 1) begin : state_sel
            assign next_q[i] = next_state[neighbor_count[i]][i];
        end
    endgenerate

    // State update with load priority
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule