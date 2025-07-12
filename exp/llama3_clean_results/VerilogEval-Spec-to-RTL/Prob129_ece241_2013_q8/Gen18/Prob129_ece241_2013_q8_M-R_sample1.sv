module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

reg [1:0] state; // IDLE = 2'b00, ONE_DETECTED = 2'b01, ZERO_DETECTED = 2'b10

// Asynchronous reset
always @(negedge aresetn or posedge clk) begin
    if (!aresetn) begin
        state <= 2'b00; // Reset to IDLE state
    end else begin
        case (state)
            2'b00: begin // IDLE
                if (x) begin
                    state <= 2'b01; // Transition to ONE_DETECTED
                end
            end
            2'b01: begin // ONE_DETECTED
                if (!x) begin
                    state <= 2'b10; // Transition to ZERO_DETECTED
                end else begin
                    state <= 2'b01; // Stay in ONE_DETECTED if another '1' is seen
                end
            end
            2'b10: begin // ZERO_DETECTED
                if (x) begin
                    state <= 2'b01; // Transition back to ONE_DETECTED and assert z
                    // But we actually need to assert z here and then move to ONE_DETECTED
                end else begin
                    state <= 2'b00; // Reset to IDLE if '0' is seen after '0'
                end
            end
            default: state <= 2'b00; // Default to IDLE state
        endcase
    end
end

// Output logic
assign z = (state == 2'b10 && x); // Assert z when in ZERO_DETECTED state and x is '1'

endmodule