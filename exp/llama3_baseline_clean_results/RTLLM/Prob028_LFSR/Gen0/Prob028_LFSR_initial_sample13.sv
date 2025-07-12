module LFSR(
    input clk,  // Clock signal
    input rst,  // Active high reset signal
    output [3:0] out  // 4-bit output representing the current state of the LFSR
);

reg [3:0] state;  // Register to hold the current state of the LFSR

always @ (posedge clk) begin
    if (rst) begin  // If reset is high, initialize the register to zero
        state <= 4'd0;
    end else begin
        // Calculate the feedback signal
        reg feedback;
        feedback = ~(state[3] ^ state[2]);  // Invert the XOR result

        // Shift the bits in the register to the left and insert the new feedback value at the LSB
        state <= {state[2:0], feedback};
    end
end

assign out = state;  // Assign the current state to the output

endmodule