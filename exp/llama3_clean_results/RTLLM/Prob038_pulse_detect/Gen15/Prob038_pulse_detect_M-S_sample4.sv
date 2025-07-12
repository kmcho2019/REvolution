module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg prev_data_in; // Previous value of data_in
reg pulse_state; // Pulse detection state

// Sequential logic to update previous values and pulse state
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Asynchronous reset
        prev_data_in <= 1'b0;
        pulse_state <= 1'b0;
    end else begin
        prev_data_in <= data_in;
        if (data_in == 1'b1 && prev_data_in == 1'b0) begin
            pulse_state <= 1'b1;
        end else if (data_in == 1'b0 && prev_data_in == 1'b1 && pulse_state == 1'b1) begin
            pulse_state <= 1'b0;
        end else begin
            pulse_state <= 1'b0;
        end
    end
end

// Combinational logic to generate output
assign data_out = (data_in == 1'b0 && prev_data_in == 1'b1 && pulse_state == 1'b1);

endmodule