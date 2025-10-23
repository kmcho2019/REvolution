module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    reg prev_data_in, curr_data_in;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            prev_data_in <= 1'b0;
            curr_data_in <= 1'b0;
            data_out <= 1'b0;
        end else begin
            prev_data_in <= curr_data_in;
            curr_data_in <= data_in;

            // Detect pattern 0->1->0 over three cycles:
            // prev_data_in=0, curr_data_in=1, data_in=0
            if ((prev_data_in == 1'b0) && (curr_data_in == 1'b1) && (data_in == 1'b0))
                data_out <= 1'b1;
            else
                data_out <= 1'b0;
        end
    end

endmodule