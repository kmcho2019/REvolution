// TopModule: A Mealy-type finite state machine that recognizes the sequence "101" on the input signal x.
module TopModule(
    input  clk,       // Clock signal
    input  aresetn,   // Asynchronous reset signal (active low)
    input  x,         // Input signal to detect the sequence "101"
    output z          // Output signal to indicate the detection of the sequence "101"
);

// Enum for the states of the FSM
typedef enum logic [1:0] {
    IDLE,
    SEEN_1,
    SEEN_10
} state_t;

// Current state
reg state_t current_state;

// Next state logic
always @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
        // Asynchronous reset
        current_state <= IDLE;
    end else begin
        case (current_state)
            IDLE: begin
                if (x) begin
                    current_state <= SEEN_1;
                end else begin
                    current_state <= IDLE;
                end
            end
            SEEN_1: begin
                if (!x) begin
                    current_state <= SEEN_10;
                end else begin
                    current_state <= SEEN_1;
                end
            end
            SEEN_10: begin
                if (x) begin
                    current_state <= SEEN_1;
                end else begin
                    current_state <= IDLE;
                end
            end
            default: current_state <= IDLE;
        endcase
    end
end

// Output logic: Assert z when the current state is SEEN_10 and the input x is 1
assign z = (current_state == SEEN_10) && x;

endmodule