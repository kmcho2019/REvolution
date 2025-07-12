module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg state; // Using 1 bit for state

// Sequential logic for state update
always @(posedge clk) begin
    if (reset) begin
        state <= 1'b0; // Reset to OFF state
    end else begin
        case (state)
            1'b0: state <= j;
            1'b1: state <= ~k;
            default: state <= 1'b0;
        endcase
    end
end

// Output is determined by the current state
assign out = state;

endmodule