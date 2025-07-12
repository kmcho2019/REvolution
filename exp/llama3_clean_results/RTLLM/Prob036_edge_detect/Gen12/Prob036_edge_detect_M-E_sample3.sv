module edge_detect(
    input         clk,      // Clock signal
    input         rst_n,    // Reset signal (active low)
    input         a,        // Input signal
    output reg    rise,     // Output signal indicating a rising edge
    output reg    down      // Output signal indicating a falling edge
);

reg [1:0] state;  // Finite state machine state register
reg prev_a;        // Register to store the previous state of 'a'

// Sequential logic for finite state machine
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the module to the IDLE state
        state <= 2'b00;
        prev_a <= 1'b0;
        rise <= 1'b0;
        down <= 1'b0;
    end else begin
        case (state)
            2'b00: begin  // IDLE state
                prev_a <= a;
                if (a != prev_a) begin
                    // Transition to EDGE_DETECT state
                    state <= 2'b01;
                end
                rise <= 1'b0;
                down <= 1'b0;
            end
            2'b01: begin  // EDGE_DETECT state
                if (a == 1'b1) begin
                    // Rising edge detected
                    rise <= 1'b1;
                    down <= 1'b0;
                end else begin
                    // Falling edge detected
                    rise <= 1'b0;
                    down <= 1'b1;
                end
                // Return to IDLE state
                state <= 2'b00;
            end
            default: begin
                // Invalid state, reset to IDLE
                state <= 2'b00;
                prev_a <= 1'b0;
                rise <= 1'b0;
                down <= 1'b0;
            end
        endcase
    end
end

endmodule