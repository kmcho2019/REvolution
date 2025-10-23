module pulse_detect(
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    reg prev_data_in;
    reg pulse_started;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            prev_data_in <= 1'b0;
            pulse_started <= 1'b0;
            data_out <= 1'b0;
        end else begin
            // Detect rising edge: data_in goes from 0 to 1
            if (~prev_data_in && data_in) begin
                pulse_started <= 1'b1;
                data_out <= 1'b0;
            end
            // Detect falling edge: data_in goes from 1 to 0 and pulse_started is set
            else if (prev_data_in && ~data_in && pulse_started) begin
                data_out <= 1'b1;   // pulse completed at this cycle
                pulse_started <= 1'b0; // reset for next pulse
            end else begin
                data_out <= 1'b0;
            end

            prev_data_in <= data_in;
        end
    end

endmodule