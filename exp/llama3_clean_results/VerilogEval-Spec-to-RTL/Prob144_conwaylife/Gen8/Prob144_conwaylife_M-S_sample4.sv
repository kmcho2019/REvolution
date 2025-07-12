module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

localparam GRID_SIZE = 16;

integer row, col, index, new_row, new_col, count;

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        // Iterate over each cell in the grid
        for (row = 0; row < GRID_SIZE; row++) begin
            for (col = 0; col < GRID_SIZE; col++) begin
                index = row * GRID_SIZE + col;
                count = 0;
                
                // Count neighbors
                for (integer i = -1; i <= 1; i++) begin
                    for (integer j = -1; j <= 1; j++) begin
                        if ((i == 0) && (j == 0)) begin
                            continue;
                        end
                        new_row = (row + i + GRID_SIZE) % GRID_SIZE;
                        new_col = (col + j + GRID_SIZE) % GRID_SIZE;
                        if (q[new_row * GRID_SIZE + new_col]) begin
                            count = count + 1;
                        end
                    end
                end
                
                // Update state based on neighbor count
                case (count)
                    0, 1: q[index] <= 1'b0;
                    2: ; // No change
                    3: q[index] <= 1'b1;
                    default: q[index] <= 1'b0;
                endcase
            end
        end
    end
end

endmodule