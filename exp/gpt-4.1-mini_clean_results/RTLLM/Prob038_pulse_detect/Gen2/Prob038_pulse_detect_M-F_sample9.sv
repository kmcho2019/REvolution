module pulse_detect (
    input wire clk,
    input wire rst_n,
    input wire data_in,
    output reg data_out
);

    // Registers to hold delayed versions of data_in
    reg data_in_d1;  // data_in delayed by 1 clock cycle
    reg data_in_d2;  // data_in delayed by 2 clock cycles

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_in_d1 <= 1'b0;
            data_in_d2 <= 1'b0;
            data_out <= 1'b0;
        end else begin
            // Shift data_in samples for pulse pattern detection
            data_in_d2 <= data_in_d1;
            data_in_d1 <= data_in;

            // Detect pulse pattern: 0->1->0 over three consecutive cycles:
            // data_in_d2 = 0 (N-2), data_in_d1 = 1 (N-1), data_in = 0 (N)
            if (data_in_d2 == 1'b0 && data_in_d1 == 1'b1 && data_in == 1'b0)
                data_out <= 1'b1;  // Pulse detected at current cycle
            else
                data_out <= 1'b0;  // Otherwise, no pulse output
        end
    end

endmodule