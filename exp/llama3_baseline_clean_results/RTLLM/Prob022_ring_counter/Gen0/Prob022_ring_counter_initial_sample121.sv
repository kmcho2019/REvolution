module ring_counter(
    input         clk,
    input         reset,
    output [7:0]  out
);

reg [7:0] state; // internal state register

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 8'b0000_0001; // reset to initial state
    end else begin
        state <= {state[6:0], state[7]}; // shift and wrap
    end
end

assign out = state; // output the current state

endmodule