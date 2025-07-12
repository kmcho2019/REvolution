module TopModule (
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] state;

always @(posedge clk) begin
    if (reset) begin
        state <= 4'd1; // Reset to state 1
    end else if (state == 4'd10) begin
        state <= 4'd1; // Transition from state 10 to state 1
    end else begin
        state <= state + 1; // Increment state
    end
end

assign q = state;

endmodule