module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // Declare a 2-bit register for the state machine

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Reset condition
        state <= 2'b00; // Initial state S0
        data_out <= 1'b0; // Reset data_out to 0
    end else begin
        case (state)
            2'b00: begin // State S0: Wait for rising edge of data_in
                if (data_in) begin
                    state <= 2'b01; // Transition to state S1
                    data_out <= 1'b0; // data_out remains 0
                end else begin
                    state <= 2'b00; // Stay in state S0
                    data_out <= 1'b0; // data_out remains 0
                end
            end
            2'b01: begin // State S1: Check if data_in is high
                if (data_in) begin
                    state <= 2'b10; // Transition to state S2
                    data_out <= 1'b0; // data_out remains 0
                end else begin
                    state <= 2'b00; // Transition back to state S0
                    data_out <= 1'b0; // data_out remains 0
                end
            end
            2'b10: begin // State S2: Check if data_in is low (end of pulse)
                if (~data_in) begin
                    state <= 2'b00; // Transition back to state S0
                    data_out <= 1'b1; // Set data_out to 1 (pulse detected)
                end else begin
                    state <= 2'b10; // Stay in state S2
                    data_out <= 1'b0; // data_out remains 0
                end
            end
            default: begin
                state <= 2'b00; // Default state is S0
                data_out <= 1'b0; // data_out remains 0
            end
        endcase
    end
end

endmodule