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
            // Left boundary (q[0]): left neighbor is 0, right is q[1]
            q[0] <= 1'b0 ^ q[1];
            
            // Middle cells
            q[511:1] <= {q[510] ^ 1'b0, q[510:2] ^ q[512:2]};
            
            // Alternative implementation for middle cells if the above doesn't synthesize well:
            // for (integer i = 1; i < 511; i = i + 1) begin
            //     q[i] <= q[i-1] ^ q[i+1];
            // end
            
            // Right boundary (q[511]): left neighbor is q[510], right is 0
            // Handled in the concatenation above (q[510] ^ 1'b0)
        end
    end

endmodule