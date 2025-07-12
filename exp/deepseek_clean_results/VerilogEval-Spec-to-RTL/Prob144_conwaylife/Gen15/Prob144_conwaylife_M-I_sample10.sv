module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    wire [255:0] next_q;
    wire [255:0] cell_changes;  // Indicates cells that will change state
    
    // Pre-calculate row and column offsets for neighbor access
    wire [255:0] top_row_mask = {16'b0, q[255:16]};
    wire [255:0] bottom_row_mask = {q[239:0], 16'b0};
    wire [255:0] left_col_mask = {q[254:0], q[255]};
    wire [255:0] right_col_mask = {q[0], q[255:1]};
    
    genvar i;
    generate
        for (i = 0; i < 256; i = i + 1) begin : cell_logic
            // Calculate neighbor values using pre-calculated masks
            wire top_left = (i >= 16) ? ((i % 16) ? top_row_mask[i-17] : top_row_mask[i-1] : 
                                          (i % 16) ? q[255-(15-i%16)] : q[239];
            wire top = top_row_mask[i];
            wire top_right = (i >= 16) ? ((i % 16 != 15) ? top_row_mask[i-15] : top_row_mask[i-31] : 
                                           (i % 16 != 15) ? q[255-(15-i%16-1)] : q[255];
            
            wire left = left_col_mask[i];
            wire right = right_col_mask[i];
            
            wire bottom_left = (i < 240) ? ((i % 16) ? bottom_row_mask[i+15] : bottom_row_mask[i+31] : 
                                             (i % 16) ? q[15-(15-i%16)] : q[31];
            wire bottom = bottom_row_mask[i];
            wire bottom_right = (i < 240) ? ((i % 16 != 15) ? bottom_row_mask[i+17] : bottom_row_mask[i+1] : 
                                              (i % 16 != 15) ? q[15-(15-i%16-1)] : q[0];
            
            // Optimized neighbor counting with carry-save
            wire [1:0] sum_corners = top_left + top_right + bottom_left + bottom_right;
            wire [1:0] sum_sides = top + bottom + left + right;
            wire [2:0] neighbor_count = sum_corners + sum_sides;
            
            // Next state calculation
            wire next_state = (neighbor_count == 3) ? 1'b1 :
                             (neighbor_count == 2) ? q[i] :
                             1'b0;
            
            assign next_q[i] = next_state;
            assign cell_changes[i] = (next_state != q[i]);
        end
    endgenerate

    // Optimized sequential update with clock gating
    always @(posedge clk) begin
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