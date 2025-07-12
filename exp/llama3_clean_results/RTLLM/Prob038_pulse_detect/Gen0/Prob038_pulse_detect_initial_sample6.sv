module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output data_out
);

// Define the states of the FSM
enum logic [1:0] {IDLE, RISING, HIGH, FALLING} state, next_state;

// Always block for sequential logic
always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the state and output
        state <= IDLE;
        data_out <= 0;
    end else begin
        // Update the state and output
        state <= next_state;
        case (state)
            IDLE: begin
                if (data_in) begin
                    next_state <= RISING;
                    data_out <= 0;
                end else begin
                    next_state <= IDLE;
                    data_out <= 0;
                end
            end
            RISING: begin
                if (data_in) begin
                    next_state <= HIGH;
                    data_out <= 0;
                end else begin
                    next_state <= IDLE;
                    data_out <= 0;
                end
            end
            HIGH: begin
                if (~data_in) begin
                    next_state <= FALLING;
                    data_out <= 1;
                end else begin
                    next_state <= HIGH;
                    data_out <= 0;
                end
            end
            FALLING: begin
                next_state <= IDLE;
                data_out <= 0;
            end
        endcase
    end
end

endmodule