module edge_detect (
    input  clk,          // Clock signal
    input  rst_n,        // Reset signal (active low)
    input  a,           // Input signal to detect edges
    output rise,        // Output signal indicating a rising edge
    output down         // Output signal indicating a falling edge
);

// Define the states of the FSM
enum logic [1:0] {
    IDLE,
    RISE_DETECTED,
    FALL_DETECTED
} state, next_state;

// Initialize the output signals to 0
initial begin
    rise = 1'b0;
    down = 1'b0;
end

// Sequential logic to update the state and output signals
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin        // Reset condition
        state <= IDLE;
        rise <= 1'b0;
        down <= 1'b0;
    end else begin
        state <= next_state;
        case (state)
            IDLE: begin
                if (a) begin
                    rise <= 1'b0;
                    down <= 1'b0;
                end
            end
            RISE_DETECTED: begin
                rise <= 1'b1;
                down <= 1'b0;
            end
            FALL_DETECTED: begin
                rise <= 1'b0;
                down <= 1'b1;
            end
        endcase
    end
end

// Combinational logic to determine the next state
always @(*) begin
    case (state)
        IDLE: begin
            if (~a && $stable(a) && $past(a)) begin
                next_state = FALL_DETECTED;
            end else if (a && $stable(a) && !$past(a)) begin
                next_state = RISE_DETECTED;
            end else begin
                next_state = IDLE;
            end
        end
        RISE_DETECTED, FALL_DETECTED: begin
            next_state = IDLE;
        end
    endcase
end

endmodule