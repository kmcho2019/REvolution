module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Function to get neighbor count for any cell (i,j)
    function [3:0] get_neighbor_count;
        input [7:0] i, j;  // 4 bits each for 0-15
        reg [15:0] row_above, row_below;
        reg left, right;
        reg [3:0] count;
        begin
            // Get adjacent rows with wrap-around
            row_above = q[((i-1) & 15)*16 +: 16];
            row_below = q[((i+1) & 15)*16 +: 16];
            
            // Get current row and left/right neighbors
            left = q[i*16 + ((j-1) & 15)];
            right = q[i*16 + ((j+1) & 15)];
            
            // Count all 8 neighbors
            count = row_above[(j-1) & 15] + row_above[j] + row_above[(j+1) & 15] +
                    left + right +
                    row_below[(j-1) & 15] + row_below[j] + row_below[(j+1) & 15];
            
            get_neighbor_count = count;
        end
    endfunction

    // Combinational next state logic
    wire [255:0] next_q;
    generate
        genvar i, j;
        for (i = 0; i < 16; i = i + 1) begin : row_gen
            for (j = 0; j < 16; j = j + 1) begin : col_gen
                wire current = q[i*16 + j];
                wire [3:0] neighbors = get_neighbor_count(i, j);
                
                // Game rules implementation
                assign next_q[i*16 + j] = (neighbors == 2) ? current :
                                          (neighbors == 3) ? 1'b1 :
                                          1'b0;
            end
        end
    endgenerate

    // Sequential update
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule