module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 2-bit state register to track pulse detection process

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Asynchronous reset
        state <= 2'b00; // Initial state
        data_out <= 0;
    end else begin
        case (state)
            2'b00: begin // Initial state
                if (data_in) begin
                    state <= 2'b01; // Transition to high state
                end else begin
                    state <= 2'b00; // Stay in initial state
                end
                data_out <= 0;
            end
            2'b01: begin // High state
                if (~data_in) begin
                    state <= 2'b10; // Transition to falling edge state
                end else begin
                    state <= 2'b01; // Stay in high state
                end
                data_out <= 0;
            end
            2'b10: begin // Falling edge state
                state <= 2'b00; // Transition back to initial state
                data_out <= 1; // Indicate pulse detection
            end
        endcase
    end
end

endmodule