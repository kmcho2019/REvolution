module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 2-bit register to keep track of the current state
localparam IDLE = 2'b00; // Initial state
localparam RISE = 2'b01; // State after the first rising edge of "data_in"
localparam FALL = 2'b10; // State after the falling edge of "data_in"

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Reset condition
        state <= IDLE; // Set the state register to the initial state
        data_out <= 0; // Set the data_out output to 0, indicating no pulse
    end else begin
        case (state)
            IDLE: begin
                if (data_in) begin // Check if "data_in" is high
                    state <= RISE; // Transition to the RISE state
                    data_out <= 0; // Set data_out to 0
                end else begin
                    state <= IDLE; // Stay in the IDLE state
                    data_out <= 0; // Set data_out to 0
                end
            end
            RISE: begin
                if (~data_in) begin // Check if "data_in" is low
                    state <= FALL; // Transition to the FALL state
                    data_out <= 1; // Set data_out to 1, indicating the end of a pulse
                end else begin
                    state <= RISE; // Stay in the RISE state
                    data_out <= 0; // Set data_out to 0
                end
            end
            FALL: begin
                state <= IDLE; // Transition back to the IDLE state
                data_out <= 0; // Set data_out to 0
            end
            default: begin
                state <= IDLE; // Default state
                data_out <= 0; // Set data_out to 0
            end
        endcase
    end
end

endmodule