module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [2:0] data_in_history; // Shift register to store previous values of data_in
reg [1:0] state; // Register to store the current state

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Asynchronous reset
        state <= 2'b00; // Initial state: idle
        data_in_history <= 3'b000; // Reset history
        data_out <= 1'b0;
    end else begin
        // Shift in the new value of data_in
        data_in_history <= {data_in, data_in_history[2:1]};
        
        case (state)
            2'b00: begin // Idle state
                if (data_in) begin
                    state <= 2'b01; // Move to waiting state
                end
                data_out <= 1'b0;
            end
            
            2'b01: begin // Waiting state
                if (~data_in && data_in_history[1] && ~data_in_history[2]) begin
                    state <= 2'b00; // Move back to idle state
                    data_out <= 1'b1; // Output pulse signal
                end else if (~data_in) begin
                    state <= 2'b00; // Move back to idle state
                    data_out <= 1'b0;
                end
            end
            
            default: begin
                state <= 2'b00;
                data_out <= 1'b0;
            end
        endcase
    end
end

endmodule