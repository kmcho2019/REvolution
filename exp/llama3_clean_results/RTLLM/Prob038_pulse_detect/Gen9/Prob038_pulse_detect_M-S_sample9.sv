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
                    state <= 2'b01; // Transition to PULSE state
                    counter <= 2'b01;
                end
            end
            2'b01: begin // PULSE state
                counter <= counter + 1'b1;
                if (~data_in) begin
                    data_out <= 1'b1; // Pulse detected
                    state <= 2'b00; // Transition back to IDLE state
                end else if (counter == 2'b11) begin
                    state <= 2'b00; // Timeout, transition back to IDLE state
                end
            end
            default: state <= 2'b00;
        endcase
        if (state == 2'b00) begin
            data_out <= 1'b0; // Reset output if in IDLE state
        end else if (counter == 2'b10) begin
            data_out <= 1'b0; // Reset output after pulse detection
        end
    end
end

endmodule