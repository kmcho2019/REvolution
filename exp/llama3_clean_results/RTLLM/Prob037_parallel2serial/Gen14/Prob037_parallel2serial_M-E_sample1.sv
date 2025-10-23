module parallel2serial (
    input clk,
    input rst_n,
    input [3:0] d,
    output valid_out,
    output dout
);

reg [3:0] state; // One-hot encoding for FSM states
reg [3:0] data_reg; // Register to hold the parallel input

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 4'b0001; // Reset to idle state
        data_reg <= 4'b0000; // Reset data register
    end else begin
        case (state)
            4'b0001: begin // Idle state
                if (d !== 4'b0000) begin // Check if new input is available
                    data_reg <= d; // Load new input into data register
                    state <= 4'b0010; // Transition to first output state
                end
            end
            4'b0010: begin // First output state (MSB)
                state <= 4'b0100; // Transition to next output state
            end
            4'b0100: begin // Second output state
                state <= 4'b1000; // Transition to next output state
            end
            4'b1000: begin // Third output state
                state <= 4'b0001; // Transition back to idle state
            end
            default: begin
                state <= 4'b0001; // Default back to idle state
            end
        endcase
    end
end

assign valid_out = (state !== 4'b0001); // Assert valid signal when in output states
assign dout = (state === 4'b0010) ? data_reg[3] :
              (state === 4'b0100) ? data_reg[2] :
              (state === 4'b1000) ? data_reg[1] : data_reg[0];

endmodule