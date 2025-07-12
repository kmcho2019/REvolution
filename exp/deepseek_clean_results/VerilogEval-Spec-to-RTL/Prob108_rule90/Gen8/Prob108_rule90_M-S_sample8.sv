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
            // Rule 90: next state is XOR of left and right neighbors
            // Left neighbor is q shifted right by 1 (with 0 at MSB)
            // Right neighbor is q shifted left by 1 (with 0 at LSB)
            q <= {1'b0, q[511:1]} ^ {q[510:0], 1'b0};
        end
    end

endmodule