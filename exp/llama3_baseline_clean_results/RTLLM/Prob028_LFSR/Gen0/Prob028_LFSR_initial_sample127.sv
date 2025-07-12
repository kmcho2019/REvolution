module LFSR(
    input clk,
    input rst,
    output [3:0] out
);

reg [3:0] state;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        // Reset the LFSR to zero
        state <= 4'b0000;
    end else begin
        // Calculate the feedback signal
        reg feedback;
        feedback = ~(state[3] ^ state[2]);
        
        // Shift the bits left and insert the new feedback value at the LSB
        state <= {state[2:0], feedback};
    end
end

// Assign the current state to the output
assign out = state;

endmodule