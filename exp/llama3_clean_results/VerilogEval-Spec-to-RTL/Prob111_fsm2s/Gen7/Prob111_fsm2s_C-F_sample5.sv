module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg state; // Using 1 bit for state

// Output logic based on current state
always_comb begin
    out = state;
end

// State register with synchronous reset
always_ff @(posedge clk) begin
    if (reset) begin
        state <= 1'b0; // Reset to OFF state
    end else begin
        case (state)
            1'b0: state <= j? 1'b1 : 1'b0;
            1'b1: state <= k? 1'b0 : 1'b1;
            default: state <= 1'b0;
        endcase
    end
end

endmodule