module ring_counter (
    input         clk, 
    input         reset, 
    output [7:0]  out
);

reg [7:0] state; // Internal register to store the current state
assign out = state; // Output is the current state

always @ (posedge clk or posedge reset) begin
    if (reset) begin
        // Reset the counter to its initial state
        state <= 8'b0000_0001; 
    end else begin
        // Shift the 1 to the next position in a cyclic manner
        state <= {state[6:0], state[7]}; 
    end
end

endmodule