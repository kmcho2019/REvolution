module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // Finite state machine state register
parameter IDLE = 2'b00, RISING = 2'b01, HIGH = 2'b10, FALLING = 2'b11;

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
                data_out <= 0; // data_out should be 0 in IDLE state
            end
            RISING: begin
                if (data_in == 1'b1) begin
                    state <= HIGH; // Transition to HIGH state if data_in remains 1
                end else begin
                    state <= IDLE; // Reset to IDLE if data_in goes back to 0 without going high
                end
                data_out <= 0; // data_out remains 0 in RISING state
            end
            HIGH: begin
                if (data_in == 1'b1) begin
                    state <= HIGH; // Stay in HIGH if data_in remains 1
                end else begin
                    state <= FALLING; // Transition to FALLING state on 1 to 0
                end
                data_out <= 0; // data_out remains 0 in HIGH state
            end
            FALLING: begin
                state <= IDLE; // Transition back to IDLE
                data_out <= 1; // Set data_out to 1 in FALLING state
            end
        endcase
    end
end

endmodule