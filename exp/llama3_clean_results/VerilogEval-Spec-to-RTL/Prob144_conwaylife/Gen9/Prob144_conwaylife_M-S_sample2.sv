module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

localparam GRID_SIZE = 16;

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        reg [255:0] next_q;
        next_q = q;
        for (integer row = 0; row < GRID_SIZE; row++) begin
            for (integer col = 0; col < GRID_SIZE; col++) begin
                integer index = row * GRID_SIZE + col;
                integer count = 0;
                
                // Count neighbors
                for (integer i = -1; i <= 1; i++) begin
                    for (integer j = -1; j <= 1; j++) begin
                        if ((i == 0) && (j == 0)) begin
                            continue;
                        end
                        integer new_row = (row + i + GRID_SIZE) % GRID_SIZE;
                        integer new_col = (col + j + GRID_SIZE) % GRID_SIZE;
                        integer new_index = new_row * GRID_SIZE + new_col;
                        if (q[new_index]) begin
                            count = count + 1;
                        end
                    end
                end
                
                // Update state based on neighbor count
                case (count)
                    0, 1: next_q[index] <= 1'b0;
                    2: ; // No change
                    3: next_q[index] <= 1'b1;
                    default: next_q[index] <= 1'b0;
                endcase
            end
        end
        q <= next_q;
    end
end

endmodule