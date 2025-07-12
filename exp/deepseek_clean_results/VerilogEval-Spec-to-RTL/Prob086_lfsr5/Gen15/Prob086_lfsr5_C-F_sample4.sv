module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;
    end
    else begin
        q[4] <= q[0];          // MSB gets feedback
        q[3:1] <= q[4:2];      // Middle bits shift right
        q[2] <= q[3] ^ q[0];    // Tap at position 3
    end
end

endmodule