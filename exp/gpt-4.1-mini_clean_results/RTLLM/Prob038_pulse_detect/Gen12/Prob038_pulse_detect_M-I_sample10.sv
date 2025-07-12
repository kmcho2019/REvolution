module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    reg data_in_dly;        // Registered previous value of data_in
    reg pulse_started;      // Flag indicating rising edge detected (pulse start)

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            data_in_dly   <= 1'b0;
            pulse_started <= 1'b0;
            data_out      <= 1'b0;
        end else begin
            // Register previous input value
            data_in_dly <= data_in;

            // Detect rising edge: data_in rising from 0 to 1
            if (~data_in_dly & data_in)
                pulse_started <= 1'b1;

            // Detect falling edge after pulse started: data_in falling from 1 to 0
            else if (pulse_started & data_in_dly & ~data_in) begin
                data_out      <= 1'b1;    // Output pulse detected
                pulse_started <= 1'b0;    // Reset pulse flag
            end else begin
                data_out <= 1'b0;         // Otherwise, output low
            end
        end
    end

endmodule