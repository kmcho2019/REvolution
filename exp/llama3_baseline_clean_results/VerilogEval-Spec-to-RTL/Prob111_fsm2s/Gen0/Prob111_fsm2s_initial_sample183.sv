module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);

reg [0:0] state; // We're using 1 bit to represent two states: 0 for OFF and 1 for ON
reg [0:0] next_state;

always @(*) begin
    case(state)
        0: // State OFF
            if(j) begin
                next_state = 1; // Transition to ON when j is 1
            end else begin
                next_state = 0; // Stay in OFF when j is 0
            end
        1: // State ON
            if(k) begin
                next_state = 0; // Transition to OFF when k is 1
            end else begin
                next_state = 1; // Stay in ON when k is 0
            end
    endcase
end

always @(posedge clk) begin
    if(reset) begin
        state <= 0; // Reset to OFF state
    end else begin
        state <= next_state; // Update state on each clock cycle
    end
end

assign out = state; // Output is the current state

endmodule