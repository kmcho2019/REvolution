module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reset the LFSR output to 1
        q <= 5'b00001;
    end else begin
        // Shift right and XOR with q[0] for taps
        q[4] <= q[3] ^ q[0];
        q[3] <= q[2] ^ q[0];
        q[2] <= q[1];
        q[1] <= q[0];
        q[0] <= 1'b0; // Will be shifted out, but we need a value for q[0] in this cycle
        // To actually implement the correct shift, the MSB of q should be q[3] ^ q[0]
        // but this is already handled by the tap at position 5 (which is q[4])
    end
end

endmodule