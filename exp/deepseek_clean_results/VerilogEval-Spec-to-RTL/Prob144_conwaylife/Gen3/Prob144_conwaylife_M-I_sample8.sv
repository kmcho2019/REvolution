module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Next state calculation with optimized neighbor counting
    wire [255:0] next_q;
    wire [255:0] cell_stable;  // Indicates cells that won't change
    
    genvar row, col;
    generate
        for (row = 0; row < 16; row = row + 1) begin : row_loop
            for (col = 0; col < 16; col = col + 1) begin : col_loop
                // Calculate neighbor positions with optimized wrap-around
                wire [3:0] row_prev = row - 4'b1;
                wire [3:0] row_next = row + 4'b1;
                wire [3:0] col_prev = col - 4'b1;
                wire [3:0] col_next = col + 4'b1;
                
                // Neighbor count using carry-save structure
                wire [1:0] sum1 = q[row_prev*16 + col_prev] + q[row_prev*16 + col] + 
                                 q[row_prev*16 + col_next];
                wire [1:0] sum2 = q[row*16 + col_prev] + q[row*16 + col_next];
                wire [1:0] sum3 = q[row_next*16 + col_prev] + q[row_next*16 + col] + 
                                 q[row_next*16 + col_next];
                wire [3:0] neighbor_count = sum1 + sum2 + sum3;
                
                // Stability detection for clock gating
                assign cell_stable[row*16 + col] = (neighbor_count == 4'd2);
                
                // Optimized next state calculation
                assign next_q[row*16 + col] = cell_stable[row*16 + col] ? q[row*16 + col] :
                                            (neighbor_count == 4'd3) ? 1'b1 : 1'b0;
            end
        end
    endgenerate

    // Clock-gated sequential update
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Only update cells that will change state
            for (integer i = 0; i < 256; i = i + 1) begin
                if (!cell_stable[i]) begin
                    q[i] <= next_q[i];
                end
            end
        end
    end

endmodule