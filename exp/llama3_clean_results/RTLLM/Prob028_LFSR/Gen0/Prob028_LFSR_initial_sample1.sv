module LFSR(
    input clk, // Clock signal
    input rst, // Active high reset signal
    output [3:0] out // 4-bit output representing the current state of the LFSR
);

reg [3:0] state; // Variable to hold the current state of the LFSR
wire feedback; // Wire to hold the feedback signal

// Calculate the feedback by XORing the MSB and second MSB, and then inverting the result
assign feedback = ~(state[3] ^ state[2]);

// Sequential logic block to update the LFSR state
always @ (posedge clk) begin
    if (rst) begin // If reset is high, initialize the register to zero
        state <= 4'b0000;
    end else begin // Otherwise, shift the bits left and insert the new feedback value at the LSB
        state <= {state[2:0], feedback};
    end
end

// Assign the current state of the LFSR to the output port
assign out = state;

endmodule