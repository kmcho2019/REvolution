module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

// Define the states explicitly
localparam STATE_OFF = 0;
localparam STATE_ON  = 1;

reg state; // State register, 0 for OFF, 1 for ON

// Next state logic
always @(posedge clk) begin
    if (reset) begin
        // Reset to OFF state
        state <= STATE_OFF;
    end else begin
        case (state)
            STATE_OFF: begin
                // Transition from OFF to ON when j is 1
                if (j) state <= STATE_ON;
                // Stay in OFF state when j is 0
                else state <= STATE_OFF;
            end
            STATE_ON: begin
                // Transition from ON to OFF when k is 1
                if (k) state <= STATE_OFF;
                // Stay in ON state when k is 0
                else state <= STATE_ON;
            end
            default: state <= STATE_OFF; // Default to OFF state
        endcase
    end
end

// Output is directly the current state
assign out = (state == STATE_ON)? 1'b1 : 1'b0;

endmodule