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
            // Compute next state for each cell
            q[0] <= 1'b0 ^ q[1];  // Left boundary is 0
            for (integer i = 1; i < 511; i = i + 1) begin
                q[i] <= q[i-1] ^ q[i+1];
            end
            q[511] <= q[510] ^ 1'b0;  // Right boundary is 0
        end
    end

endmodule