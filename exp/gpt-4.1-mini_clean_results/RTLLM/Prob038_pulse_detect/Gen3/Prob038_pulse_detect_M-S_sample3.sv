module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    reg prev_data_in;
    reg pulse_started;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            prev_data_in   <= 1'b0;
            pulse_started  <= 1'b0;
            data_out      <= 1'b0;
        end else begin
            data_out <= 1'b0; // default

            // Detect rising edge 0->1 on data_in to start pulse
            if (~prev_data_in && data_in)
                pulse_started <= 1'b1;

            // Detect falling edge 1->0 on data_in to end pulse
            if (pulse_started && prev_data_in && ~data_in) begin
                data_out     <= 1'b1;    // Pulse detected at end cycle
                pulse_started <= 1'b0;   // Reset for next pulse
            end

            prev_data_in <= data_in;
        end
    end

endmodule