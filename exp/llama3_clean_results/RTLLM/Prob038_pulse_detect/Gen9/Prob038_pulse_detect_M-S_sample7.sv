module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 2-bit state register to track pulse detection process
reg [1:0] counter; // Counter to track duration of high state

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Asynchronous reset
        state <= 2'b00; // Initial state
        counter <= 2'b00;
        data_out <= 1'b0;
    end else begin
        case(state)
            2'b00: begin // IDLE state
                if (data_in) begin
                    state <= 2'b01; // Transition to HIGH state
                    counter <= 2'b01;
                end else begin
                    state <= 2'b00; // Stay in IDLE state
                    data_out <= 1'b0; // No pulse detected
                end
            end
            2'b01: begin // HIGH state
                counter <= counter + 1'b1;
                if (~data_in && counter <= 2'b11) begin
                    state <= 2'b00; // Transition back to IDLE state
                    data_out <= 1'b1; // Pulse detected
                end else if (counter > 2'b11) begin
                    state <= 2'b00; // Transition back to IDLE state
                    data_out <= 1'b0; // No pulse detected
                end else begin
                    state <= 2'b01; // Stay in HIGH state
                    data_out <= 1'b0; // No pulse detected
                end
            end
            default: state <= 2'b00;
        endcase
    end
end

endmodule