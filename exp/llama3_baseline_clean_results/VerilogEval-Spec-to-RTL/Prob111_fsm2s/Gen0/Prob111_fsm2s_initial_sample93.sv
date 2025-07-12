module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

reg [0:0] state; // Using 1-bit for state (OFF=0, ON=1)
reg [0:0] next_state;

always @(posedge clk) begin
    if (reset) begin
        state <= 1'b0; // Reset to OFF state
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        1'b0: // State OFF
            if (j) begin
                next_state = 1'b1; // Transition to ON
            end else begin
                next_state = 1'b0; // Stay in OFF
            end
        1'b1: // State ON
            if (k) begin
                next_state = 1'b0; // Transition to OFF
            end else begin
                next_state = 1'b1; // Stay in ON
            end
        default:
            next_state = 1'b0; // Should not reach here, default to OFF
    endcase
end

assign out = state; // Output determined directly by state

endmodule