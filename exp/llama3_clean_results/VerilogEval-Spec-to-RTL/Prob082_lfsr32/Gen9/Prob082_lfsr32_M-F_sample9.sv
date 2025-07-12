module TopModule(
    input  clk,
    input  reset,
    output reg [31:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end else begin
        // Calculate the feedback term (XOR of the taps)
        reg fb;
        fb = q[31] ^ q[21] ^ q[1] ^ q[0];
        
        // Shift the current state to the right and update the MSB with the feedback term
        q[31:1] <= q[30:0]; // Shift bits to the right
        q[0] <= fb; // Update LSB with the feedback term
    end
end

endmodule