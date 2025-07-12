module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    reg data_in_d1, data_in_d2;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            data_in_d1 <= 1'b0;
            data_in_d2 <= 1'b0;
            data_out   <= 1'b0;
        end else begin
            data_in_d1 <= data_in;
            data_in_d2 <= data_in_d1;
            // Detect 0->1->0 pattern on data_in over three cycles:
            // data_in_d2=0, data_in_d1=1, data_in=0 means pulse detected at current cycle
            data_out <= (~data_in) & data_in_d1 & (~data_in_d2);
        end
    end

endmodule