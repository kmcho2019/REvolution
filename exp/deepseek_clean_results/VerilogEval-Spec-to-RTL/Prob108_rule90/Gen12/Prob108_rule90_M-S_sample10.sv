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
            // Compute next state for each bit
            q[0] <= q[1];                     // Left boundary (q[-1] = 0)
            q[511] <= q[510];                  // Right boundary (q[512] = 0)
            for (integer i = 1; i < 511; i = i + 1) begin
                q[i] <= q[i-1] ^ q[i+1];      // Rule 90 for internal bits
            end
        end
    end

endmodule