module edge_detect(
    input         clk,      // Clock signal
    input         rst_n,    // Reset signal (active low)
    input         a,        // Input signal
    output reg    rise,     // Output signal indicating a rising edge
    output reg    down      // Output signal indicating a falling edge
);

// Define the FSM states
enum logic [1:0] {
    IDLE,
    RISE_EDGE,
    FALL_EDGE
} state, next_state;

// Sequential logic for the FSM
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE;
        rise <= 1'b0;
        down <= 1'b0;
    end else begin
        state <= next_state;
        case (state)
            IDLE: begin
                rise <= 1'b0;
                down <= 1'b0;
            end
            RISE_EDGE: begin
                rise <= 1'b1;
                down <= 1'b0;
            end
            FALL_EDGE: begin
                rise <= 1'b0;
                down <= 1'b1;
            end
            default: begin
                rise <= 1'b0;
                down <= 1'b0;
            end
        endcase
    end
end

// Combinational logic to determine the next state
always @(*) begin
    case (state)
        IDLE: begin
            if (a) begin
                // Rising edge detected
                next_state <= RISE_EDGE;
            end else if (!a) begin
                // Falling edge detected
                next_state <= FALL_EDGE;
            end else begin
                next_state <= IDLE;
            end
        end
        RISE_EDGE, FALL_EDGE: begin
            // Stay in the current state for one clock cycle
            next_state <= IDLE;
        end
        default: begin
            next_state <= IDLE;
        end
    endcase
end

endmodule