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
                end
            end
            2'b01: begin // HIGH state
                counter <= counter + 1'b1;
                if (counter == 2'b11) begin
                    state <= 2'b10; // Transition to TIMEOUT state
                end else if (~data_in) begin
                    state <= 2'b00; // Transition back to IDLE state
                    data_out <= 1'b1; // Pulse detected
                end else begin
                    state <= 2'b01; // Stay in HIGH state
                end
            end
            2'b10: begin // TIMEOUT state
                state <= 2'b00; // Transition back to IDLE state
            end
            default: state <= 2'b00;
        endcase
    end
end

always @(posedge clk) begin
    if (state!= 2'b01 && state!= 2'b10) begin
        data_out <= 1'b0; // Reset output if not in HIGH or TIMEOUT state
    end
end

endmodule