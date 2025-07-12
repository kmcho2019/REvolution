module LFSR(
    input clk,
    input rst,
    output [3:0] out
);

reg [3:0] state;

always @(posedge clk) begin
    if (rst) begin
        state <= 4'b0000;
    end else begin
        // Calculate feedback by XORing the most significant bit and the second most significant bit
        // and then inverting the result.
        reg feedback;
        feedback = ~(state[3] ^ state[2]);
        
        // Shift the bits left and insert the new feedback value at the LSB.
        state <= {state[2:0], feedback};
    end
end

// Assign the current state to the output.
assign out = state;

endmodule