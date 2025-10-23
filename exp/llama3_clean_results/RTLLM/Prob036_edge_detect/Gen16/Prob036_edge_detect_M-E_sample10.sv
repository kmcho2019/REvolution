module edge_detect(
    input         clk,      // Clock signal
    input         rst_n,    // Reset signal (active low)
    input         a,        // Input signal
    output reg    rise,     // Output signal indicating a rising edge
    output reg    down      // Output signal indicating a falling edge
);

// Define the states of the FSM
localparam LOW = 1'b0;
localparam HIGH = 1'b1;

reg current_state;  // Register to store the current state of the FSM
reg next_state;     // Register to store the next state of the FSM

// Sequential logic to store the current state of the FSM
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the FSM to the LOW state
        current_state <= LOW;
        rise <= 1'b0;
        down <= 1'b0;
    end else begin
        // Update the current state of the FSM
        current_state <= next_state;
    end
end

// Combinational logic to generate the next state and output signals
always @(*) begin
    case (current_state)
        LOW: begin
            if (a) begin
                // Rising edge detected, generate 'rise' signal and transition to HIGH state
                rise = 1'b1;
                down = 1'b0;
                next_state = HIGH;
            end else begin
                // No edge detected, stay in LOW state
                rise = 1'b0;
                down = 1'b0;
                next_state = LOW;
            end
        end
        HIGH: begin
            if (~a) begin
                // Falling edge detected, generate 'down' signal and transition to LOW state
                rise = 1'b0;
                down = 1'b1;
                next_state = LOW;
            end else begin
                // No edge detected, stay in HIGH state
                rise = 1'b0;
                down = 1'b0;
                next_state = HIGH;
            end
        end
        default: begin
            // Invalid state, reset to LOW state
            rise = 1'b0;
            down = 1'b0;
            next_state = LOW;
        end
    endcase
end

// Reset the output signals after one clock cycle
always @(posedge clk) begin
    rise <= 1'b0;
    down <= 1'b0;
end

endmodule