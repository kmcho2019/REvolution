module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;  // Reset to 1
    end
    else begin
        // Galois LFSR with taps at positions 5 (q[4]) and 3 (q[2])
        q <= {
            q[0] ^ q[4],  // Feedback for position 5
            q[4],          // Shift right
            q[3] ^ q[0],   // Feedback for position 3
            q[2],          // Shift right
            q[1]           // Shift right
        };
    end
end

endmodule