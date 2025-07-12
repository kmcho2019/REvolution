module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // Finite state machine state register
parameter IDLE = 2'b00, RISING = 2'b01, FALLING = 2'b10;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE; // Reset FSM to IDLE state
        data_out <= 0; // Reset output to zero
    end else begin
        case (state)
            IDLE: begin
                if (data_in == 1'b1) begin
                    state <= RISING; // Transition to RISING state on 0 to 1
                end
            end
            RISING: begin
                if (data_in == 1'b0) begin
                    state <= FALLING; // Transition to FALLING state on 1 to 0
                    data_out <= 1; // Set data_out to 1 at the end of the pulse
                end else begin
                    state <= IDLE; // Reset to IDLE if no falling edge
                end
            end
            FALLING: begin
                state <= IDLE; // Return to IDLE state
                data_out <= 0; // Reset data_out
            end
        endcase
    end
end

endmodule