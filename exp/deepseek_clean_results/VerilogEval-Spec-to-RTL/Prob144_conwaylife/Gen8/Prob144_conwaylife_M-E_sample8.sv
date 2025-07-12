module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Circular shift registers for neighbor propagation
    reg [255:0] row_above, row_current, row_below;
    reg [255:0] next_row_above, next_row_current, next_row_below;
    
    // Intermediate neighbor counts
    reg [3:0] neighbor_count [0:255];
    wire [255:0] next_q;
    
    // Circular shift functions
    function [15:0] circular_shift_left;
        input [15:0] row;
        circular_shift_left = {row[14:0], row[15]};
    endfunction
    
    function [15:0] circular_shift_right;
        input [15:0] row;
        circular_shift_right = {row[0], row[15:1]};
    endfunction
    
    // Initialize shift registers
    always @(posedge clk) begin
        if (load) begin
            row_current <= data;
            row_above <= circular_shift_right(data[255:240]) | 
                        (circular_shift_right(data[239:224]) << 16 |
                        /* ... continues for all rows ... */ ;
            row_below <= circular_shift_left(data[15:0]) |
                        (circular_shift_left(data[31:16]) << 16) |
                        /* ... continues for all rows ... */ ;
        end else begin
            row_above <= next_row_above;
            row_current <= next_row_current;
            row_below <= next_row_below;
            q <= next_q;
        end
    end
    
    // Neighbor calculation pipeline
    genvar i;
    generate
        for (i = 0; i < 256; i = i + 1) begin : cell_logic
            // Current cell position
            localparam row = i >> 4;
            localparam col = i & 15;
            
            // Get neighbor bits from shift registers
            wire left = (col == 0) ? row_current[i+15] : row_current[i-1];
            wire right = (col == 15) ? row_current[i-15] : row_current[i+1];
            
            // Calculate neighbor count in stages
            always @(*) begin
                // Stage 1: Horizontal neighbors
                reg [1:0] horiz = left + right;
                
                // Stage 2: Vertical neighbors
                reg [1:0] vert = row_above[i] + row_below[i];
                
                // Stage 3: Diagonal neighbors
                reg [1:0] diag_top = row_above[(col == 0) ? i+15 : i-1] + 
                                    row_above[(col == 15) ? i-15 : i+1];
                reg [1:0] diag_bot = row_below[(col == 0) ? i+15 : i-1] + 
                                    row_below[(col == 15) ? i-15 : i+1];
                
                // Final sum
                neighbor_count[i] = horiz + vert + diag_top + diag_bot;
            end
            
            // Game rules
            assign next_q[i] = (neighbor_count[i] == 3) ? 1'b1 :
                             (neighbor_count[i] == 2) ? q[i] :
                             1'b0;
        end
    endgenerate
    
    // Update shift registers for next cycle
    always @(*) begin
        next_row_above = row_current;
        next_row_current = next_q;
        next_row_below = row_above;
    end

endmodule