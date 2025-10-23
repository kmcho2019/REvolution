module LFSR (
    input clk, 
    input rst, 
    output [3:0] out
);

reg [3:0] state;

assign out = state;

always @ (posedge clk) begin
    if (rst) begin
        state <= 4'b0000;
    end else begin
        // Calculate the feedback signal by inverting the XOR of the most significant bit (state[3]) 
        // and the second most significant bit (state[2])
        reg feedback;
        feedback = ~(state[3] ^ state[2]);
        
        // Shift the bits to the left and insert the new feedback value at the least significant bit
        state <= {state[2:0], feedback};
    end
end

endmodule