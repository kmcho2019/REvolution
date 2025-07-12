module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 2'b00; // Reset to Idle state
        data_out <= 0;
    end else begin
        case (state)
            2'b00: // Idle state
                if (data_in) begin
                    state <= 2'b01; // Transition to High state
                    data_out <= 0;
                end else begin
                    state <= 2'b00; // Remain in Idle state
                    data_out <= 0;
                end
            2'b01: // High state
                if (~data_in) begin
                    state <= 2'b10; // Transition to PulseEnd state
                    data_out <= 1;
                end else begin
                    state <= 2'b01; // Remain in High state
                    data_out <= 0;
                end
            2'b10: // PulseEnd state
                begin
                    state <= 2'b00; // Transition back to Idle state
                    data_out <= 0;
                end
            default: // Default to Idle state
                begin
                    state <= 2'b00;
                    data_out <= 0;
                end
        endcase
    end
end

endmodule