module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Pipeline registers
    reg [255:0] q_ff;
    reg [255:0] next_q_stage1, next_q_stage2;
    reg [255:0] changed_cells;

    // Generate logic for each cell
    genvar row, col;
    generate
        for (row = 0; row < 16; row = row + 1) begin : row_loop
            for (col = 0; col < 16; col = col + 1) begin : col_loop
                // Neighbor indices with simplified wrap-around
                wire [3:0] left = (col == 0) ? 15 : (col - 1);
                wire [3:0] right = (col == 15) ? 0 : (col + 1);
                wire [3:0] up = (row == 0) ? 15 : (row - 1);
                wire [3:0] down = (row == 15) ? 0 : (row + 1);

                // Stage 1: Calculate horizontal neighbors (3)
                reg [1:0] horiz_count;
                always @(*) begin
                    horiz_count = q[row*16 + left] + q[row*16 + right];
                end

                // Stage 2: Add vertical and diagonal neighbors (5 more)
                reg [3:0] neighbor_count;
                always @(*) begin
                    neighbor_count = horiz_count + 
                                   q[up*16 + left] + q[up*16 + col] + q[up*16 + right] +
                                   q[down*16 + left] + q[down*16 + col] + q[down*16 + right];
                end

                // Activity detection
                always @(*) begin
                    changed_cells[row*16 + col] = 
                        (neighbor_count == 0 || neighbor_count == 1) ? (q[row*16 + col] != 0) :
                        (neighbor_count == 3) ? (q[row*16 + col] != 1) :
                        (neighbor_count >= 4) ? (q[row*16 + col] != 0) : 0;
                end

                // Optimized state update logic
                always @(*) begin
                    if (!changed_cells[row*16 + col]) begin
                        next_q_stage2[row*16 + col] = q[row*16 + col];
                    end else begin
                        next_q_stage2[row*16 + col] = 
                            (neighbor_count == 2) ? q[row*16 + col] :
                            (neighbor_count == 3) ? 1'b1 : 1'b0;
                    end
                end
            end
        end
    endgenerate

    // Clock gating logic
    wire any_change = |changed_cells;
    wire gated_clk = any_change & clk;

    // Pipelined synchronous update
    always @(posedge clk) begin
        q_ff <= load ? data : next_q_stage2;
    end

    always @(posedge gated_clk) begin
        q <= q_ff;
    end

endmodule