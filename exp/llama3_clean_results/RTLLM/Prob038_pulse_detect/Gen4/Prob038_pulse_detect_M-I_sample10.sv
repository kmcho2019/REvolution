module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // FSM states: 0 - idle, 1 - start detected, 2 - pulse detected
reg data_out_int; // Internal output signal

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 2'b00; // Reset state to idle
        data_out_int <= 0; // Reset output to zero
    end else begin
        case (state)
            2'b00: // Idle state
                if (data_in) begin
                    state <= 2'b01; // Move to start detected state
                    data_out_int <= 0;
                end else begin
                    state <= 2'b00; // Stay in idle state
                    data_out_int <= 0;
                end
            2'b01: // Start detected state
                if (data_in) begin
                    state <= 2'b01; // Stay in start detected state
                    data_out_int <= 0;
                end else begin
                    state <= 2'b10; // Move to pulse detected state
                    data_out_int <= 1; // Set output to 1
                end
            2'b10: // Pulse detected state
                if (data_in) begin
                    state <= 2'b01; // Move back to start detected state
                    data_out_int <= 0;
                end else begin
                    state <= 2'b00; // Move to idle state
                    data_out_int <= 0;
                end
            default: begin
                state <= 2'b00; // Default to idle state
                data_out_int <= 0;
            end
        endcase
    end
end

assign data_out = data_out_int;

endmodule