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
            // Left boundary (q[0]): neighbor to left is 0
            q[0] <= q[1] ^ 1'b0;
            
            // Middle cells
            for (integer i = 1; i < 511; i = i + 1) begin
                q[i] <= q[i+1] ^ q[i-1];
            end
            
            // Right boundary (q[511]): neighbor to right is 0
            q[511] <= 1'b0 ^ q[510];
        end
    end

endmodule