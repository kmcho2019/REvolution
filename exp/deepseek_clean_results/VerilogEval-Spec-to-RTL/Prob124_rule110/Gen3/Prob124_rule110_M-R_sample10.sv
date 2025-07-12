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
            // Apply Rule 110 with boundary conditions (0 for out-of-range neighbors)
            q <= {1'b0, q[511:1]} & q |  // Cases where center becomes 1
                 ~{1'b0, q[511:1]} & {q[510:0], 1'b0} |  // More cases for 1
                 ~q & {q[510:0], 1'b0} & ~{1'b0, q[511:1]};  // Remaining cases
            // The above is equivalent to:
            // q <= (left & center & ~right) | (~left & center) | (~center & right)
            // where left = {1'b0, q[511:1]}, right = {q[510:0], 1'b0}
        end
    end

endmodule