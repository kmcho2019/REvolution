module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output reg z
);

reg [1:0] state; // Current state of the FSM

// Asynchronous reset
always @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin
        state <= 2'b00;
        z <= 1'b0;
    end else begin
        case(state)
            2'b00: begin // Initial state
                if (x == 1'b1) begin
                    state <= 2'b01; // Move to state 1
                    z <= 1'b0; // Don't assert z yet
                end else begin
                    state <= 2'b00; // Stay in initial state
                    z <= 1'b0; // Don't assert z
                end
            end
            2'b01: begin // State 1
                if (x == 1'b0) begin
                    state <= 2'b10; // Move to state 2
                    z <= 1'b0; // Don't assert z yet
                end else begin
                    state <= 2'b01; // Stay in state 1
                    z <= 1'b0; // Don't assert z
                end
            end
            2'b10: begin // State 2
                if (x == 1'b1) begin
                    z <= 1'b1; // Assert z when '101' sequence is detected
                end else begin
                    z <= 1'b0; // Don't assert z
                end
                if (x == 1'b1) begin
                    state <= 2'b01; // If the sequence is detected, move to state 1
                end else begin
                    state <= 2'b00; // If not, move back to initial state
                end
            end
        endcase
    end
end

endmodule