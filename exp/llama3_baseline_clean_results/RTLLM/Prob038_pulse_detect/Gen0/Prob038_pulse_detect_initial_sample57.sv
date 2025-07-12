module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 2-bit register to keep track of the current state
parameter IDLE = 2'b00; // Initial state
parameter RISING = 2'b01; // State when data_in rises
parameter HIGH = 2'b10; // State when data_in is high
parameter FALLING = 2'b11; // State when data_in falls after a high

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Reset condition
        state <= IDLE; // Set state to initial state
        data_out <= 0; // Set data_out to 0
    end else begin
        case (state)
            IDLE: begin
                if (data_in) begin // If data_in rises
                    state <= RISING; // Transition to RISING state
                    data_out <= 0; // Set data_out to 0
                end else begin
                    state <= IDLE; // Stay in IDLE state
                    data_out <= 0; // Set data_out to 0
                end
            end
            RISING: begin
                if (data_in) begin // If data_in is still high
                    state <= HIGH; // Transition to HIGH state
                    data_out <= 0; // Set data_out to 0
                end else begin
                    state <= IDLE; // Transition back to IDLE state
                    data_out <= 0; // Set data_out to 0
                end
            end
            HIGH: begin
                if (~data_in) begin // If data_in falls
                    state <= FALLING; // Transition to FALLING state
                    data_out <= 1; // Set data_out to 1 (indicating a pulse)
                end else begin
                    state <= HIGH; // Stay in HIGH state
                    data_out <= 0; // Set data_out to 0
                end
            end
            FALLING: begin
                state <= IDLE; // Transition back to IDLE state
                data_out <= 0; // Set data_out to 0
            end
            default: begin
                state <= IDLE; // Default state is IDLE
                data_out <= 0; // Set data_out to 0
            end
        endcase
    end
end

endmodule