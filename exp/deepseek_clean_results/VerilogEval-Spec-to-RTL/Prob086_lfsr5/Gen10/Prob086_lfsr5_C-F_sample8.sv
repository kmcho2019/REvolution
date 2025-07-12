module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

wire feedback = q[3] ^ q[0];  // Explicit feedback calculation (taps at bits 4 and 2 in 0-based)

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;  // Active high sync reset to 1
    end else begin
        // Galois LFSR with taps at bits 4 and 2 (0-based)
        // MSB comes from q[0], bit 2 gets feedback, others shift right
        q <= {q[0], q[4], feedback, q[2], q[1]};
    end
end

endmodule