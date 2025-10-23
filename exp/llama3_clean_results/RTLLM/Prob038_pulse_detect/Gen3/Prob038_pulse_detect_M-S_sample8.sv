module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg prev_data_in;
reg detected;

// Sequential logic for current state and output signal
always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        prev_data_in <= 0;
        detected <= 0;
        data_out <= 0;
    end else begin
        prev_data_in <= data_in;
        if (prev_data_in == 0 && data_in == 1) begin
            detected <= 1;
        end else if (prev_data_in == 1 && data_in == 0) begin
            data_out <= 1;
            detected <= 0;
        end else begin
            detected <= 0;
        end
        if (detected && data_in == 0) begin
            data_out <= 1;
            detected <= 0;
        end else begin
            data_out <= 0;
        end
    end
end

endmodule