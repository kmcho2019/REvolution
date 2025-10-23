module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // State machine to track pulse detection
reg prev_data_in; // Store the previous value of data_in

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 2'b00; // Reset state to initial
        prev_data_in <= 0; // Reset previous data_in
    end else begin
        prev_data_in <= data_in; // Update previous data_in
        
        case (state)
            2'b00: // Initial state: waiting for rising edge
                if (prev_data_in == 1'b0 && data_in == 1'b1) begin
                    state <= 2'b01; // Move to next state
                end
            2'b01: // Middle state: waiting for signal to remain high
                if (data_in == 1'b1) begin
                    state <= 2'b10; // Move to next state
                end else if (data_in == 1'b0) begin
                    state <= 2'b00; // Reset state if signal goes low too early
                end
            2'b10: // Final state: detecting falling edge and setting output high
                if (prev_data_in == 1'b1 && data_in == 1'b0) begin
                    state <= 2'b00; // Reset state after detecting pulse
                end else if (data_in == 1'b1) begin
                    state <= 2'b10; // Stay in final state if signal remains high
                end
            default:
                state <= 2'b00; // Default: reset state
        endcase
    end
end

// Combinational logic to set data_out based on state
assign data_out = (state == 2'b10 && prev_data_in == 1'b1 && data_in == 1'b0);

endmodule