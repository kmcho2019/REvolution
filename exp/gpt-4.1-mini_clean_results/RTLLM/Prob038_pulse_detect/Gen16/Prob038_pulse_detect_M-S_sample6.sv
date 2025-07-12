module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    reg data_in_d1, data_in_d2;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_in_d1 <= 1'b0;
            data_in_d2 <= 1'b0;
            data_out   <= 1'b0;
        end else begin
            data_in_d1 <= data_in;
            data_in_d2 <= data_in_d1;
            // Detect falling edge of data_in (1->0) after it was high
            data_out <= data_in_d2 & (~data_in_d1);
        end
    end

endmodule