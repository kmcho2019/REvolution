module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // Registers to hold delayed versions of data_in
    reg data_in_d1;  // delayed by 1 clock cycle
    reg data_in_d2;  // delayed by 2 clock cycles

    // Shift registers for data_in sampling
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_in_d1 <= 1'b0;
            data_in_d2 <= 1'b0;
        end else begin
            data_in_d2 <= data_in_d1;
            data_in_d1 <= data_in;
        end
    end

    // Pulse detection and output generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= 1'b0;
        end else begin
            // Detect pattern 0->1->0 on data_in_d2, data_in_d1, data_in respectively
            if ((data_in_d2 == 1'b0) && (data_in_d1 == 1'b1) && (data_in == 1'b0))
                data_out <= 1'b1;  // Pulse detected at current cycle
            else
                data_out <= 1'b0;  // No pulse detected
        end
    end

endmodule