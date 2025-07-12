module TopModule(
    input clk,
    input reset,
    output [4:0] q
);

reg [4:0] state;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 5'b10000; // Initialize with '1' as per requirement
    end else begin
        // Calculate new MSB by XORing taps (positions 4 and 2) with LSB
        reg new_msb;
        new_msb = state[4] ^ state[2] ^ state[0];
        // Shift all bits to the right, with new MSB becoming the new value
        state <= {new_msb, state[4:1]};
    end
end

assign q = state;

endmodule