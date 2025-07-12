module LFSR (
    input clk, 
    input rst, 
    output [3:0] out
);

reg [3:0] state; // register to hold the current state of the LFSR
assign out = state; // assign the state to the output port

always @(posedge clk or posedge rst) begin
    if (rst) begin
        // if reset is high, initialize the register to zero
        state <= 4'b0000;
    end else begin
        // calculate the feedback signal
        reg feedback;
        feedback = ~(state[3] ^ state[2]); // XOR the most significant bit and the second most significant bit, then invert
        
        // shift the bits to the left and insert the new feedback value at the LSB
        state <= {state[2:0], feedback};
    end
end

endmodule