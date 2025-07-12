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

always @(posedge clk) begin
    if (~rst_n) begin // Reset condition
        state <= IDLE;
        data_out <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data_in) begin // data_in rises
                    state <= RISING;
                end
                data_out <= 0;
            end
            RISING: begin
                if (data_in) begin // data_in remains high
                    state <= HIGH;
                end else begin
                    state <= IDLE; // Back to IDLE if data_in falls immediately
                end
                data_out <= 0;
            end
            HIGH: begin
                if (~data_in) begin // data_in falls
                    state <= FALLING;
                end
                data_out <= 0;
            end
            FALLING: begin
                state <= IDLE;
                if (~data_in) begin // data_in is low, end of pulse
                    data_out <= 1; // Set data_out to 1 to indicate pulse
                end else begin
                    data_out <= 0;
                end
            end
        endcase
    end
end

endmodule