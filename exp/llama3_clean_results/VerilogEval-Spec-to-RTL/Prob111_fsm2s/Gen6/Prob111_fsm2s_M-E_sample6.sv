module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg state; // Using 1 bit for state
reg next_state;

always @(posedge clk) begin
    if (reset) begin
        state <= 1'b0; // Reset to OFF state
    end else if (next_state != state) begin
        state <= next_state; // Update state
    end
end

always @(*) begin
    case({state, j, k})
        3'b000, 3'b001, 3'b010: next_state = 1'b0;
        3'b011: next_state = 1'b1;
        3'b100, 3'b101: next_state = 1'b1;
        3'b110: next_state = 1'b0;
        3'b111: next_state = 1'b0;
    endcase
end

assign out = state; // Assign output based on state

endmodule