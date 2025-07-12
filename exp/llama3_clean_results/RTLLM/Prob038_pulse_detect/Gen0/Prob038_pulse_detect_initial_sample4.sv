module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 2-bit register to keep track of the current state
localparam IDLE = 2'b00; // Initial state
localparam RISING = 2'b01; // State after data_in rises
localparam HIGH = 2'b10; // State after data_in remains high
localparam FALLING = 2'b11; // State after data_in falls

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Reset condition
        state <= IDLE;
        data_out <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data_in) begin // data_in rises
                    state <= RISING;
                    data_out <= 0;
                end else begin
                    state <= IDLE; // Stay in IDLE if data_in is 0
                    data_out <= 0;
                end
            end
            RISING: begin
                if (data_in) begin // data_in remains high
                    state <= HIGH;
                    data_out <= 0;
                end else begin
                    state <= IDLE; // Back to IDLE if data_in falls immediately
                    data_out <= 0;
                end
            end
            HIGH: begin
                if (~data_in) begin // data_in falls
                    state <= FALLING;
                    data_out <= 0;
                end else begin
                    state <= HIGH; // Stay in HIGH if data_in remains high
                    data_out <= 0;
                end
            end
            FALLING: begin
                if (~data_in) begin // data_in is low, end of pulse
                    state <= IDLE;
                    data_out <= 1; // Set data_out to 1 to indicate pulse
                end else begin
                    state <= IDLE; // If data_in rises again, back to IDLE
                    data_out <= 0;
                end
            end
        endcase
    end
end

endmodule