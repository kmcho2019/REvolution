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
            // Apply Rule 110 to all bits
            q[511:0] <= {
                (q[511] ^ q[510]) | (~1'b0 & (q[511] | q[510])),  // Leftmost bit (left neighbor is 0)
                (q[510:1] ^ q[509:0]) | (~q[511:2] & (q[510:1] | q[509:0])),  // Middle bits
                (q[0] ^ 1'b0) | (~q[1] & (q[0] | 1'b0))  // Rightmost bit (right neighbor is 0)
            };
        end
    end

endmodule