module LFSR(
    input clk,  // Clock signal
    input rst,  // Active high reset signal
    output [3:0] out  // 4-bit output representing the current state
);

reg [3:0] state;  // Register to hold the current state

// Assign output to the current state
assign out = state;

always @ (posedge clk) begin
    if (rst) begin  // If reset is high, initialize the state to zero
        state <= 4'b0000;
    end else begin  // Otherwise, perform the shift and feedback operation
        // Calculate the feedback by XORing the MSB and the second MSB, then inverting
        state <= {state[2:0], ~(state[3] ^ state[2])};
    end
end

endmodule