module edge_detect(
    input         clk,      // Clock signal
    input         rst_n,    // Reset signal (active low)
    input         a,        // Input signal
    output reg    rise,     // Output signal indicating a rising edge
    output reg    down      // Output signal indicating a falling edge
);

// Define the states of the FSM
enum logic [1:0] {
    IDLE,
    RISING,
    FALLING,
    PULSE
} state, next_state;

// Combinational logic to determine the next state
always_comb begin
    case (state)
        IDLE: begin
            if (a) begin
                next_state = RISING;
            end else if (~a) begin
                next_state = FALLING;
            end else begin
                next_state = IDLE;
            end
        end
        RISING: begin
            next_state = PULSE;
        end
        FALLING: begin
            next_state = PULSE;
        end
        PULSE: begin
            next_state = IDLE;
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end

// Sequential logic to update the current state and set the output signals
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the FSM to the idle state
        state <= IDLE;
        rise <= 1'b0;
        down <= 1'b0;
    end else begin
        // Update the current state
        state <= next_state;
        
        // Set the output signals based on the current state
        case (state)
            RISING: begin
                rise <= 1'b1;
                down <= 1'b0;
            end
            FALLING: begin
                rise <= 1'b0;
                down <= 1'b1;
            end
            PULSE: begin
                rise <= 1'b0;
                down <= 1'b0;
            end
            default: begin
                rise <= 1'b0;
                down <= 1'b0;
            end
        endcase
    end
end

endmodule