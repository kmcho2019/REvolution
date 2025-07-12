module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg state; // 1-bit state register to track pulse detection process
reg prev_data_in; // Register to store the previous value of data_in

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Asynchronous reset
        state <= 1'b0; // Initial state
        data_out <= 0;
        prev_data_in <= 0;
    end else begin
        prev_data_in <= data_in;
        
        if (state == 1'b0) begin // IDLE state
            if (data_in && !prev_data_in) begin
                state <= 1'b1; // Transition to HIGH state
            end
            data_out <= 0;
        end else begin // HIGH state
            if (!data_in && prev_data_in) begin
                state <= 1'b0; // Transition back to IDLE state
                data_out <= 1; // Indicate pulse detection
            end else begin
                data_out <= 0;
            end
        end
    end
end

endmodule