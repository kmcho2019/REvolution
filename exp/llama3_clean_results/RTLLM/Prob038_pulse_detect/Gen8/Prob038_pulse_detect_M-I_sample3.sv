module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 2-bit state register to track pulse detection process
reg prev_data_in; // Register to store the previous value of data_in

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Asynchronous reset
        state <= 2'b00; // Initial state
        prev_data_in <= 0;
    end else begin
        prev_data_in <= data_in;
        
        case (state)
            2'b00: begin // IDLE state
                if (data_in && !prev_data_in) begin
                    state <= 2'b01; // Transition to HIGH state
                end else begin
                    state <= 2'b00; // Stay in IDLE state
                end
            end
            2'b01: begin // HIGH state
                if (!data_in && prev_data_in) begin
                    state <= 2'b10; // Transition to PULSE_END state
                end else begin
                    state <= 2'b01; // Stay in HIGH state
                end
            end
            2'b10: begin // PULSE_END state
                state <= 2'b00; // Transition back to IDLE state
            end
            default: state <= 2'b00;
        endcase
    end
end

always @(*) begin
    case (state)
        2'b10: data_out = 1'b1; // Output 1 at the end of a pulse
        default: data_out = 1'b0;
    endcase
end

endmodule