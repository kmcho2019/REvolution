module edge_detect(
    input         clk,      // Clock signal
    input         rst_n,    // Reset signal (active low)
    input         a,        // Input signal
    output reg    rise,     // Output signal indicating a rising edge
    output reg    down      // Output signal indicating a falling edge
);

// Define the states of the finite state machine
enum logic [1:0] {IDLE, DETECTED_RISE, DETECTED_FALL} state, next_state;

// Gray code counter to store the previous state of 'a'
reg prev_a;

// Sequential logic for the finite state machine
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE;
        prev_a <= 1'b0;
        rise <= 1'b0;
        down <= 1'b0;
    end else begin
        state <= next_state;
        prev_a <= a;
    end
end

// Combinational logic for the finite state machine
always @(*) begin
    case (state)
        IDLE: begin
            if (a && !prev_a) begin
                next_state = DETECTED_RISE;
            end else if (!a && prev_a) begin
                next_state = DETECTED_FALL;
            end else begin
                next_state = IDLE;
            end
            rise = (state == DETECTED_RISE) ? 1'b1 : 1'b0;
            down = (state == DETECTED_FALL) ? 1'b1 : 1'b0;
        end
        DETECTED_RISE: begin
            next_state = IDLE;
            rise = 1'b1;
            down = 1'b0;
        end
        DETECTED_FALL: begin
            next_state = IDLE;
            rise = 1'b0;
            down = 1'b1;
        end
    endcase
end

endmodule