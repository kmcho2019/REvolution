module edge_detect(
    input         clk,      // Clock signal
    input         rst_n,    // Reset signal (active low)
    input         a,        // Input signal
    output reg    rise,     // Output signal indicating a rising edge
    output reg    down      // Output signal indicating a falling edge
);

reg [1:0] state;  // Finite state machine state register
reg prev_a;       // Register to store the previous state of 'a'

// Sequential logic to implement the finite state machine
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the module to the initial state
        state <= 2'b00;
        prev_a <= 1'b0;
        rise <= 1'b0;
        down <= 1'b0;
    end else begin
        // Store the previous state of 'a'
        prev_a <= a;

        case (state)
            2'b00: begin  // IDLE state
                if (a &&!prev_a) begin
                    // Rising edge detected, transition to RISE state
                    state <= 2'b01;
                    rise <= 1'b1;
                    down <= 1'b0;
                end else if (!a && prev_a) begin
                    // Falling edge detected, transition to FALL state
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
            2'b01: begin  // RISE state
                // Transition back to IDLE state
                state <= 2'b00;
                rise <= 1'b0;
            end
            2'b10: begin  // FALL state
                // Transition back to IDLE state
                state <= 2'b00;
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