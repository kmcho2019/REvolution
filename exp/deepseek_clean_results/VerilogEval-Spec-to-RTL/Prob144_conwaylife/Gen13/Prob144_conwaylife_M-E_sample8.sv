module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Phase 1: Neighbor count computation
    reg [3:0] neighbor_counts [0:255]; // 4-bit counters for each cell
    
    // Precompute all neighbor counts in parallel
    always @(*) begin
        for (integer i = 0; i < 256; i = i + 1) begin
            // Calculate row and column with wrap-around
            integer row = i / 16;
            integer col = i % 16;
            
            // Compute neighbor positions with wrap-around
            integer row_p = (row == 0) ? 15 : row - 1;
            integer row_n = (row == 15) ? 0 : row + 1;
            integer col_p = (col == 0) ? 15 : col - 1;
            integer col_n = (col == 15) ? 0 : col + 1;
            
            // Get neighbor indices
            integer n0 = row_p * 16 + col_p; // top-left
            integer n1 = row_p * 16 + col;   // top
            integer n2 = row_p * 16 + col_n; // top-right
            integer n3 = row * 16 + col_p;   // left
            integer n4 = row * 16 + col_n;   // right
            integer n5 = row_n * 16 + col_p; // bottom-left
            integer n6 = row_n * 16 + col;   // bottom
            integer n7 = row_n * 16 + col_n; // bottom-right
            
            // Pipelined neighbor count calculation
            reg [1:0] stage1 = q[n0] + q[n1] + q[n2];
            reg [1:0] stage2 = q[n3] + q[n4];
            reg [1:0] stage3 = q[n5] + q[n6] + q[n7];
            neighbor_counts[i] = stage1 + stage2 + stage3;
        end
    end

    // Phase 2: State update with speculative execution
    reg [255:0] next_q;
    always @(*) begin
        for (integer i = 0; i < 256; i = i + 1) begin
            case (neighbor_counts[i])
                4'd0, 4'd1: next_q[i] = 1'b0; // Die from underpopulation
                4'd2: next_q[i] = q[i];       // Stay the same
                4'd3: next_q[i] = 1'b1;        // Reproduce or survive
                default: next_q[i] = 1'b0;     // Die from overpopulation
            endcase
        end
    end

    // Sequential update with load priority
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule