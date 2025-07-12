module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

always @ (posedge clk) begin
    if (reset) begin
        q <= 5'b1; // Reset q to 1, a non-zero value
    end else begin
        // Correct LFSR next state calculation for a Galois LFSR with taps at 5 and 3
        q <= {q[2] ^ q[0], q[4:1]};
    end
end

endmodule