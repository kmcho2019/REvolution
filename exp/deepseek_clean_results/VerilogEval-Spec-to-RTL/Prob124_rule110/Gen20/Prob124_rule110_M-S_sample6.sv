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
            // Apply Rule 110 with boundary conditions (0 for q[-1] and q[512])
            q <= {1'b0, q[511:1]} & q |  // Cases where left & center are 1
                 {1'b0, q[511:1]} & ~q | // Cases where left is 1 and center is 0
                 q & {q[510:0], 1'b0} |   // Cases where center & right are 1
                 ~{1'b0, q[511:1]} & {q[510:0], 1'b0}; // Cases where left is 0 and right is 1
        end
    end

endmodule