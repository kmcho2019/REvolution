module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 2-bit state register
parameter IDLE = 2'b00; // Initial state
parameter RISING = 2'b01; // State for detecting rising edge
parameter FALLING = 2'b10; // State for detecting falling edge

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE; // Reset state to IDLE
        data_out <= 0; // Reset output to 0
    end else begin
        case (state)
            IDLE: begin
                if (data_in) begin
                    state <= RISING; // Transition to RISING if data_in is 1
                end else begin
                    state <= IDLE; // Stay in IDLE if data_in is 0
                end
                data_out <= 0; // Output is 0 in IDLE state
            end
            RISING: begin
                if (~data_in) begin
                    state <= FALLING; // Transition to FALLING if data_in is 0
                end else begin
                    state <= RISING; // Stay in RISING if data_in is 1
                end
                data_out <= 0; // Output is 0 in RISING state
            end
            FALLING: begin
                state <= IDLE; // Transition back to IDLE
                data_out <= 1; // Output is 1 at the end of a pulse
            end
            default: begin
                state <= IDLE; // Default state is IDLE
                data_out <= 0; // Default output is 0
            end
        endcase
    end
end

endmodule