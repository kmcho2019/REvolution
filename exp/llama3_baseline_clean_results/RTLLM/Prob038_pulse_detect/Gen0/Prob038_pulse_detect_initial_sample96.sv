module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // State register to keep track of the pulse detection process
localparam IDLE = 2'b00; // Idle state
localparam RISING_EDGE = 2'b01; // Rising edge detected state
localparam FALLING_EDGE = 2'b10; // Falling edge detected state

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Reset condition
        state <= IDLE; // Reset the state to IDLE
        data_out <= 1'b0; // Reset data_out to 0
    end else begin
        case (state)
            IDLE: begin
                if (data_in) begin // If data_in is 1, transition to RISING_EDGE
                    state <= RISING_EDGE;
                end else begin // If data_in is 0, stay in IDLE
                    state <= IDLE;
                end
                data_out <= 1'b0; // data_out is 0 in IDLE state
            end
            RISING_EDGE: begin
                if (~data_in) begin // If data_in is 0, transition to FALLING_EDGE
                    state <= FALLING_EDGE;
                end else begin // If data_in is 1, stay in RISING_EDGE
                    state <= RISING_EDGE;
                end
                data_out <= 1'b0; // data_out is 0 in RISING_EDGE state
            end
            FALLING_EDGE: begin
                state <= IDLE; // Transition back to IDLE after detecting a falling edge
                data_out <= 1'b1; // Set data_out to 1 to indicate the end of a pulse
            end
            default: begin // Unused states
                state <= IDLE; // Transition to IDLE
                data_out <= 1'b0; // Reset data_out to 0
            end
        endcase
    end
end

endmodule