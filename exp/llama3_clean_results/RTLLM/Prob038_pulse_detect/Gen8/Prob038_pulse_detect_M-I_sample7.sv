module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Define states for the finite state machine
enum logic [1:0] {
    IDLE = 2'b00,
    HIGH = 2'b01,
    FALLING = 2'b10
} state, next_state;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset to IDLE state and set output to 0
        state <= IDLE;
        data_out <= 0;
    end else begin
        state <= next_state;
        
        // Set data_out based on the current state
        case (state)
            IDLE: begin
                // Transition to HIGH if data_in goes from 0 to 1
                if (data_in == 1'b1) begin
                    next_state <= HIGH;
                end else begin
                    next_state <= IDLE; // Stay in IDLE
                end
                data_out <= 0; // data_out is 0 in IDLE state
            end
            HIGH: begin
                // Stay in HIGH if data_in remains 1, transition to FALLING if it goes to 0
                if (data_in == 1'b1) begin
                    next_state <= HIGH;
                end else begin
                    next_state <= FALLING;
                end
                data_out <= 0; // data_out remains 0 in HIGH state
            end
            FALLING: begin
                // Transition back to IDLE
                next_state <= IDLE;
                data_out <= 1; // Set data_out to 1 in FALLING state
            end
        endcase
    end
end

endmodule