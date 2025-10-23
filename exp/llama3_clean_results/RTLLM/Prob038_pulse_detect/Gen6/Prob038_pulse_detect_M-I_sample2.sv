module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // Finite state machine state register
parameter IDLE = 2'b00, RISING = 2'b01, HIGH = 2'b10;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE; // Reset FSM to IDLE state
        data_out <= 0; // Reset output to zero
    end else begin
        case (state)
            IDLE: begin
                if (data_in == 1'b1) begin
                    state <= RISING; // Transition to RISING state on 0 to 1
                end else begin
                    state <= IDLE; // Stay in IDLE if data_in remains 0
                end
            end
            RISING: begin
                if (data_in == 1'b1) begin
                    state <= HIGH; // Transition to HIGH state if data_in remains 1
                end else begin
                    state <= IDLE; // Reset to IDLE if data_in goes back to 0 without going high
                end
            end
            HIGH: begin
                if (data_in == 1'b0) begin
                    state <= IDLE; // Transition back to IDLE on 1 to 0
                    data_out <= 1; // Set data_out to 1 at the end of the pulse
                end else begin
                    state <= HIGH; // Stay in HIGH if data_in remains 1
                end
            end
        endcase
        // Reset data_out to 0 unless in the HIGH state transitioning to IDLE
        if (state != HIGH || data_in == 1'b0) begin
            data_out <= 0;
        end
    end
end

endmodule