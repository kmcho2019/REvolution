module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Next state calculation
    always @(*) begin
        for (integer i = 0; i < 256; i = i + 1) begin
            // Calculate row and column with wrapping
            integer row = i / 16;
            integer col = i % 16;
            
            // Calculate neighbor indices with toroidal wrapping
            integer north = ((row + 15) % 16) * 16 + col;
            integer south = ((row + 1) % 16) * 16 + col;
            integer west = row * 16 + ((col + 15) % 16);
            integer east = row * 16 + ((col + 1) % 16);
            integer nw = ((row + 15) % 16) * 16 + ((col + 15) % 16);
            integer ne = ((row + 15) % 16) * 16 + ((col + 1) % 16);
            integer sw = ((row + 1) % 16) * 16 + ((col + 15) % 16);
            integer se = ((row + 1) % 16) * 16 + ((col + 1) % 16);
            
            // Count live neighbors
            integer neighbor_count = 
                q[north] + q[south] + q[west] + q[east] +
                q[nw] + q[ne] + q[sw] + q[se];
            
            // Apply game rules
            case (neighbor_count)
                2: q[i] = q[i];  // Maintain current state
                3: q[i] = 1'b1;  // Cell becomes alive
                default: q[i] = 1'b0;  // Cell dies
            endcase
        end
    end

    // State update
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= q;  // The combinational block handles the actual update
        end
    end

endmodule