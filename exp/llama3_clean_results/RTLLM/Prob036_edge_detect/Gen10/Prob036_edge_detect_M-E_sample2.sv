module edge_detect(
    input         clk,      // Clock signal
    input         rst_n,    // Reset signal (active low)
    input         a,        // Input signal
    output reg    rise,     // Output signal indicating a rising edge
    output reg    down      // Output signal indicating a falling edge
);

// Enumerate the states of the FSM
enum logic [1:0] {IDLE, RISING_EDGE, FALLING_EDGE} state, next_state;

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
                if (a) begin
                    rise <= 1'b1;
                    down <= 1'b0;
                end else begin
                    rise <= 1'b0;
                    down <= 1'b1;
                end
            end
            RISING_EDGE: begin
                rise <= 1'b0;
                down <= 1'b0;
            end
            FALLING_EDGE: begin
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

// Combinational logic for next state calculation
always @(*) begin
    case (state)
        IDLE: begin
            if (a && ~prev_a) begin
                next_state = RISING_EDGE;
            end else if (~a && prev_a) begin
                next_state = FALLING_EDGE;
            end else begin
                next_state = IDLE;
            end
        end
        RISING_EDGE: begin
            next_state = IDLE;
        end
        FALLING_EDGE: begin
            next_state = IDLE;
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end

reg prev_a;  // Register to store the previous state of 'a'
always @(posedge clk) begin
    prev_a <= a;
end

endmodule