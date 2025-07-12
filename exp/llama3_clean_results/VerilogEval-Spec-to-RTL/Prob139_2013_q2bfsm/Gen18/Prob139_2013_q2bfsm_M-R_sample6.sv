module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

typedef enum logic [1:0] {
    S_RESET,
    S_DETECT_X,
    S_WAIT_FOR_Y
} state_t;

reg [1:0] x_counter; // Counts correct 'x' sequence elements
reg [1:0] y_counter; // Counts clocks after 'x' sequence is detected
state_t current_state; // Current state of the FSM
reg next_g; // Next value of g

// Combinational logic: compute next state and output values
always @ (*) begin
    case (current_state)
        S_RESET: begin
            f = 1; // Set f high for one clock cycle
            if (resetn) begin
                current_state = S_DETECT_X;
            end else begin
                current_state = S_RESET;
            end
        end
        S_DETECT_X: begin
            f = 0; // Ensure f is low after the first clock cycle
            if (x) begin
                if (x_counter == 0) begin
                    x_counter = 1; // First 'x' in sequence
                end else if (x_counter == 2) begin
                    current_state = S_WAIT_FOR_Y; // Move to wait for y state
                    x_counter = 0;
                end
            end else if (x_counter == 1) begin
                if (x == 0) begin
                    x_counter = 2; // Second 'x' in sequence (should be 0)
                end else begin
                    x_counter = 0; // Reset x_counter
                end
            end else begin
                x_counter = 0; // Reset x_counter
            end
        end
        S_WAIT_FOR_Y: begin
            f = 0; // Ensure f is low
            if (y) begin
                next_g = 1; // Set g high if y occurs
            end else begin
                y_counter = y_counter + 1;
                if (y_counter == 2) begin
                    next_g = 0; // Set g low if y doesn't occur within 2 clocks
                end
            end
        end
    endcase
end

// Sequential logic: update state and output registers
always @ (posedge clk) begin
    if (!resetn) begin
        current_state <= S_RESET;
        x_counter <= 0;
        y_counter <= 0;
        g <= 0;
    end else begin
        x_counter <= x_counter;
        y_counter <= y_counter;
        g <= next_g;
    end
end

assign f = (current_state == S_RESET) ? 1 : 0; // Set f high only in reset state

endmodule