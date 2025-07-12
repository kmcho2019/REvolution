module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Process each bit with boundary conditions
            for (integer i = 0; i < 512; i = i + 1) begin
                // Get neighbors (0 for out-of-bounds)
                wire left = (i == 511) ? 1'b0 : q[i+1];
                wire right = (i == 0) ? 1'b0 : q[i-1];
                
                // Rule 110 logic
                q[i] <= (left & q[i] & ~right) |  // 110 -> 1
                       (left & ~q[i] & right) |   // 101 -> 1
                       (~left & q[i]) |          // 011/010 -> 1
                       (~left & right);           // 001 -> 1
            end
        end
    end

endmodule