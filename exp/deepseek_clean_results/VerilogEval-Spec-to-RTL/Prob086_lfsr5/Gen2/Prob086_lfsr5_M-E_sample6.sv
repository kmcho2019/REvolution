module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

wire feedback;

// Calculate feedback (XOR of taps and LSB)
assign feedback = q[0] ^ q[4] ^ q[2];

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;  // Reset to 1
    end
    else begin
        // Galois LFSR implementation:
        // 1. Shift right
        // 2. Apply feedback to tap positions
        q <= {feedback, q[4:1]};
    end
end

endmodule