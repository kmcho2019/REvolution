module LFSR(
    input clk,
    input rst,
    output reg [3:0] out
);

reg [3:0] state;

always @(posedge clk) begin
    if (rst) begin
        state <= 4'd0; // Initialize state to zero on reset
    end else begin
        // Calculate the feedback signal
        reg feedback = ~(state[3] ^ state[2]);
        
        // Shift the bits to the left and insert the feedback at the LSB
        state <= {state[2:0], feedback};
        
        // Update the output
        out <= state;
    end
end

endmodule