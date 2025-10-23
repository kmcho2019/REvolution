module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 2-bit state register to keep track of the current state
localparam IDLE = 2'b00, // Initial state
           PULSE_START = 2'b01, // State indicating the start of a pulse
           PULSE_END = 2'b10; // State indicating the end of a pulse

always @(posedge clk, negedge rst_n) begin
    if (~rst_n) begin // Reset condition
        state <= IDLE; // Reset state to initial state
        data_out <= 1'b0; // Reset data_out to 0
    end else begin
        case (state)
            IDLE: begin
                if (data_in == 1'b1) begin // If data_in is 1, move to PULSE_START state
                    state <= PULSE_START;
                    data_out <= 1'b0; // data_out is 0 in this state
                end else begin
                    state <= IDLE; // Stay in IDLE state if data_in is 0
                    data_out <= 1'b0; // data_out remains 0
                end
            end
            PULSE_START: begin
                if (data_in == 1'b1) begin // If data_in is still 1, stay in PULSE_START
                    state <= PULSE_START;
                    data_out <= 1'b0; // data_out is 0 in this state
                end else if (data_in == 1'b0) begin // If data_in goes back to 0, move to PULSE_END state
                    state <= PULSE_END;
                    data_out <= 1'b1; // data_out is 1 in this state
                end
            end
            PULSE_END: begin
                state <= IDLE; // Move back to IDLE state after detecting a pulse
                data_out <= 1'b0; // data_out goes back to 0
            end
            default: begin
                state <= IDLE; // Default case, go back to IDLE state
                data_out <= 1'b0; // data_out is 0 in default case
            end
        endcase
    end
end

endmodule