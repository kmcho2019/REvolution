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
            // Compute next state using XOR of neighbors
            // Left neighbor is {0, q[511:1]}, right is {q[510:0], 0}
            q <= {0, q[511:1]} ^ {q[510:0], 0};
        end
    end

endmodule