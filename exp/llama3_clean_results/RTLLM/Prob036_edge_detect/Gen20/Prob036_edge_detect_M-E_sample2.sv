module edge_detect(
    input         clk,      // Clock signal
    input         rst_n,    // Reset signal (active low)
    input         a,        // Input signal
    output reg    rise,     // Output signal indicating a rising edge
    output reg    down      // Output signal indicating a falling edge
);

reg prev_a;  // Register to store the previous state of 'a'
reg state;   // Register for the FSM state
reg count;   // Counter to hold output signal high for one clock cycle

// FSM states
localparam IDLE = 1'b0;
localparam EDGE_DETECTED = 1'b1;

// Sequential logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the module to a known state
        prev_a <= 1'b0;
        state <= IDLE;
        count <= 1'b0;
        rise <= 1'b0;
        down <= 1'b0;
    end else begin
        // Store the current state of 'a' in the previous state register
        prev_a <= a;
        
        // FSM logic
        case (state)
            IDLE: begin
                if (a &&!prev_a) begin
                    // Rising edge detected
                    state <= EDGE_DETECTED;
                    rise <= 1'b1;
                    down <= 1'b0;
                    count <= 1'b1;
                end else if (!a && prev_a) begin
                    // Falling edge detected
                    state <= EDGE_DETECTED;
                    rise <= 1'b0;
                    down <= 1'b1;
                    count <= 1'b1;
                end else begin
                    // No edge detected
                    state <= IDLE;
                    rise <= 1'b0;
                    down <= 1'b0;
                end
            end
            EDGE_DETECTED: begin
                if (count) begin
                    // Hold output signal high for one clock cycle
                    count <= 1'b0;
                    state <= IDLE;
                    rise <= 1'b0;
                    down <= 1'b0;
                end
            end
            default: begin
                state <= IDLE;
                rise <= 1'b0;
                down <= 1'b0;
            end
        endcase
    end
end

endmodule