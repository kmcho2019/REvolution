module edge_detect(
    input         clk,      // Clock signal
    input         rst_n,    // Reset signal (active low)
    input         a,        // Input signal
    output reg    rise,     // Output signal indicating a rising edge
    output reg    down      // Output signal indicating a falling edge
);

// Define the states of the finite state machine
enum logic [1:0] {IDLE, RISING, FALLING} state, next_state;

// Sequential logic for the state machine
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the state machine to the idle state
        state <= IDLE;
        rise <= 1'b0;
        down <= 1'b0;
    end else begin
        // Update the state and output signals based on the next state
        state <= next_state;
        case (next_state)
            RISING: begin
                rise <= 1'b1;
                down <= 1'b0;
            end
            FALLING: begin
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

// Combinational logic for the next state and output signals
always @(*) begin
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
            next_state = IDLE;
        end
        FALLING: begin
            next_state = IDLE;
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end

endmodule