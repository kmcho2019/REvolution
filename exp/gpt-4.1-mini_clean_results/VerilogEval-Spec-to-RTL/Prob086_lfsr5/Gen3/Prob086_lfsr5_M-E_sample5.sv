module TopModule (
    input wire clk,
    input wire reset,
    output reg [4:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;  // Initialize state to non-zero value
    end else begin
        // Calculate feedback as XOR of q[0] (LSB), q[2], and q[4] (tap positions 3 and 5)
        // Since taps are at bits 5 and 3, zero-based indexing q[4] and q[2]
        wire feedback = q[0] ^ q[2] ^ q[4];
        // Shift right and input feedback at MSB
        q <= {feedback, q[4:1]};
    end
end

endmodule