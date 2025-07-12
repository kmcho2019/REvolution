module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 2'b00; // Reset to Idle state
        data_out <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // Idle state
                if (data_in) begin
                    state <= 2'b01; // Transition to High state
                    data_out <= 1'b0;
                end else begin
                    state <= 2'b00; // Stay in Idle state
                    data_out <= 1'b0;
                end
            end
            2'b01: begin // High state
                if (data_in) begin
                    state <= 2'b01; // Stay in High state
                    data_out <= 1'b0;
                end else begin
                    state <= 2'b10; // Transition to Pulse_Detected state
                    data_out <= 1'b0;
                end
            end
            2'b10: begin // Pulse_Detected state
                state <= 2'b11; // Transition to Data_out_high state
                data_out <= 1'b1;
            end
            2'b11: begin // Data_out_high state
                state <= 2'b00; // Transition back to Idle state
                data_out <= 1'b0;
            end
        endcase
    end
end

endmodule