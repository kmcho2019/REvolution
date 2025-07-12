module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

reg state;
reg next_state;

always @(*) begin
    case(state)
        1'b0: next_state = (in) ? 1'b0 : 1'b1; // State A
        1'b1: next_state = (in) ? 1'b1 : 1'b0; // State B
        default: next_state = 1'b1; // Default to state B
    endcase
end

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 1'b1; // Asynchronous reset to state B
    end else begin
        state <= next_state;
    end
end

assign out = state;

endmodule