module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

// Update the current state of the LFSR
always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001; // Set the LFSR output to 1
    end else begin
        q[4] <= q[3] ^ q[0]; // Tap at position 5
        q[3] <= q[2]; // Shift right
        q[2] <= q[1] ^ q[0]; // Tap at position 3
        q[1] <= q[0]; // Shift right
        q[0] <= q[4] ^ q[2]; // Shift right and XOR
    end
end

endmodule