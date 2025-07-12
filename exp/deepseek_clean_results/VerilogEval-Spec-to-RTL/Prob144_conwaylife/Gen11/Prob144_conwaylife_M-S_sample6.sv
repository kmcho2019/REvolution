module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Update all cells in parallel
            for (integer i = 0; i < 16; i = i + 1) begin
                for (integer j = 0; j < 16; j = j + 1) begin
                    // Calculate neighbor count with wrap-around
                    reg [3:0] count = 0;
                    integer x, y;
                    
                    // Check all 8 neighbors
                    for (x = -1; x <= 1; x = x + 1) begin
                        for (y = -1; y <= 1; y = y + 1) begin
                            if (x != 0 || y != 0) begin  // Skip self
                                // Calculate wrapped indices
                                integer xi = (i + x + 16) % 16;
                                integer yj = (j + y + 16) % 16;
                                // Add neighbor state to count
                                count = count + q[xi * 16 + yj];
                            end
                        end
                    end
                    
                    // Current cell state
                    reg current = q[i * 16 + j];
                    
                    // Apply rules
                    case (count)
                        2: q[i * 16 + j] <= current;  // No change
                        3: q[i * 16 + j] <= 1;        // Birth/survival
                        default: q[i * 16 + j] <= 0;  // Death
                    endcase
                end
            end
        end
    end

endmodule