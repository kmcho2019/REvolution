module edge_detect(
    input         clk,      // Clock signal
    input         rst_n,    // Reset signal (active low)
    input         a,        // Input signal
    output reg    rise,     // Output signal indicating a rising edge
    output reg    down      // Output signal indicating a falling edge
);

reg [1:0] state;  // Reg to store the current state of the FSM
reg prev_a;       // Reg to store the previous state of 'a'

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the state and previous state
        state <= 2'b00;
        prev_a <= 1'b0;
        rise <= 1'b0;
        down <= 1'b0;
    end else begin
        // Store the current state of 'a' in the previous state reg
        prev_a <= a;

        case (state)
            2'b00: begin  // IDLE state
                if (a && !prev_a) begin
                    // Rising edge detected, transition to EDGE_DETECTED state
                    state <= 2'b01;
                    rise <= 1'b1;
                    down <= 1'b0;
                end else if (!a && prev_a) begin
                    // Falling edge detected, transition to EDGE_DETECTED state
                    state <= 2'b10;
                    rise <= 1'b0;
                    down <= 1'b1;
                end else begin
                    // No edge detected, stay in IDLE state
                    state <= 2'b00;
                    rise <= 1'b0;
                    down <= 1'b0;
                end
            end
            2'b01, 2'b10: begin  // EDGE_DETECTED state
                // Reset the output signals and transition back to IDLE state
                state <= 2'b00;
                rise <= 1'b0;
                down <= 1'b0;
            end
            default: begin
                // Invalid state, reset to IDLE state
                state <= 2'b00;
                rise <= 1'b0;
                down <= 1'b0;
            end
        endcase
    end
end

endmodule