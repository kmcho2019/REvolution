module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

wire feedback = q[0];  // Feedback term is LSB

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end
    else begin
        // Galois LFSR implementation with correct taps
        q <= {feedback, 
              q[31] ^ feedback,  // Tap at bit 31 (position 32)
              q[30:22], 
              q[21] ^ feedback,   // Tap at bit 21 (position 22)
              q[20:2], 
              q[1] ^ feedback,    // Tap at bit 1 (position 2)
              q[0] ^ feedback};   // Tap at bit 0 (position 1)
    end
end

endmodule