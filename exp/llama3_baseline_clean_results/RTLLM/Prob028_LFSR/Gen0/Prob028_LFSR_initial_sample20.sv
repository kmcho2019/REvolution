module LFSR(
    input clk,
    input rst,
    output [3:0] out
);

reg [3:0] state;

assign out = state;

always @(posedge clk) begin
    if (rst) begin
        state <= 4'b0000; // Reset the register to zero
    end else begin
        // Calculate the feedback signal by XORing MSB and second MSB, then inverting
        reg fb;
        assign fb = ~(state[3] ^ state[2]);
        
        // Shift the bits left and insert the new feedback value at the LSB
        state <= {state[2:0], fb};
    end
end

endmodule