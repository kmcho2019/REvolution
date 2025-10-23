module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg prev_data_in;
reg [1:0] counter;

always @(posedge clk) begin
    if (!rst_n) begin
        prev_data_in <= 0;
        counter <= 0;
        data_out <= 0;
    end else begin
        prev_data_in <= data_in;
        if (data_in && !prev_data_in) begin // Rising edge
            counter <= 1;
        end else if (data_in) begin // High state
            counter <= counter + 1;
        end else if (counter >= 1) begin // Falling edge
            counter <= 0;
            data_out <= 1; // Set data_out to 1 to indicate pulse
        end else begin
            data_out <= 0; // Reset data_out
        end
    end
end

endmodule