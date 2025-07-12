module TopModule(
    input clk,
    input reset,
    output [4:0] q
);

reg [4:0] state;

always @ (posedge clk or posedge reset) begin
    if (reset) begin
        state <= 5'b10000; // Reset to a non-zero value to generate the maximum-length sequence
    end else begin
        // LUT-based implementation of the Galois LFSR
        // Taps at positions 5 and 3
        state <= {state[3:0], state[4] ^ state[2]};
    end
end

assign q = state;

endmodule