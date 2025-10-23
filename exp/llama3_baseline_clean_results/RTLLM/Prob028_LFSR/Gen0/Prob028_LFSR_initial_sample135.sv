module LFSR (
    input clk,
    input rst,
    output [3:0] out
);

reg [3:0] state; // Register to store the current state of the LFSR
assign out = state; // Continuous assignment to output the current state

always @ (posedge clk) // Sequential logic on the rising edge of the clock
begin
    if (rst) // If reset is high, initialize the register to zero
    begin
        state <= 4'd0;
    end
    else // If reset is low, shift the bits and insert the feedback value
    begin
        // Calculate the feedback signal by XORing the MSB and the second MSB, then inverting the result
        reg feedback;
        assign feedback = ~(state[3] ^ state[2]);
        
        // Shift the bits left and insert the feedback value at the LSB
        state <= {state[2:0], feedback};
    end
end

endmodule