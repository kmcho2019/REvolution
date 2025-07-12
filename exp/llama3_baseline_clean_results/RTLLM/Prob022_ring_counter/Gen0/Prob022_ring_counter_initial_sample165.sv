module ring_counter(
    input clk,
    input reset,
    output [7:0] out
);

reg [7:0] state;

// Initialize the state when reset is high
always @(posedge reset) begin
    state <= 8'b0000_0001;
end

// Update the state on each rising edge of the clock
always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= 8'b0000_0001;
    end else begin
        state <= {state[6:0], state[7]};
    end
end

// Assign the state to the output
assign out = state;

endmodule