module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

reg next_bit;

always @(posedge clk) begin
    if (reset) begin
        q <= {4'b0, 1'b1};  // Only set LSB to 1
    end
    else begin
        next_bit <= q[3] ^ q[0];  // Pre-compute XOR for better timing
        q <= {q[0], q[4], next_bit, q[2], q[1]};
    end
end

endmodule