module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Using synchronous reset for potential power and area optimization
reg [1:0] state; // 2-bit register to keep track of the current state
localparam IDLE = 2'b00; // Initial state
localparam RISING = 2'b01; // State after data_in rises
localparam HIGH = 2'b10; // State after data_in remains high
localparam FALLING = 2'b11; // State after data_in falls

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin // Synchronous reset
        state <= IDLE;
        data_out <= 0;
    end else begin
        case (state)
            IDLE: begin
                data_out <= 0; // Reset data_out in all states except FALLING
                if (data_in) begin // data_in rises
                    state <= RISING;
                end else begin
                    state <= IDLE; // Stay in IDLE if data_in is 0
                end
            end
            RISING: begin
                if (data_in) begin // data_in remains high
                    state <= HIGH;
                end else begin
                    state <= IDLE; // Back to IDLE if data_in falls immediately
                end
            end
            HIGH: begin
                if (~data_in) begin // data_in falls
                    state <= FALLING;
                end else begin
                    state <= HIGH; // Stay in HIGH if data_in remains high
                end
            end
            FALLING: begin
                data_out <= 1; // Set data_out to 1 to indicate pulse
                state <= IDLE; // Move to IDLE state
            end
        endcase
    end
end

endmodule