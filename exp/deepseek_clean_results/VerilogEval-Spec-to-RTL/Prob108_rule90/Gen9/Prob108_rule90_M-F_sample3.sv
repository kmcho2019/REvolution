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
            // Apply Rule 90 to all cells in parallel
            // Left boundary (q[-1]) is 0
            q[0] <= 0 ^ q[1];
            
            // Middle cells
            q[511:1] <= q[510:0] ^ q[512:2];
            
            // Right boundary (q[512]) is 0
            // Handled by the above assignment (q[511] gets q[510] ^ 0)
        end
    end

endmodule