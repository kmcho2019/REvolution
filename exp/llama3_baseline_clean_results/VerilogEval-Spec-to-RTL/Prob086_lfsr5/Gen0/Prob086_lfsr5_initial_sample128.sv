module TopModule(
    input  clk,
    input  reset,
    output [4:0] q
);

reg [4:0] q;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        q <= 5'b10000; // Reset to a non-zero state
    end else begin
        q[4] <= q[3] ^ q[0]; // Tap at position 5
        q[3] <= q[2] ^ q[0]; // Tap at position 3
        q[2] <= q[1];
        q[1] <= q[0];
        q[0] <= 0; // The LSB does not depend on any previous bit
    end
end

endmodule