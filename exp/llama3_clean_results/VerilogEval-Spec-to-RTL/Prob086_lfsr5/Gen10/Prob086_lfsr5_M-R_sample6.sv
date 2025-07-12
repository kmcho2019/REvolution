module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

// Combinational logic to determine the next state based on taps
wire next_q0, next_q1, next_q2, next_q3, next_q4;

assign next_q4 = q[2] ^ q[0]; // Update MSB based on taps
assign next_q3 = q[4]; // Shift
assign next_q2 = q[3]; // Shift
assign next_q1 = q[2]; // Shift
assign next_q0 = q[1]; // Shift

// Sequential logic to update the state of the LFSR
always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001; // Reset the LFSR output to 1
    end else begin
        // Update the state of the LFSR based on the next state logic
        q[4] <= next_q4;
        q[3] <= next_q3;
        q[2] <= next_q2;
        q[1] <= next_q1;
        q[0] <= next_q0;
    end
end

endmodule