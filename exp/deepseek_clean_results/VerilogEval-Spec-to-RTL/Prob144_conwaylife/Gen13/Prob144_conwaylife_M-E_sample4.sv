module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Stage 1: Horizontal neighbor calculation
    reg [255:0] q_reg;
    wire [255:0] left_neighbors, right_neighbors;
    wire [255:0] self_col;
    
    // Circular shifts for horizontal neighbors
    assign left_neighbors = {q[15:0], q[255:16]};  // Shift left with wrap-around
    assign right_neighbors = {q[239:0], q[255:240]}; // Shift right with wrap-around
    assign self_col = q;  // Current column
    
    // Stage 2: Vertical neighbor calculation
    wire [255:0] top_row, bottom_row;
    reg [255:0] horizontal_counts;
    
    // Circular shifts for vertical neighbors (by 16 bits)
    assign top_row = {q[15:0], q[255:16]};    // Shift up one row
    assign bottom_row = {q[239:0], q[255:240]}; // Shift down one row
    
    // Count horizontal neighbors (left + right + self)
    always @(*) begin
        for (integer i = 0; i < 256; i = i + 1) begin
            horizontal_counts[i] = left_neighbors[i] + right_neighbors[i] + self_col[i];
        end
    end
    
    // Final neighbor count calculation
    wire [255:0] next_q;
    wire [255:0] cell_changes;
    
    genvar i;
    generate
        for (i = 0; i < 256; i = i + 1) begin : cell_logic
            // Count vertical neighbors (top + bottom)
            wire [1:0] vertical_count = top_row[i] + bottom_row[i];
            
            // Total neighbor count (excluding self)
            wire [3:0] neighbor_count = horizontal_counts[i] + vertical_count - q[i];
            
            // Early termination for dead cells with no neighbors
            wire skip_calc = (q[i] == 0) && (neighbor_count == 0);
            
            // Next state calculation
            wire next_state = skip_calc ? 1'b0 :
                             (neighbor_count == 3) ? 1'b1 :
                             (neighbor_count == 2) ? q[i] :
                             1'b0;
            
            assign next_q[i] = next_state;
            assign cell_changes[i] = (next_state != q[i]) && !skip_calc;
        end
    endgenerate

    // Pipelined update with two-stage register
    always @(posedge clk) begin
        q_reg <= q;  // Pipeline stage
        
        if (load) begin
            q <= data;
        end else begin
            // Update only cells that will change state
            for (integer i = 0; i < 256; i = i + 1) begin
                if (cell_changes[i]) begin
                    q[i] <= next_q[i];
                end
            end
        end
    end

endmodule