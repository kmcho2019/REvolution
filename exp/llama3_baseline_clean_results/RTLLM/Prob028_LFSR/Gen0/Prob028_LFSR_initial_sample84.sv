module LFSR(
    input clk,
    input rst,
    output [3:0] out
);

reg [3:0] state;

always @(posedge clk) begin
    if (rst) begin
        // Initialize the register to zero on reset
        state <= 4'b0000;
    end else begin
        // Calculate the feedback signal
        reg feedback;
        feedback = ~(state[3] ^ state[2]);
        
        // Shift the bits left and insert the feedback at the LSB
        state <= {state[2:0], feedback};
    end
end

// Assign the current state to the output port
assign out = state;

endmodule