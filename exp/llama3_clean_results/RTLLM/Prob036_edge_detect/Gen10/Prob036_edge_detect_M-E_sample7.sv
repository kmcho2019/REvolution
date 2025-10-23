module edge_detect(
    input         clk,      // Clock signal
    input         rst_n,    // Reset signal (active low)
    input         a,        // Input signal
    output reg    rise,     // Output signal indicating a rising edge
    output reg    down      // Output signal indicating a falling edge
);

reg prev_a;  // Register to store the previous state of 'a'
reg [1:0] state;  // Finite State Machine (FSM) state register

// Define FSM states
localparam IDLE = 2'b00;
localparam EDGE_DETECTED_RISE = 2'b01;
localparam EDGE_DETECTED_FALL = 2'b10;

// Sequential logic for FSM and previous state storage
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset FSM and previous state
        state <= IDLE;
        prev_a <= 1'b0;
        rise <= 1'b0;
        down <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (a && !prev_a) begin
                    // Rising edge detected
                    state <= EDGE_DETECTED_RISE;
                    rise <= 1'b1;
                    down <= 1'b0;
                end else if (!a && prev_a) begin
                    // Falling edge detected
                    state <= EDGE_DETECTED_FALL;
                    rise <= 1'b0;
                    down <= 1'b1;
                end else begin
                    // No edge detected
                    state <= IDLE;
                    rise <= 1'b0;
                    down <= 1'b0;
                end
                prev_a <= a;
            end
            EDGE_DETECTED_RISE: begin
                // Return to IDLE state after one clock cycle
                state <= IDLE;
                rise <= 1'b0;
                down <= 1'b0;
                prev_a <= a;
            end
            EDGE_DETECTED_FALL: begin
                // Return to IDLE state after one clock cycle
                state <= IDLE;
                rise <= 1'b0;
                down <= 1'b0;
                prev_a <= a;
            end
            default: begin
                // Invalid state, reset to IDLE
                state <= IDLE;
                rise <= 1'b0;
                down <= 1'b0;
                prev_a <= a;
            end
        endcase
    end
end

endmodule