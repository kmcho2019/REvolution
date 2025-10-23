module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 2-bit state register to track pulse detection process
reg [1:0] counter; // Counter to track clock cycles since start of pulse
reg prev_data_in; // Register to store the previous value of data_in

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Asynchronous reset
        state <= 2'b00; // Initial state: WAIT_FOR_RISING_EDGE
        counter <= 2'b00;
        prev_data_in <= 1'b0;
    end else begin
        prev_data_in <= data_in;
        
        case (state)
            2'b00: begin // WAIT_FOR_RISING_EDGE
                if (data_in && !prev_data_in) begin
                    state <= 2'b01; // Transition to WAIT_FOR_FALLING_EDGE
                    counter <= 2'b01;
                end else begin
                    state <= 2'b00; // Stay in WAIT_FOR_RISING_EDGE
                end
            end
            2'b01: begin // WAIT_FOR_FALLING_EDGE
                if (!data_in && prev_data_in) begin
                    state <= 2'b10; // Transition to OUTPUT_PULSE
                end else if (data_in && prev_data_in) begin
                    state <= 2'b01; // Stay in WAIT_FOR_FALLING_EDGE
                    counter <= counter + 1'b1;
                end else if (!data_in && !prev_data_in) begin
                    state <= 2'b00; // Transition back to WAIT_FOR_RISING_EDGE
                end
            end
            2'b10: begin // OUTPUT_PULSE
                state <= 2'b00; // Transition back to WAIT_FOR_RISING_EDGE
            end
        endcase
    end
end

always @(*) begin
    case (state)
        2'b00: data_out = 1'b0;
        2'b01: data_out = 1'b0;
        2'b10: data_out = 1'b1;
        default: data_out = 1'b0;
    endcase
end

endmodule