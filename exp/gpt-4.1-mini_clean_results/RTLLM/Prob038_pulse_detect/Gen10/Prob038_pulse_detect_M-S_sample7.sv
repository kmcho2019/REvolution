module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    reg data_in_d;  // delayed data_in to detect edges
    reg detecting;  // high when pulse detection sequence is in progress (saw leading 0)

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_in_d <= 1'b0;
            detecting <= 1'b0;
            data_out <= 1'b0;
        end else begin
            data_in_d <= data_in;

            // Default output
            data_out <= 1'b0;

            if (!detecting) begin
                // Not detecting pulse, wait for data_in == 0 to start detection
                if (data_in == 1'b0)
                    detecting <= 1'b1; // start detection
            end else begin
                // detecting == 1, pulse detection in progress
                // check for 0->1->0 pattern over three cycles:
                // 1) we have seen initial 0 (detecting==1)
                // 2) detect rising edge (data_in_d==0 and data_in==1)
                // 3) then detect falling edge (data_in_d==1 and data_in==0), pulse done here

                // Detect falling edge indicating pulse completion
                if (data_in_d == 1'b1 && data_in == 1'b0) begin
                    data_out <= 1'b1;   // pulse detected
                    detecting <= 1'b0;  // reset to wait for next pulse
                end else if (data_in == 1'b0 && data_in_d == 1'b0) begin
                    // no rising edge detected yet, still waiting for the 1 in pulse
                    // keep detecting
                end else if (data_in == 1'b1 && data_in_d == 1'b0) begin
                    // rising edge detected, wait for falling edge next
                end else if (data_in == 1'b1 && data_in_d == 1'b1) begin
                    // data_in stayed high, still waiting for falling edge
                end else begin
                    // any other unexpected pattern resets detection to catch new pulses
                    detecting <= (data_in == 1'b0);
                end
            end
        end
    end

endmodule