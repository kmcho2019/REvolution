module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    reg data_in_dly;  // delayed version of data_in

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            data_in_dly <= 1'b0;
            data_out <= 1'b0;
        end else begin
            data_out <= (data_in_dly == 1'b1) && (data_in == 1'b0);
            data_in_dly <= data_in;
        end
    end

endmodule