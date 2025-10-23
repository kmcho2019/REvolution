module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg state;

always @(posedge clk) begin
    if (reset) begin
        state <= 1'b0; // Reset to OFF state
    end else begin
        case (state)
            1'b0: state <= j? 1'b1 : 1'b0; // Transition from OFF
            1'b1: state <= ~k? 1'b1 : 1'b0; // Transition from ON
        endcase
    end
end

assign out = state;

endmodule