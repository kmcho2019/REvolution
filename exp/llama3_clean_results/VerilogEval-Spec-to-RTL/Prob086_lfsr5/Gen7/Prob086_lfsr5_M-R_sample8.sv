module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

// Define the next state logic
wire next_q_4;
wire next_q_3;
wire next_q_2;
wire next_q_1;
wire next_q_0;

assign next_q_4 = q[3] ^ q[0];  // Tap at position 5
assign next_q_3 = q[2] ^ q[0];  // Tap at position 3
assign next_q_2 = q[1];
assign next_q_1 = q[0];
assign next_q_0 = q[4];        // Shift the MSB to the LSB

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) begin
        // Reset the LFSR output to a non-zero value
        q <= 1;
    end else begin
        // Update the state based on the next state logic
        q[4] <= next_q_4;
        q[3] <= next_q_3;
        q[2] <= next_q_2;
        q[1] <= next_q_1;
        q[0] <= next_q_0;
    end
end

endmodule