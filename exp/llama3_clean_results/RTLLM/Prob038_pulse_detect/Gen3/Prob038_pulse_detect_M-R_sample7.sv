module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Using one-hot encoding for states
reg [3:0] state; // 4-bit register to keep track of the current state
localparam IDLE = 4'b0001; // Initial state
localparam RISING = 4'b0010; // State after data_in rises
localparam HIGH = 4'b0100; // State after data_in remains high
localparam FALLING = 4'b1000; // State after data_in falls

// Synchronous reset
always @(posedge clk) begin
    if (~rst_n) begin // Synchronous reset
        state <= IDLE;
        data_out <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data_in) begin // data_in rises
                    state <= RISING;
                end else begin
                    state <= IDLE; // Stay in IDLE if data_in is 0
                end
                data_out <= 0; // Reset data_out in all states except FALLING
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