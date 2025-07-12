module edge_detect(
    input         clk,      // Clock signal
    input         rst_n,    // Reset signal (active low)
    input         a,        // Input signal
    output        rise,     // Output signal indicating a rising edge
    output        down      // Output signal indicating a falling edge
);

// Enumerate the states of the FSM
enum logic [1:0] {IDLE, RISING, FALLING} state, next_state;

// Sequential logic for the FSM
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the FSM to the IDLE state
        state <= IDLE;
        rise <= 1'b0;
        down <= 1'b0;
    end else begin
        // Update the state and outputs based on the next state
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
            RISING: begin
                rise <= 1'b1;
                down <= 1'b0;
            end
            FALLING: begin
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
            if (a) begin
                next_state = RISING;
            end else if (~a) begin
                next_state = FALLING;
            end else begin
                next_state = IDLE;
            end
        end
        RISING: begin
            if (~a) begin
                next_state = FALLING;
            end else begin
                next_state = IDLE;
            end
        end
        FALLING: begin
            if (a) begin
                next_state = RISING;
            end else begin
                next_state = IDLE;
            end
        end
    endcase
end

endmodule