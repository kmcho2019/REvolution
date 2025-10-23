module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] count; // 2-bit counter to track consecutive high cycles
reg prev_data_in; // Register to store previous value of data_in

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Asynchronous reset
        count <= 0;
        prev_data_in <= 0;
        data_out <= 0;
    end else begin
        if (data_in) begin // data_in is high
            count <= count + 1;
        end else if (prev_data_in) begin // data_in was high and now is low
            if (count > 0) begin // Pulse detected
                data_out <= 1;
            end else begin
                data_out <= 0;
            end
            count <= 0; // Reset counter
        end else begin // data_in is low and was low
            data_out <= 0;
            count <= 0; // Reset counter
        end
        prev_data_in <= data_in; // Update previous data_in value
    end
end

endmodule