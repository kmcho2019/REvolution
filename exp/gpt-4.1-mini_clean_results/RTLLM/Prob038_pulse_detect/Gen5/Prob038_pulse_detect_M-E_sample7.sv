module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // Registers to hold delayed versions of data_in
    reg data_in_d1, data_in_d2;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_in_d1 <= 1'b0;
            data_in_d2 <= 1'b0;
            data_out   <= 1'b0;
        end else begin
            // Shift the data_in samples
            data_in_d2 <= data_in_d1;
            data_in_d1 <= data_in;

            // Detect the pattern 0 -> 1 -> 0 on (data_in_d2, data_in_d1, data_in)
            // That is: data_in_d2 == 0, data_in_d1 == 1, data_in == 0
            if (data_in_d2 == 1'b0 && data_in_d1 == 1'b1 && data_in == 1'b0)
                data_out <= 1'b1;
            else
                data_out <= 1'b0;
        end
    end

endmodule