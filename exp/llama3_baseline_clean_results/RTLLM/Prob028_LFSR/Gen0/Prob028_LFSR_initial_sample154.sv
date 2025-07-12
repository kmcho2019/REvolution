module LFSR(
    input clk, 
    input rst, 
    output [3:0] out
);

reg [3:0] state; // current state of the LFSR
assign out = state; // assign the current state to the output port

// calculate the feedback signal
wire feedback = ~(state[3] ^ state[2]); // invert the result of XORing the most significant bit and the second most significant bit

always @ (posedge clk) begin
    if (rst) begin // if reset is high, initialize the LFSR state to zero
        state <= 4'b0000;
    end else begin // otherwise, shift the bits left and insert the new feedback value at the LSB
        state <= {state[2:0], feedback};
    end
end

endmodule