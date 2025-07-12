module TopModule(
    input clk,
    input reset,
    output reg [31:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1; // Reset q to 32'h1 on active high reset
    end else begin
        // Calculate the new state based on the taps
        reg [31:0] new_q;
        new_q[31] = q[30] ^ q[21] ^ q[1] ^ q[0]; // Tap positions 31, 22, 2, and 1
        new_q[30:1] = q[29:0]; // Shift the rest of the bits
        new_q[0] = 0; // Since we're shifting in from the left, the 0th bit is always 0
        
        // Assign the new state to q
        q <= new_q;
    end
end

endmodule