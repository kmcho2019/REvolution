module edge_detect(
    input         clk,      // Clock signal
    input         rst_n,    // Reset signal (active low)
    input         a,        // Input signal
    output reg    rise,     // Output signal indicating a rising edge
    output reg    down      // Output signal indicating a falling edge
);

reg [1:0] state;  // Finite State Machine state register
                // 0: Idle state
                // 1: Rising edge detected
                // 2: Falling edge detected

// Sequential logic for FSM state transitions and reset
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset FSM state and output signals
        state <= 0;
        rise <= 0;
        down <= 0;
    end else begin
        case (state)
            0: begin  // Idle state
                if (a) begin
                    // Rising edge detected, transition to state 1
                    state <= 1;
                    rise <= 1;
                    down <= 0;
                end else if (~a) begin
                    // Falling edge detected, transition to state 2
                    state <= 2;
                    rise <= 0;
                    down <= 1;
                end else begin
                    // No edge detected, remain in idle state
                    state <= 0;
                    rise <= 0;
                    down <= 0;
                end
            end
            1: begin  // Rising edge detected state
                // Reset edge signal after one clock cycle
                state <= 0;
                rise <= 0;
                down <= 0;
            end
            2: begin  // Falling edge detected state
                // Reset edge signal after one clock cycle
                state <= 0;
                rise <= 0;
                down <= 0;
            end
            default: begin
                state <= 0;
                rise <= 0;
                down <= 0;
            end
        endcase
    end
end

endmodule