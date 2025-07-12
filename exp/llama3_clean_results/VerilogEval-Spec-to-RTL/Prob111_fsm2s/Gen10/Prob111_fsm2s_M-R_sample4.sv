module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg state;
reg next_state;

always_comb begin
    case(state)
        1'b0: next_state = j? 1'b1 : 1'b0; // OFF to ON or stay OFF
        1'b1: next_state = ~k? 1'b1 : 1'b0; // ON to OFF or stay ON
    endcase
end

always_ff @(posedge clk) begin
    if (reset) begin
        state <= 1'b0; // Reset to OFF state
    end else begin
        state <= next_state;
    end
    out <= state; // Assign output from state
end

endmodule