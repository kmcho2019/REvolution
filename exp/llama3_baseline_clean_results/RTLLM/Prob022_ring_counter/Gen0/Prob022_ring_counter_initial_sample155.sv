module ring_counter(
    input clk,
    input reset,
    output [7:0] out
);

reg [7:0] state;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= 8'b0000_0001; // Initialize to starting state
    end else begin
        state <= {state[6:0], state[7]}; // Shift right and wrap around
    end
end

assign out = state;

endmodule