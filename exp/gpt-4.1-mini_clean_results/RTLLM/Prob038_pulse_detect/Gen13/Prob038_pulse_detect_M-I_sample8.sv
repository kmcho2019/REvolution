module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    reg data_in_d1, data_in_d2;

    always @(posedge clk) begin
        if (!rst_n) begin
            data_in_d1 <= 1'b0;
            data_in_d2 <= 1'b0;
            data_out   <= 1'b0;
        end else begin
            data_in_d2 <= data_in_d1;
            data_in_d1 <= data_in;

            // Detect the pulse pattern 0->1->0:
            // data_in_d2 == 0 (two cycles ago)
            // data_in_d1 == 1 (previous cycle)
            // data_in == 0 (current cycle)
            if ((data_in_d2 == 1'b0) && (data_in_d1 == 1'b1) && (data_in == 1'b0))
                data_out <= 1'b1;
            else
                data_out <= 1'b0;
        end
    end

endmodule