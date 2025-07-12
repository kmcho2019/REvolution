module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 2-bit register to store the current state

localparam IDLE = 2'b00; // Initial state
localparam RISING = 2'b01; // State when data_in rises
localparam FALLING = 2'b10; // State when data_in falls after rising

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
                    state <= IDLE;
                    data_out <= 0;
                end
            end
            RISING: begin
                if (~data_in) begin // data_in falls after rising
                    state <= FALLING;
                end else begin
                    state <= RISING;
                end
                data_out <= 0;
            end
            FALLING: begin
                state <= IDLE;
                data_out <= 1; // Set data_out to 1 to indicate the end of a pulse
            end
            default: begin
                state <= IDLE;
                data_out <= 0;
            end
        endcase
    end
end

endmodule