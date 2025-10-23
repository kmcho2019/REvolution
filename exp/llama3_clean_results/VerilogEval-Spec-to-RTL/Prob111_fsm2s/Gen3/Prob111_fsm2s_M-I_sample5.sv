module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

// State register
reg state;

// State register initialization
initial state = 1'b0;

// State register update
always @(posedge clk) begin
    if (reset) begin
        state <= 1'b0; // Reset to OFF state
    end else begin
        case (state)
            1'b0: state <= j ? 1'b1 : 1'b0; // Transition from OFF
            1'b1: state <= ~k; // Transition from ON, using ~k for better synthesis
        endcase
    end
end

// Output logic
assign out = state;

endmodule