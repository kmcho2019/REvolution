module TopModule(
    input clk,
    input reset,
    output reg [4:0] q // Output q is a 5-bit register
);

// Combinational logic to calculate the next state
wire next_state_4;
wire next_state_2;
assign next_state_4 = q[3] ^ q[0]; // Tap at position 5 (4 in 0-based indexing)
assign next_state_2 = q[2] ^ q[0]; // Tap at position 3 (2 in 0-based indexing)

// Sequential logic to update the state register
always @(posedge clk) begin
    if (reset) begin
        q <= 5'b10000; // Reset the LFSR output to a 5-bit value
    end else begin
        q <= {next_state_4, q[3], next_state_2, q[1], q[0]}; // Update the state with the next state
    end
end

endmodule