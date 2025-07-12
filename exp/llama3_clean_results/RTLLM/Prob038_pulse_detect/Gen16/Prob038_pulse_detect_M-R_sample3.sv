module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Define the states as an enumeration
typedef enum logic [1:0] {
    IDLE,
    RISING_EDGE,
    FALLING_EDGE
} state_type;

reg state_type state; // Register to store the current state

// Sequential logic to update the state register
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Asynchronous reset
        state <= IDLE; // Initial state
    end else begin
        case (state)
            IDLE: begin
                if (data_in) begin // 0 to 1 transition
                    state <= RISING_EDGE; // Move to rising edge state
                end else begin
                    state <= IDLE; // Stay in idle state
                end
            end
            
            RISING_EDGE: begin
                if (data_in) begin // Stay in rising edge state
                    state <= RISING_EDGE;
                end else begin // 1 to 0 transition
                    state <= FALLING_EDGE; // Move to falling edge state
                end
            end
            
            FALLING_EDGE: begin
                state <= IDLE; // Return to idle state
            end
        endcase
    end
end

// Combinational logic to generate the output signal
assign data_out = (state == FALLING_EDGE);

endmodule