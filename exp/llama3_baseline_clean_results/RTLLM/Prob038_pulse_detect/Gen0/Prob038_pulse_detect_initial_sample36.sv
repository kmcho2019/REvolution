module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output data_out
);

// Define the states of the finite state machine
enum logic [1:0] {
    IDLE = 2'b00,
    RISING = 2'b01,
    FALLING = 2'b10
} state, next_state;

// Always block for sequential logic
always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the state machine to the initial state
        state <= IDLE;
        data_out <= 0;
    end else begin
        // Update the state based on the current state and input signal
        state <= next_state;
        case (state)
            IDLE: begin
                // Wait for the input signal to rise
                if (data_in) begin
                    next_state <= RISING;
                    data_out <= 0;
                end else begin
                    next_state <= IDLE;
                    data_out <= 0;
                end
            end
            RISING: begin
                // Wait for the input signal to fall
                if (~data_in) begin
                    next_state <= FALLING;
                    data_out <= 0;
                end else begin
                    next_state <= RISING;
                    data_out <= 0;
                end
            end
            FALLING: begin
                // Check if the current cycle is the last cycle of the "pulse"
                if (~data_in) begin
                    next_state <= IDLE;
                    data_out <= 1;
                end else begin
                    next_state <= FALLING;
                    data_out <= 0;
                end
            end
            default: begin
                next_state <= IDLE;
                data_out <= 0;
            end
        endcase
    end
end

endmodule