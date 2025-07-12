module edge_detect(
    input         clk,      // Clock signal
    input         rst_n,    // Reset signal (active low)
    input         a,        // Input signal
    output        rise,     // Output signal indicating a rising edge
    output        down      // Output signal indicating a falling edge
);

reg [1:0] state;  // Finite State Machine (FSM) states: IDLE (0), EDGE_DETECTED_RISE (1), EDGE_DETECTED_FALL (2)
reg prev_a;  // Register to store the previous state of 'a'

// Initialize the FSM state and the previous state of 'a'
initial begin
    state = 0;
    prev_a = 1'b0;
end

// Sequential logic for the FSM
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the FSM and the previous state of 'a'
        state <= 0;
        prev_a <= 1'b0;
    end else begin
        // Store the current state of 'a' in the previous state register
        prev_a <= a;
        
        case (state)
            0: begin  // IDLE state
                if (a == 1'b1 && prev_a == 1'b0) begin
                    // Rising edge detected, move to EDGE_DETECTED_RISE state
                    state <= 1;
                end else if (a == 1'b0 && prev_a == 1'b1) begin
                    // Falling edge detected, move to EDGE_DETECTED_FALL state
                    state <= 2;
                end else begin
                    // No edge detected, stay in IDLE state
                    state <= 0;
                end
            end
            1: begin  // EDGE_DETECTED_RISE state
                // Set the rise output signal to 1 and move back to IDLE state
                state <= 0;
            end
            2: begin  // EDGE_DETECTED_FALL state
                // Set the down output signal to 1 and move back to IDLE state
                state <= 0;
            end
        endcase
    end
end

// Combinational logic for output signals
assign rise = (state == 1);
assign down = (state == 2);

endmodule