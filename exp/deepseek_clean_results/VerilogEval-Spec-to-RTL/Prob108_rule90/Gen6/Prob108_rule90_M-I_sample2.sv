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
            // Apply Rule 90 to all bits in parallel
            // Left neighbor is q[i-1] (0 for i=0)
            // Right neighbor is q[i+1] (0 for i=511)
            q <= {1'b0, q[511:1]} ^ {q[510:0], 1'b0};
        end
    end

endmodule