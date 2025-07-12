module LFSR(
    input clk,
    input rst,
    output reg [3:0] out
);

// Internal variable to hold the current state of the LFSR
reg [3:0] current_state;

// Assign the output port to the current state
assign out = current_state;

// Calculate the feedback signal by XORing the MSB and the second MSB, and then inverting the result
wire feedback = ~(current_state[3] ^ current_state[2]);

// On the rising edge of the clock
always @(posedge clk) begin
    // If the reset signal is high, initialize the LFSR to zero
    if (rst) begin
        current_state <= 4'b0000;
    end
    // Otherwise, shift the bits in the LFSR to the left and insert the new feedback value at the LSB
    else begin
        current_state <= {current_state[2:0], feedback};
    end
end

endmodule