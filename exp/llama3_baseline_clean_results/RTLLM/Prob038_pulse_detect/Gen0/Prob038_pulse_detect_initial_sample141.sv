module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 2-bit register to store the current state
localparam IDLE = 2'b00; // Initial state
localparam RISING = 2'b01; // State to detect rising edge
localparam FALLING = 2'b10; // State to detect falling edge

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Reset condition
        state <= IDLE; // Reset state to IDLE
        data_out <= 0; // Reset data_out to 0
    end else begin
        case (state)
            IDLE: begin
                if (data_in) begin // Check for rising edge
                    state <= RISING; // Transition to RISING state
                    data_out <= 0; // Set data_out to 0
                end else begin
                    state <= IDLE; // Remain in IDLE state
                    data_out <= 0; // Set data_out to 0
                end
            end
            RISING: begin
                if (data_in) begin // Check for high value
                    state <= FALLING; // Transition to FALLING state
                    data_out <= 0; // Set data_out to 0
                end else begin
                    state <= IDLE; // Transition back to IDLE state
                    data_out <= 0; // Set data_out to 0
                end
            end
            FALLING: begin
                if (~data_in) begin // Check for low value
                    state <= IDLE; // Transition back to IDLE state
                    data_out <= 1; // Set data_out to 1 (pulse detected)
                end else begin
                    state <= FALLING; // Remain in FALLING state
                    data_out <= 0; // Set data_out to 0
                end
            end
            default: begin
                state <= IDLE; // Default state
                data_out <= 0; // Set data_out to 0
            end
        endcase
    end
end

endmodule