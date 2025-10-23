module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    reg data_in_d1, data_in_d2;  // delay registers to hold previous cycles' data_in

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_in_d1 <= 1'b0;
            data_in_d2 <= 1'b0;
            data_out   <= 1'b0;
        end else begin
            data_in_d2 <= data_in_d1;
            data_in_d1 <= data_in;

            // Detect pulse pattern: 0 -> 1 -> 0 over three cycles
            if ((data_in == 1'b0) && (data_in_d1 == 1'b1) && (data_in_d2 == 1'b0))
                data_out <= 1'b1;
            else
                data_out <= 1'b0;
        end
    end

endmodule