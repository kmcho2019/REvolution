module edge_detect (
    input  clk,          // Clock signal
    input  rst_n,        // Reset signal (active low)
    input  a,           // Input signal to detect edges
    output rise,        // Output signal indicating a rising edge
    output down         // Output signal indicating a falling edge
);

// Define the states of the FSM
enum logic [1:0] {IDLE, EDGE_DETECTED_RISE, EDGE_DETECTED_FALL} state, next_state;

// Initialize the output signals to 0
assign rise = (state == EDGE_DETECTED_RISE) ? 1'b1 : 1'b0;
assign down = (state == EDGE_DETECTED_FALL) ? 1'b1 : 1'b0;

// FSM logic
always_comb begin
    case (state)
        IDLE: begin
            if (a == 1'b1 && $past(a) == 1'b0) begin
                next_state = EDGE_DETECTED_RISE;
            end else if (a == 1'b0 && $past(a) == 1'b1) begin
                next_state = EDGE_DETECTED_FALL;
            end else begin
                next_state = IDLE;
            end
        end
        EDGE_DETECTED_RISE: begin
            next_state = IDLE;
        end
        EDGE_DETECTED_FALL: begin
            next_state = IDLE;
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end

// Sequential logic to update the state
always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

endmodule