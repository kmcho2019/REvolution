module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 2-bit state register to track the pulse detection process
reg prev_data_in; // Register to hold the previous value of data_in

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 2'b00; // Reset state to initial state
        prev_data_in <= 1'b0; // Reset previous data_in to 0
        data_out <= 1'b0; // Reset output to 0
    end else begin
        prev_data_in <= data_in; // Update previous data_in
        case(state)
            2'b00: begin // Initial state
                if (data_in == 1'b1) begin
                    state <= 2'b01; // Move to state 1 if data_in is 1
                end else begin
                    state <= 2'b00; // Stay in initial state if data_in is 0
                end
                data_out <= 1'b0; // Output is 0 in initial state
            end
            2'b01: begin // State 1: data_in was 1 in the previous cycle
                if (data_in == 1'b0) begin
                    state <= 2'b10; // Move to state 2 if data_in becomes 0
                end else begin
                    state <= 2'b01; // Stay in state 1 if data_in is still 1
                end
                data_out <= 1'b0; // Output is 0 in state 1
            end
            2'b10: begin // State 2: pulse detected
                state <= 2'b00; // Reset state to initial state
                data_out <= 1'b1; // Output is 1 when pulse is detected
            end
            default: begin // Default state
                state <= 2'b00; // Reset state to initial state
                data_out <= 1'b0; // Output is 0 in default state
            end
        endcase
    end
end

endmodule