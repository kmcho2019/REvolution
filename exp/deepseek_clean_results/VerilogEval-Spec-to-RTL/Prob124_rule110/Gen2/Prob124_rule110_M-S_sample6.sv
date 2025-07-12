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
            // Left boundary (i=0)
            q[0] <= (q[0] & q[1]) | (~0 & q[1]) | (~0 & q[0]);
            
            // Middle cells (i=1 to 510)
            for (integer i = 1; i < 511; i = i + 1) begin
                q[i] <= (q[i] & q[i+1]) | (~q[i-1] & q[i+1]) | (~q[i-1] & q[i]);
            end
            
            // Right boundary (i=511)
            q[511] <= (q[511] & ~q[510]) | (0 & ~q[510]) | (q[511] & 0);
        end
    end

endmodule