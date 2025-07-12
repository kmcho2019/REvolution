module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg [1:0] state;

always @(posedge clk) begin
    if (reset) begin
        state <='b01; // Reset to OFF state
    end else begin
        case (state)
'b01: state <= j ? 2'b10 : 2'b01; // Transition from OFF
'b10: state <= ~k ? 2'b10 : 2'b01; // Transition from ON
            default: state <= 2'b01; // Default to OFF state
        endcase
    end
end

assign out = state[]; // Drive output based on state

endmodule