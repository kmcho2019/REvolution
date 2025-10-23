module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 2-state FSM: IDLE (2'b00) and PULSE (2'b01)
reg prev_data_in; // To track the previous value of data_in

always @(posedge clk) begin
    if (~rst_n) begin // Synchronous reset
        state <= 2'b00; // IDLE state
        data_out <= 0;
        prev_data_in <= 0;
    end else begin
        prev_data_in <= data_in;
        case (state)
            2'b00: begin // IDLE
                if (data_in) begin
                    state <= 2'b01; // Transition to PULSE state
                end
            end
            2'b01: begin // PULSE
                if (~data_in) begin
                    state <= 2'b00; // Return to IDLE
                    data_out <= 1; // Set data_out to 1 at the end of a pulse
                end
            end
            default: state <= 2'b00; // Default to IDLE state
        endcase
    end
end

// Output logic
always @(*) begin
    if (state == 2'b00 && prev_data_in == 1 && ~data_in) begin
        data_out = 1; // Set data_out to 1 at the end of a pulse
    end else begin
        data_out = 0;
    end
end

endmodule