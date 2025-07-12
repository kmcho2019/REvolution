module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 2-bit register to represent the current state
parameter IDLE = 2'b00, RISING = 2'b01, HIGH = 2'b10, FALLING = 2'b11;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE; // Reset to IDLE state
        data_out <= 0; // Reset output to 0
    end else begin
        case (state)
            IDLE: begin
                if (data_in) begin
                    state <= RISING; // Transition to RISING state
                end else begin
                    state <= IDLE; // Stay in IDLE state
                end
                data_out <= 0; // Output 0 in IDLE state
            end
            RISING: begin
                if (data_in) begin
                    state <= HIGH; // Transition to HIGH state
                end else begin
                    state <= IDLE; // Transition back to IDLE state
                end
                data_out <= 0; // Output 0 in RISING state
            end
            HIGH: begin
                if (~data_in) begin
                    state <= FALLING; // Transition to FALLING state
                end else begin
                    state <= HIGH; // Stay in HIGH state
                end
                data_out <= 0; // Output 0 in HIGH state
            end
            FALLING: begin
                if (~data_in) begin
                    data_out <= 1; // Output 1 at the end of a pulse
                    state <= IDLE; // Transition back to IDLE state
                end else begin
                    state <= HIGH; // Transition back to HIGH state
                    data_out <= 0; // Output 0 if not at the end of a pulse
                end
            end
        endcase
    end
end

endmodule